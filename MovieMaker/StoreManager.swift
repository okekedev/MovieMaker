//
//  StoreManager.swift
//  Channel Link
//
//  Handles StoreKit 2 subscriptions and Pro status
//

import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {

    // MARK: - Development Flag
    // Set to true to enable Pro features without purchase (for testing only)
    private let ENABLE_PRO_FOR_DEVELOPMENT = false

    // MARK: - Published Properties
    @Published var isPro: Bool = false
    @Published var isLoading: Bool = false
    @Published var products: [Product] = []
    /// Coin balance. 1 coin = 1 export. New users get `initialFreeCoins` free;
    /// buy more via consumable IAP or go unlimited via subscription.
    @Published var coinBalance: Int = 0

    // MARK: - Free tier config
    /// Coins granted on first launch — the trial the user gets before any paywall.
    /// User starts with 1; the first-ever Daily Spin is guaranteed +2 to seed them at 3.
    static let initialFreeCoins = 1
    private let coinBalanceKey = "moviemaker.coinBalance"
    private let coinsInitializedKey = "moviemaker.coinsInitialized"
    // Legacy key from v2.3 (used-count model). Migrated on first launch of v2.4.
    private let legacyFreeExportsUsedKey = "moviemaker.freeExportsUsed"

    // MARK: - Daily Spin
    /// When the user last spun. Nil means they've never spun.
    @Published var lastSpinDate: Date?
    private let lastSpinKey = "moviemaker.lastSpinDate"

    /// Daily spin rules:
    ///   - First-ever spin: guaranteed win of 2 coins (seeds user to 3 total).
    ///   - Subsequent spins:
    ///       1/16 (6.25%) → +2 coins  (rare jackpot)
    ///       1/4  (25%)   → +1 coin
    ///       otherwise    → nothing (come back tomorrow)
    static let spinChance2Coins: Double = 1.0 / 16.0
    static let spinChance1Coin:  Double = 1.0 / 4.0

    /// Has today already been spun?
    var hasSpunToday: Bool {
        guard let last = lastSpinDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    /// User is eligible to spin now.
    var canSpinNow: Bool { !hasSpunToday }

    /// Result of a spin — announced back to the UI to animate the reveal.
    enum SpinResult {
        case win(Int)
        case lose
    }

    /// Roll the spin. Persists the spin date and credits coins if won.
    func performSpin() -> SpinResult {
        guard canSpinNow else { return .lose }

        let firstEver = lastSpinDate == nil
        let result: SpinResult
        if firstEver {
            // Guaranteed +2 seeds new users at 3 total coins.
            result = .win(2)
        } else {
            let r = Double.random(in: 0..<1)
            if r < Self.spinChance2Coins {
                result = .win(2)
            } else if r < Self.spinChance1Coin {
                // Note: uses the same [0..0.25) range, mutually exclusive with
                // the 2-coin bucket above. Effective: 18.75% for +1.
                result = .win(1)
            } else {
                result = .lose
            }
        }

        if case .win(let amount) = result {
            addCoins(amount)
        }

        let now = Date()
        lastSpinDate = now
        UserDefaults.standard.set(now, forKey: lastSpinKey)

        return result
    }

    /// Whether the user can start a new export right now without hitting the paywall.
    var canStartExport: Bool {
        isPro || coinBalance > 0
    }

    // MARK: - Product IDs
    // NOTE: These must match your App Store Connect configuration
    // and the .storekit file used for local testing.
    static let monthlySubscriptionID = "com.christianokeke.moviemaker.pro.monthly"
    static let yearlySubscriptionID  = "com.christianokeke.moviemaker.pro.yearly"
    static let coins5ID              = "com.christianokeke.moviemaker.coins.5"
    static let coins15ID             = "com.christianokeke.moviemaker.coins.15"

    static let subscriptionIDs = [monthlySubscriptionID, yearlySubscriptionID]
    static let consumableIDs   = [coins5ID, coins15ID]
    static let allProductIDs   = subscriptionIDs + consumableIDs

    /// How many coins a consumable product grants when purchased.
    static func coinsForProduct(_ id: String) -> Int {
        switch id {
        case coins5ID:  return 5
        case coins15ID: return 15
        default:        return 0
        }
    }

    // MARK: - Transaction Updates
    private var updateListenerTask: Task<Void, Error>? = nil

    // MARK: - Initialization
    init() {
        // First-launch bootstrap: either initialize with the free trial coins
        // or migrate from the v2.3 "freeExportsUsed" counter.
        let ud = UserDefaults.standard
        if ud.bool(forKey: coinsInitializedKey) {
            coinBalance = ud.integer(forKey: coinBalanceKey)
        } else {
            let migrated = max(0, Self.initialFreeCoins - ud.integer(forKey: legacyFreeExportsUsedKey))
            coinBalance = migrated
            ud.set(coinBalance, forKey: coinBalanceKey)
            ud.set(true, forKey: coinsInitializedKey)
            ud.removeObject(forKey: legacyFreeExportsUsedKey)
        }
        // Restore last spin date (nil if never spun).
        lastSpinDate = ud.object(forKey: lastSpinKey) as? Date

        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()

        Task {
            await loadProducts()
            await updateProStatus()
        }
    }

    /// Called by the export flow after a video is successfully saved to Photos.
    /// No-op for Pro users — subscription bypasses the coin check entirely.
    func recordExport() {
        guard !isPro else { return }
        coinBalance = max(0, coinBalance - 1)
        UserDefaults.standard.set(coinBalance, forKey: coinBalanceKey)
    }

    /// Credit coins from a completed consumable purchase.
    func addCoins(_ n: Int) {
        guard n > 0 else { return }
        coinBalance += n
        UserDefaults.standard.set(coinBalance, forKey: coinBalanceKey)
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Product Loading
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let loadedProducts = try await Product.products(for: Self.allProductIDs)

            DispatchQueue.main.async {
                // Sort so the paywall UI can rely on a stable order:
                // consumables first (cheap → expensive), then subs (monthly → yearly).
                let order = Self.consumableIDs + Self.subscriptionIDs
                self.products = loadedProducts.sorted { a, b in
                    (order.firstIndex(of: a.id) ?? 99) < (order.firstIndex(of: b.id) ?? 99)
                }
                print("✅ Loaded \(loadedProducts.count) products")
            }
        } catch {
            print("❌ Failed to load products: \(error)")
        }
    }

    /// Convenience lookup by product ID for the paywall UI.
    func product(id: String) -> Product? {
        products.first { $0.id == id }
    }

    // MARK: - Purchase
    func purchase(_ product: Product) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }

        // Start purchase
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            // Verify the transaction
            let transaction = try StoreManager.checkVerified(verification)

            // Consumable = grant coins. Subscription = flip isPro on.
            // Handled by the same function used by the background transaction
            // listener, so we don't double-credit if both paths race.
            await handleVerified(transaction)

            // Finish the transaction
            await transaction.finish()

            print("✅ Purchase successful: \(product.id)")
            return true

        case .userCancelled:
            print("ℹ️ User cancelled purchase")
            return false

        case .pending:
            print("⏳ Purchase pending")
            return false

        @unknown default:
            print("⚠️ Unknown purchase result")
            return false
        }
    }

    /// Apply the effect of a verified transaction. Consumables grant coins
    /// exactly once per unique transaction ID (idempotent even if the App Store
    /// resends). Subscriptions just trigger a Pro re-check.
    private func handleVerified(_ transaction: Transaction) async {
        if Self.consumableIDs.contains(transaction.productID) {
            // Idempotency: guard against re-applying the same transaction if
            // the App Store re-delivers it after a crash between crediting
            // and calling .finish().
            let key = "moviemaker.processedTx.\(transaction.id)"
            let ud = UserDefaults.standard
            if !ud.bool(forKey: key) {
                addCoins(Self.coinsForProduct(transaction.productID))
                ud.set(true, forKey: key)
            }
        } else if Self.subscriptionIDs.contains(transaction.productID) {
            await updateProStatus()
        }
    }

    // MARK: - Restore Purchases
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Sync with App Store
            try await AppStore.sync()

            // Update Pro status
            await updateProStatus()

            print("✅ Purchases restored")
        } catch {
            print("❌ Failed to restore purchases: \(error)")
        }
    }

    // MARK: - Pro Status
    func updateProStatus() async {
        // Screenshot / demo hook: MM_PRO=1 pins isPro on regardless of receipt.
        // Safe because isPro=true is a bypass, not a state that grants entitlements.
        if ProcessInfo.processInfo.environment["MM_PRO"] == "1" {
            DispatchQueue.main.async { self.isPro = true }
            return
        }
        // Check development flag first
        if ENABLE_PRO_FOR_DEVELOPMENT {
            DispatchQueue.main.async {
                self.isPro = true
                print("🔓 Pro features enabled (development mode)")
            }
            return
        }

        var isProUser = false

        // Any active subscription in the Pro family flips isPro on.
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try StoreManager.checkVerified(result)
                if Self.subscriptionIDs.contains(transaction.productID) {
                    isProUser = true
                    break
                }
            } catch {
                print("❌ Transaction verification failed: \(error)")
            }
        }

        DispatchQueue.main.async {
            self.isPro = isProUser
            print(self.isPro ? "✅ User is Pro" : "ℹ️ User is Free")
        }
    }

    // MARK: - Transaction Listener
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try StoreManager.checkVerified(result)

                    Task { @MainActor in
                        await self.handleVerified(transaction)
                    }

                    await transaction.finish()
                } catch {
                    print("❌ Transaction verification failed: \(error)")
                }
            }
        }
    }

    // MARK: - Transaction Verification
    nonisolated static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - Store Errors
enum StoreError: Error {
    case failedVerification
}

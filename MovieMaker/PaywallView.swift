//
//  PaywallView.swift
//  Channel Link
//
//  Buy sheet — grants coins (consumable IAPs) or unlimited exports (subscription).
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.dismiss) var dismiss
    @State private var showProductLoadError = false
    @State private var showPurchaseError = false
    @State private var purchaseErrorMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: Color.brandGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28.scaled) {
                    Spacer().frame(height: 24.scaled)

                    // Balance / hero — coins are the monetization; features are free.
                    balanceHero

                    // Reassurance: every editing feature is included, coins just
                    // let you save finished videos. (Replaces the old "unlock these
                    // features" pitch, which no longer applies — all features free.)
                    includedBlock

                    // Products
                    if storeManager.products.isEmpty {
                        productLoadingState
                    } else {
                        coinsSection
                        subscriptionSection
                    }

                    // Restore + legal
                    restoreAndLegal

                    // Continue with free
                    Button(action: { dismiss() }) {
                        Text("Not now")
                            .font(.system(size: 15.scaled))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.bottom, 40.scaled)
                }
                .padding(.horizontal, 24.scaled)
                .iPadReadableWidth()
            }
        }
        .alert("Purchase Error", isPresented: $showPurchaseError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(purchaseErrorMessage)
        }
    }

    // MARK: - Sections

    private var balanceHero: some View {
        VStack(spacing: 14.scaled) {
            GoldCoin(size: 56.scaled)

            Text(storeManager.isPro ? "Unlimited Videos" : "Get More Videos")
                .font(.system(size: 30.scaled, weight: .bold))
                .foregroundColor(.white)

            if storeManager.isPro {
                Text("You have unlimited exports")
                    .font(.system(size: 16.scaled))
                    .foregroundColor(.white.opacity(0.9))
            } else {
                HStack(spacing: 6.scaled) {
                    Text("You have")
                    Text("\(storeManager.coinBalance)")
                        .fontWeight(.bold)
                    GoldCoin(size: 18.scaled)
                    Text(storeManager.coinBalance == 1 ? "coin" : "coins")
                    Text("· 1 coin = 1 video")
                        .foregroundColor(.white.opacity(0.7))
                }
                .font(.system(size: 16.scaled))
                .foregroundColor(.white.opacity(0.9))
            }
        }
    }

    // Every editing feature is free for all users now — coins only pay for
    // saving finished videos. This reassures buyers what they're actually paying for.
    private var includedBlock: some View {
        VStack(spacing: 10.scaled) {
            Text("Every feature included — free")
                .font(.system(size: 15.scaled, weight: .semibold))
                .foregroundColor(.white)
            HStack(spacing: 18.scaled) {
                includedItem("music.note", "Music")
                includedItem("slowmo", "Slow-Mo")
                includedItem("wand.and.stars", "HD Export")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18.scaled)
        .padding(.horizontal, 16.scaled)
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
    }

    private func includedItem(_ icon: String, _ label: String) -> some View {
        VStack(spacing: 6.scaled) {
            Image(systemName: icon)
                .font(.system(size: 22.scaled))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 12.scaled, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
        }
    }

    private var coinsSection: some View {
        VStack(alignment: .leading, spacing: 10.scaled) {
            Text("Buy coins")
                .font(.system(size: 16.scaled, weight: .semibold))
                .foregroundColor(.white)

            if let coins5 = storeManager.product(id: StoreManager.coins5ID) {
                CoinTierRow(
                    coins: 5,
                    price: coins5.displayPrice,
                    tag: nil,
                    action: { purchase(coins5) }
                )
            }
            if let coins15 = storeManager.product(id: StoreManager.coins15ID) {
                CoinTierRow(
                    coins: 15,
                    price: coins15.displayPrice,
                    tag: "Best value",
                    action: { purchase(coins15) }
                )
            }
        }
    }

    private var subscriptionSection: some View {
        let monthly = storeManager.product(id: StoreManager.monthlySubscriptionID)
        let yearly = storeManager.product(id: StoreManager.yearlySubscriptionID)
        return VStack(alignment: .leading, spacing: 10.scaled) {
            Text("Or go unlimited")
                .font(.system(size: 16.scaled, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top, 4.scaled)

            if let monthly {
                SubTierRow(
                    title: "Monthly",
                    priceLine: "\(monthly.displayPrice) / month",
                    trailingBadge: nil,                       // baseline — no savings badge
                    action: { purchase(monthly) }
                )
            }
            if let yearly {
                SubTierRow(
                    title: "Yearly",
                    priceLine: "\(yearly.displayPrice) / year",
                    trailingBadge: yearlySavingsBadge(monthly: monthly, yearly: yearly),
                    action: { purchase(yearly) }
                )
            }
        }
    }

    // Real yearly savings vs. paying monthly for 12 months, computed from live
    // prices so the badge always matches the store instead of a hardcoded %.
    private func yearlySavingsBadge(monthly: Product?, yearly: Product) -> String? {
        guard let monthly else { return nil }
        let annual = (monthly.price as NSDecimalNumber).doubleValue * 12
        let yr = (yearly.price as NSDecimalNumber).doubleValue
        guard annual > 0, yr < annual else { return nil }
        let pct = Int((((annual - yr) / annual) * 100).rounded())
        return pct > 0 ? "Save \(pct)%" : nil
    }

    private var restoreAndLegal: some View {
        VStack(spacing: 16) {
            Button(action: {
                Task {
                    await storeManager.restorePurchases()
                    if storeManager.isPro { dismiss() }
                }
            }) {
                Text("Restore Purchases")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.85))
            }
            .disabled(storeManager.isLoading)

            HStack(spacing: 12) {
                Link("Privacy", destination: URL(string: "https://okekedev.github.io/MovieMaker/privacy.html")!)
                Text("•").foregroundColor(.white.opacity(0.4))
                Link("Terms", destination: URL(string: "https://okekedev.github.io/MovieMaker/terms.html")!)
                Text("•").foregroundColor(.white.opacity(0.4))
                Link("Support", destination: URL(string: "https://okekedev.github.io/MovieMaker/support.html")!)
            }
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.6))
        }
    }

    private var productLoadingState: some View {
        VStack(spacing: 12) {
            if showProductLoadError {
                Text("Unable to load products")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Button(action: {
                    showProductLoadError = false
                    Task {
                        await storeManager.loadProducts()
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                        if storeManager.products.isEmpty { showProductLoadError = true }
                    }
                }) {
                    Text("Retry")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 5_000_000_000)
                            if storeManager.products.isEmpty { showProductLoadError = true }
                        }
                    }
            }
        }
        .padding(.vertical, 30)
    }

    // MARK: - Helpers

    private func purchase(_ product: Product) {
        Task {
            do {
                let success = try await storeManager.purchase(product)
                if success { dismiss() }
            } catch {
                purchaseErrorMessage = "Unable to complete purchase. Please try again."
                showPurchaseError = true
            }
        }
    }

    /// Per-coin price string using the product's own locale/currency.
    private func perCoinCopy(product: Product, coins: Int) -> String {
        let unit = product.price / Decimal(coins)
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.locale = product.priceFormatStyle.locale
        if let s = fmt.string(from: unit as NSNumber) {
            return "\(s) each"
        }
        return ""
    }

    /// If the subscription has an introductory offer (free trial), surface it as a badge.
    private func introOfferBadge(for product: Product) -> String? {
        guard let sub = product.subscription, let offer = sub.introductoryOffer else { return nil }
        switch offer.paymentMode {
        case .freeTrial:
            let days = offer.period.value * offer.period.unit.approxDays
            return "\(days)-day free trial"
        default:
            return nil
        }
    }
}

// MARK: - Feature Row (unchanged shape)
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                Text(description).font(.system(size: 13)).foregroundColor(.white.opacity(0.85))
            }
            Spacer()
        }
    }
}

// MARK: - Coin tier row
struct CoinTierRow: View {
    let coins: Int
    let price: String
    let tag: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8.scaled) {
                Text("\(coins) coins")
                    .font(.system(size: 16.scaled, weight: .semibold))
                    .foregroundColor(.brandPrimary)
                if let tag {
                    Text(tag)
                        .font(.system(size: 10.scaled, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6.scaled)
                        .padding(.vertical, 2.scaled)
                        .background(Color.brandSecondary)
                        .cornerRadius(4)
                }
                Spacer()
                Text(price)
                    .font(.system(size: 16.scaled, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }
            .padding(14.scaled)
            .background(Color.white)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Subscription tier row
struct SubTierRow: View {
    let title: String
    let priceLine: String
    let trailingBadge: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12.scaled) {
                VStack(alignment: .leading, spacing: 2.scaled) {
                    Text(title)
                        .font(.system(size: 16.scaled, weight: .semibold))
                        .foregroundColor(.brandPrimary)
                    Text(priceLine)
                        .font(.system(size: 13.scaled))
                        .foregroundColor(.secondary)
                }
                Spacer()
                if let trailingBadge {
                    Text(trailingBadge)
                        .font(.system(size: 11.scaled, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8.scaled)
                        .padding(.vertical, 4.scaled)
                        .background(Color.brandSecondary)
                        .cornerRadius(6)
                }
            }
            .padding(14.scaled)
            .background(Color.white)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// Gold coin glyph — dollar sign in a gold-gradient circle. Feels like a
// coin, doesn't rely on emoji rendering (which varies by iOS version).
struct GoldCoin: View {
    var size: CGFloat = 24

    var body: some View {
        ZStack {
            // Gold body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.00, green: 0.90, blue: 0.35),
                            Color(red: 0.98, green: 0.72, blue: 0.12),
                            Color(red: 0.80, green: 0.55, blue: 0.05),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            // Darker rim
            Circle()
                .stroke(Color(red: 0.55, green: 0.38, blue: 0.02), lineWidth: max(1, size * 0.045))
            // Subtle inner ring for coin depth
            Circle()
                .stroke(Color(red: 1.0, green: 0.95, blue: 0.55).opacity(0.7), lineWidth: max(0.5, size * 0.03))
                .padding(size * 0.12)
            // Dollar sign
            Image(systemName: "dollarsign")
                .font(.system(size: size * 0.55, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(red: 0.55, green: 0.38, blue: 0.02),
                                 Color(red: 0.72, green: 0.50, blue: 0.03)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
        }
        .frame(width: size, height: size)
    }
}

// Small helper to turn StoreKit's Product.SubscriptionPeriod.Unit into an
// approximate number of days for trial-length copy.
private extension Product.SubscriptionPeriod.Unit {
    var approxDays: Int {
        switch self {
        case .day:   return 1
        case .week:  return 7
        case .month: return 30
        case .year:  return 365
        @unknown default: return 0
        }
    }
}

//
//  StoreManagerTests.swift
//  MovieMakerTests
//
//  Tests StoreManager's coin + Pro accounting directly, without going through
//  StoreKit itself. StoreKit is Apple's code; what we own (and what breaks in
//  practice) is the balance/state math on top of it.
//
//  Covers the same 5 checks the user asked about, phrased as unit tests:
//    • addCoins(5)  → balance +5, isPro unchanged
//    • addCoins(15) → balance +15, isPro unchanged
//    • flip isPro on (as if monthly sub verified) → coin metering bypassed
//    • flip isPro on (as if yearly sub verified)  → same behaviour
//    • coin balance persists across StoreManager re-init (restore semantics)
//

import XCTest
@testable import MovieMaker

@MainActor
final class StoreManagerTests: XCTestCase {
    var store: StoreManager!

    override func setUp() async throws {
        try await super.setUp()

        // Wipe UserDefaults keys so we start fresh at initialFreeCoins.
        for key in [
            "moviemaker.coinBalance",
            "moviemaker.coinsInitialized",
            "moviemaker.freeExportsUsed",
            "moviemaker.lastSpinDate",
        ] {
            UserDefaults.standard.removeObject(forKey: key)
        }
        // Also clear any leftover consumable idempotency markers.
        for key in UserDefaults.standard.dictionaryRepresentation().keys
            where key.hasPrefix("moviemaker.processedTx.") {
            UserDefaults.standard.removeObject(forKey: key)
        }

        store = StoreManager()
        XCTAssertEqual(store.coinBalance, StoreManager.initialFreeCoins,
                       "fresh install should seed with initialFreeCoins")
        XCTAssertFalse(store.isPro, "fresh install is not Pro")
    }

    override func tearDown() async throws {
        store = nil
        try await super.tearDown()
    }

    // MARK: - Consumable coin accounting

    func testBuy5CoinsIncrementsBy5() {
        let before = store.coinBalance
        store.addCoins(5)
        XCTAssertEqual(store.coinBalance, before + 5,
                       "buying the 5-coin pack should add exactly 5 coins")
        XCTAssertFalse(store.isPro, "consumables must not flip isPro on")
    }

    func testBuy15CoinsIncrementsBy15() {
        let before = store.coinBalance
        store.addCoins(15)
        XCTAssertEqual(store.coinBalance, before + 15,
                       "buying the 15-coin pack should add exactly 15 coins")
        XCTAssertFalse(store.isPro)
    }

    func testCoinsAreCumulativeAcrossPurchases() {
        let before = store.coinBalance
        store.addCoins(5)
        store.addCoins(15)
        store.addCoins(5)
        XCTAssertEqual(store.coinBalance, before + 25)
    }

    func testAddCoinsGuardsAgainstNegativeOrZero() {
        let before = store.coinBalance
        store.addCoins(0)
        store.addCoins(-3)
        XCTAssertEqual(store.coinBalance, before,
                       "addCoins should no-op on zero/negative amounts")
    }

    // MARK: - Export metering

    func testExportDecrementsCoinBalance() {
        store.addCoins(3)
        let before = store.coinBalance
        store.recordExport()
        XCTAssertEqual(store.coinBalance, before - 1)
    }

    func testExportFloorsAtZero() {
        // Burn everything, then try one more.
        while store.coinBalance > 0 { store.recordExport() }
        store.recordExport()
        XCTAssertEqual(store.coinBalance, 0,
                       "recordExport must never go negative")
    }

    func testCanStartExportReflectsBalance() {
        XCTAssertTrue(store.canStartExport,
                      "starts free with initialFreeCoins in the balance")
        while store.coinBalance > 0 { store.recordExport() }
        XCTAssertFalse(store.canStartExport,
                       "no coins = cannot start export as a free user")
    }

    // MARK: - Pro bypass semantics

    func testProUserBypassesCoinMetering() {
        store.isPro = true
        let before = store.coinBalance
        store.recordExport()
        store.recordExport()
        store.recordExport()
        XCTAssertEqual(store.coinBalance, before,
                       "Pro users should not have coins deducted")
        XCTAssertTrue(store.canStartExport)
    }

    func testMonthlyProGrantsUnlimited() {
        // A monthly sub becomes isPro = true after handleVerified. Simulate.
        store.isPro = true
        XCTAssertTrue(store.canStartExport)
    }

    func testYearlyProGrantsUnlimited() {
        store.isPro = true
        XCTAssertTrue(store.canStartExport)
    }

    // MARK: - Persistence / restore semantics

    func testCoinBalancePersistsAcrossReInit() {
        store.addCoins(20)
        let saved = store.coinBalance

        // A new StoreManager instance should read the persisted balance —
        // this is exactly what happens after Restore Purchases when the app
        // relaunches, or after a subscription verification pass.
        store = nil
        store = StoreManager()
        XCTAssertEqual(store.coinBalance, saved,
                       "coin balance must survive StoreManager re-init")
    }

    func testFreshInitDoesNotDoubleGrantFreeCoins() {
        // First init: gets initialFreeCoins.
        XCTAssertEqual(store.coinBalance, StoreManager.initialFreeCoins)
        // Second init on same UserDefaults: keeps whatever's stored, does
        // NOT re-grant free coins.
        store.addCoins(2)
        let saved = store.coinBalance
        store = StoreManager()
        XCTAssertEqual(store.coinBalance, saved,
                       "second launch must not re-seed free coins")
    }

    // MARK: - Daily Spin

    func testFirstSpinIsGuaranteedTwoCoins() {
        let before = store.coinBalance
        let result = store.performSpin()
        if case .win(let n) = result {
            XCTAssertEqual(n, 2, "first spin should always award +2 coins")
        } else {
            XCTFail("first spin should not lose — user's onboarding hook")
        }
        XCTAssertEqual(store.coinBalance, before + 2)
    }

    func testCanOnlySpinOncePerDay() {
        _ = store.performSpin()
        XCTAssertFalse(store.canSpinNow,
                       "same-day second spin must be blocked")
    }
}

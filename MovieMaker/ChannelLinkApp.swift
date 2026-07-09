//
//  ChannelLinkApp.swift
//  ChannelLink
//
//  Created by Christian  on 11/3/25.
//

import SwiftUI

@main
struct ChannelLinkApp: App {
    @StateObject private var storeManager = StoreManager()

    /// Env vars for reproducible screenshot capture:
    ///   MM_SHOW_PAYWALL=1         → present the paywall on launch
    ///   MM_SHOW_SPIN=1            → present the daily spin on launch
    ///   MM_COIN_BALANCE=<N>       → force the free-tier balance to N
    ///   MM_PRO=1                  → force isPro on (bypasses paywall)
    /// See scripts/capture_screenshots.sh for usage.
    @State private var showPaywallOnLaunch: Bool =
        ProcessInfo.processInfo.environment["MM_SHOW_PAYWALL"] == "1"
    @State private var showSpinOnLaunch: Bool =
        ProcessInfo.processInfo.environment["MM_SHOW_SPIN"] == "1"

    init() {
        let env = ProcessInfo.processInfo.environment
        if let raw = env["MM_COIN_BALANCE"], let n = Int(raw) {
            UserDefaults.standard.set(n, forKey: "moviemaker.coinBalance")
            UserDefaults.standard.set(true, forKey: "moviemaker.coinsInitialized")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeManager)
                .task {
                    if ProcessInfo.processInfo.environment["MM_PRO"] == "1" {
                        // Dev-only Pro flip for screenshots — safe because coin logic
                        // treats isPro as bypass.
                        storeManager.isPro = true
                    }
                }
                .fullScreenCover(isPresented: $showPaywallOnLaunch) {
                    PaywallView().environmentObject(storeManager)
                }
                .sheet(isPresented: $showSpinOnLaunch) {
                    DailySpinView().environmentObject(storeManager)
                }
        }
    }
}

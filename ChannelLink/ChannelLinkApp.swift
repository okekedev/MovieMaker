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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storeManager)
        }
    }
}

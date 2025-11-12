//
//  PaywallView.swift
//  Channel Link
//
//  Pro subscription paywall
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
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: Color.brandGradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    Spacer().frame(height: 20)

                    // App Icon/Logo
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .shadow(radius: 10)

                        Image(systemName: "video.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: Color.primaryGradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }

                    // Title
                    VStack(spacing: 12) {
                        Text("Unlock Pro Features")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)

                        Text("Create unlimited video compilations")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.9))
                    }

                    // Feature list
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(icon: "infinity", title: "Unlimited Videos", description: "Create compilations with as many videos as you want")
                        FeatureRow(icon: "rectangle.landscape.rotate", title: "Portrait & Landscape", description: "Choose your preferred video orientation")
                        FeatureRow(icon: "music.note", title: "Background Music", description: "Add your own music that loops throughout the video")
                        FeatureRow(icon: "repeat", title: "Loop Settings", description: "Loop your video compilation for up to 2 hours")
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 30)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(20)
                    .padding(.horizontal, 30)

                    // Pricing
                    VStack(spacing: 12) {
                        Text("7-Day Free Trial")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        Text("Then $2.99/month")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.9))

                        Text("Cancel anytime • Family Sharing")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // Subscribe button
                    if let product = storeManager.products.first {
                        Button(action: {
                            Task {
                                do {
                                    let success = try await storeManager.purchase(product)
                                    if success {
                                        dismiss()
                                    }
                                } catch {
                                    print("❌ Purchase error: \(error)")
                                    purchaseErrorMessage = "Unable to complete purchase. Please try again or contact support if the problem persists."
                                    showPurchaseError = true
                                }
                            }
                        }) {
                            Group {
                                if storeManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.brandPrimary))
                                } else {
                                    Text("Start Free Trial")
                                        .font(.system(size: 20, weight: .bold))
                                }
                            }
                            .foregroundStyle(
                                LinearGradient(
                                    colors: Color.primaryGradient,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white)
                            .cornerRadius(14)
                        }
                        .padding(.horizontal, 30)
                        .disabled(storeManager.isLoading)
                    } else if showProductLoadError {
                        VStack(spacing: 12) {
                            Text("Unable to load subscription")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            Button(action: {
                                showProductLoadError = false
                                Task {
                                    await storeManager.loadProducts()
                                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                                    if storeManager.products.isEmpty {
                                        showProductLoadError = true
                                    }
                                }
                            }) {
                                Text("Retry")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.brandPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.white)
                                    .cornerRadius(14)
                            }
                            .padding(.horizontal, 30)
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .onAppear {
                                // Set a timeout for product loading
                                Task {
                                    try? await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
                                    if storeManager.products.isEmpty {
                                        showProductLoadError = true
                                    }
                                }
                            }
                    }

                    // Restore button
                    Button(action: {
                        Task {
                            await storeManager.restorePurchases()
                            if storeManager.isPro {
                                dismiss()
                            }
                        }
                    }) {
                        Text("Restore Purchases")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .disabled(storeManager.isLoading)

                    Spacer().frame(height: 30)

                    // Privacy, Terms, and Support links
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Link("Privacy Policy", destination: URL(string: "https://okekedev.github.io/slidecast/privacy.html")!)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))

                            Text("•")
                                .foregroundColor(.white.opacity(0.4))

                            Link("Terms of Use", destination: URL(string: "https://okekedev.github.io/slidecast/terms.html")!)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))

                            Text("•")
                                .foregroundColor(.white.opacity(0.4))

                            Link("Support", destination: URL(string: "https://okekedev.github.io/slidecast/support.html")!)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }

                    // Close button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Continue with Free Version")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 0)
            }
        }
        .alert("Purchase Error", isPresented: $showPurchaseError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(purchaseErrorMessage)
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()
        }
    }
}

import SwiftUI
import AuthenticationServices

struct AppConfigurationView: View {
    @Binding var isPresented: Bool
    @StateObject private var authManager = YouTubeAuthManager()
    @AppStorage("gemini_api_key") private var geminiAPIKey: String = ""
    @State private var apiKeyExpanded = true

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 0) {
                HStack {
                    Text("App Settings")
                        .font(.title2.bold())
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // YouTube Account Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("YouTube Account")
                                .font(.headline)

                            if authManager.isAuthenticated {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Signed in as: \(authManager.userEmail ?? "Unknown")")
                                        .font(.subheadline)
                                    Spacer()
                                    Button("Sign Out") {
                                        authManager.signOut()
                                    }
                                    .font(.subheadline)
                                }
                            } else {
                                Button(action: signIn) {
                                    HStack {
                                        Image(systemName: "play.rectangle.fill")
                                        Text("Sign In with Google")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(14)
                                }
                            }
                        }

                        Divider()

                        // Gemini API Key Section
                        DisclosureGroup(
                            isExpanded: $apiKeyExpanded,
                            content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Enter your Gemini API key to enable AI-powered metadata generation for YouTube uploads")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    SecureField("Gemini API Key", text: $geminiAPIKey)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()

                                    Link(destination: URL(string: "https://makersuite.google.com/app/apikey")!) {
                                        HStack {
                                            Image(systemName: "key.fill")
                                            Text("Get API Key from Google")
                                            Image(systemName: "arrow.up.right")
                                        }
                                        .font(.caption)
                                        .foregroundColor(.brandPrimary)
                                    }
                                }
                                .padding(.top, 8)
                            },
                            label: {
                                HStack {
                                    Text("Gemini API Key")
                                        .font(.headline)
                                }
                            }
                        )
                    }
                    .padding()
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(30)
        }
    }

    private func signIn() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        authManager.signIn(presentationAnchor: window) { success, error in
            if let error = error {
                print("Sign in error: \(error.localizedDescription)")
            }
        }
    }
}

struct AppConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigurationView(isPresented: .constant(true))
    }
}

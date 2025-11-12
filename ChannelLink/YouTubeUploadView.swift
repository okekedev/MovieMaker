import SwiftUI
import AuthenticationServices

struct YouTubeUploadView: View {
    let videoURL: URL
    @Environment(\.dismiss) var dismiss

    @StateObject private var authManager = YouTubeAuthManager()
    @StateObject private var uploadManager = YouTubeUploadManager()
    @StateObject private var geminiService = GeminiService()

    @State private var title = ""
    @State private var description = ""
    @State private var tags = ""
    @State private var privacy: YouTubePrivacy = .private
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isGenerating = false
    
    @AppStorage("gemini_api_key") private var geminiAPIKey: String = ""

    enum YouTubePrivacy: String, CaseIterable {
        case `public` = "Public"
        case `private` = "Private"
        case unlisted = "Unlisted"
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color(.systemBackground), Color.brandAccent.opacity(0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Main content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if !authManager.isAuthenticated {
                            // Sign-in view
                            VStack(spacing: 20) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.secondary)
                                Text("Sign in to YouTube to upload your video.")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                Button(action: signIn) {
                                    Text("Sign In with Google")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(14)
                                }
                            }
                            .padding(40)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)

                        } else {
                            // Upload form
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Video Details")
                                    .font(.title.bold())
                                
                                if let email = authManager.userEmail {
                                    HStack {
                                        Text("Signed in as: \(email)")
                                            .font(.caption)
                                        Spacer()
                                        Button("Sign Out", action: { authManager.signOut() })
                                            .font(.caption)
                                    }
                                }

                                TextField("Title (required)", text: $title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                TextEditor(text: $description)
                                    .frame(height: 150)
                                    .border(Color(.systemGray5), width: 1)
                                    .cornerRadius(6)
                                
                                TextField("Tags (comma separated)", text: $tags)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())

                                Picker("Privacy", selection: $privacy) {
                                    ForEach(YouTubePrivacy.allCases, id: \.self) { p in
                                        Text(p.rawValue).tag(p)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                // Gemini AI Button
                                Button(action: generateMetadata) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                        Text(isGenerating ? "Generating..." : "Generate with AI")
                                    }
                                }
                                .disabled(isGenerating || geminiAPIKey.isEmpty)
                                .alert("Gemini API Key Needed", isPresented: .constant(geminiAPIKey.isEmpty)) {
                                    Button("OK") {}
                                } message: {
                                    Text("Please add your Gemini API key in the app's settings to use this feature.")
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if uploadManager.isUploading {
                    // Upload progress overlay
                    VStack {
                        Text("Uploading...")
                            .font(.headline)
                        ProgressView(value: uploadManager.uploadProgress)
                            .progressViewStyle(LinearProgressViewStyle())
                        Text("\(Int(uploadManager.uploadProgress * 100))%")
                    }
                    .padding(30)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
            .navigationTitle("Upload to YouTube")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Upload", action: uploadVideo)
                        .disabled(!authManager.isAuthenticated || title.isEmpty || uploadManager.isUploading)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func signIn() {
        authManager.signIn(presentationAnchor: ASPresentationAnchor()) { success, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }

    private func generateMetadata() {
        isGenerating = true
        geminiService.generateMetadata(userTitle: title, videoDescription: description, isPublic: privacy == .public) { result in
            isGenerating = false
            switch result {
            case .success(let metadata):
                self.title = metadata.title
                self.description = metadata.description
                self.tags = metadata.tags.joined(separator: ", ")
            case .failure(let error):
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }

    private func uploadVideo() {
        guard let accessToken = authManager.accessToken else {
            errorMessage = "Not authenticated. Please sign in again."
            showingError = true
            return
        }

        let metadata = GeminiService.VideoMetadata(
            title: title,
            description: description,
            tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        )

        uploadManager.uploadVideo(
            videoURL: videoURL,
            metadata: metadata,
            isPublic: privacy == .public,
            accessToken: accessToken
        ) { result in
            switch result {
            case .success(_):
                // For now, just dismiss. In a real app, you might show a success message.
                dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

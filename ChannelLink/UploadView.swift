import SwiftUI

struct UploadView: View {
    @StateObject private var authManager = YouTubeAuthManager()
    @StateObject private var geminiService = GeminiService()
    @StateObject private var uploadManager = YouTubeUploadManager()

    let videoURL: URL

    @State private var userTitle = ""
    @State private var videoDescription = ""
    @State private var isPublic = false
    @State private var isGeneratingMetadata = false
    @State private var generatedMetadata: GeminiService.VideoMetadata?
    @State private var showMetadataPreview = false
    @State private var metadataError: String?

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Authentication Section
                    if !authManager.isAuthenticated {
                        authenticationSection
                    } else {
                        // User Info
                        userInfoSection

                        // Upload Form
                        uploadFormSection

                        // Upload Button
                        uploadButtonSection

                        // Upload Progress
                        if uploadManager.isUploading {
                            uploadProgressSection
                        }

                        // Success/Error Messages
                        if let videoURL = uploadManager.uploadedVideoURL {
                            successSection(videoURL: videoURL)
                        }

                        if let error = uploadManager.uploadError {
                            errorSection(error: error)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Upload to YouTube")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                if authManager.isAuthenticated {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Sign Out") {
                            authManager.signOut()
                        }
                    }
                }
            }
            .sheet(isPresented: $showMetadataPreview) {
                metadataPreviewSheet
            }
        }
    }

    // MARK: - Authentication Section

    private var authenticationSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Sign in with Google")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Connect your YouTube account to upload videos")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button {
                signIn()
            } label: {
                HStack {
                    Image(systemName: "video.fill")
                    Text("Sign in to YouTube")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }

    // MARK: - User Info Section

    private var userInfoSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)

                if let email = authManager.userEmail {
                    Text("Signed in as \(email)")
                        .font(.subheadline)
                } else {
                    Text("Signed in")
                        .font(.subheadline)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }

    // MARK: - Upload Form Section

    private var uploadFormSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title Input (Optional)
            VStack(alignment: .leading, spacing: 8) {
                Text("Title (Optional)")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                TextField("Leave blank for AI-generated title", text: $userTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Text("If left blank, AI will generate an SEO-optimized title")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Video Description
            VStack(alignment: .leading, spacing: 8) {
                Text("What is your video about?")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                TextEditor(text: $videoDescription)
                    .frame(height: 100)
                    .padding(4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                Text("Describe your video content. AI will use this to generate optimized metadata.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Privacy Toggle
            Toggle(isOn: $isPublic) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Public Video")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text(isPublic ? "Anyone can watch" : "Only you can watch")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Generate Metadata Button
            if !videoDescription.isEmpty {
                Button {
                    generateMetadata()
                } label: {
                    HStack {
                        if isGeneratingMetadata {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Image(systemName: "sparkles")
                        }

                        Text(isGeneratingMetadata ? "Generating..." : "Preview AI Metadata")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .foregroundColor(.purple)
                    .cornerRadius(10)
                }
                .disabled(isGeneratingMetadata)
            }

            if let error = metadataError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    // MARK: - Upload Button Section

    private var uploadButtonSection: some View {
        Button {
            uploadVideo()
        } label: {
            HStack {
                Image(systemName: "icloud.and.arrow.up")
                Text("Upload to YouTube")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(videoDescription.isEmpty || uploadManager.isUploading ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(videoDescription.isEmpty || uploadManager.isUploading)
    }

    // MARK: - Upload Progress Section

    private var uploadProgressSection: some View {
        VStack(spacing: 12) {
            ProgressView(value: uploadManager.uploadProgress)
                .progressViewStyle(LinearProgressViewStyle())

            Text("\(Int(uploadManager.uploadProgress * 100))% uploaded")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }

    // MARK: - Success Section

    private func successSection(videoURL: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)

            Text("Upload Successful!")
                .font(.title3)
                .fontWeight(.semibold)

            Link(destination: URL(string: videoURL)!) {
                HStack {
                    Image(systemName: "link")
                    Text("View on YouTube")
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .foregroundColor(.green)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }

    // MARK: - Error Section

    private func errorSection(error: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)

            Text("Upload Failed")
                .font(.headline)

            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }

    // MARK: - Metadata Preview Sheet

    private var metadataPreviewSheet: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let metadata = generatedMetadata {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.headline)
                            Text(metadata.title)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }

                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(metadata.description)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }

                        // Tags
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.headline)
                            FlowLayout(spacing: 8) {
                                ForEach(metadata.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("AI Generated Metadata")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showMetadataPreview = false
                    }
                }
            }
        }
    }

    // MARK: - Actions

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

    private func generateMetadata() {
        isGeneratingMetadata = true
        metadataError = nil

        let titleToUse = userTitle.isEmpty ? nil : userTitle

        geminiService.generateMetadata(
            userTitle: titleToUse,
            videoDescription: videoDescription,
            isPublic: isPublic
        ) { result in
            isGeneratingMetadata = false

            switch result {
            case .success(let metadata):
                generatedMetadata = metadata
                showMetadataPreview = true

            case .failure(let error):
                metadataError = "Failed to generate metadata: \(error.localizedDescription)"
            }
        }
    }

    private func uploadVideo() {
        guard let accessToken = authManager.accessToken else {
            return
        }

        isGeneratingMetadata = true
        metadataError = nil

        let titleToUse = userTitle.isEmpty ? nil : userTitle

        // Step 1: Generate metadata
        geminiService.generateMetadata(
            userTitle: titleToUse,
            videoDescription: videoDescription,
            isPublic: isPublic
        ) { [self] result in
            isGeneratingMetadata = false

            switch result {
            case .success(let metadata):
                // Step 2: Upload with generated metadata
                uploadManager.uploadVideo(
                    videoURL: videoURL,
                    metadata: metadata,
                    isPublic: isPublic,
                    accessToken: accessToken
                ) { uploadResult in
                    switch uploadResult {
                    case .success(let url):
                        print("Video uploaded successfully: \(url)")

                    case .failure(let error):
                        print("Upload failed: \(error.localizedDescription)")
                    }
                }

            case .failure(let error):
                metadataError = "Failed to generate metadata: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Flow Layout for Tags

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )

        for (index, subview) in subviews.enumerated() {
            let position = result.positions[index]
            subview.place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    struct FlowResult {
        var size: CGSize
        var positions: [CGPoint]

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var positions: [CGPoint] = []
            var size: CGSize = .zero
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let subviewSize = subview.sizeThatFits(.unspecified)

                if currentX + subviewSize.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += subviewSize.width + spacing
                lineHeight = max(lineHeight, subviewSize.height)
                size.width = max(size.width, currentX - spacing)
                size.height = currentY + lineHeight
            }

            self.size = size
            self.positions = positions
        }
    }
}

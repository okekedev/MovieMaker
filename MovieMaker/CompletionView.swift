import SwiftUI

struct CompletionView: View {
    let videoURL: URL?
    let onCreateAnother: () -> Void

    @State private var showingShareSheet = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Success animation
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: Color.brandGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 150)
                    .shadow(color: Color.brandSecondary.opacity(0.4), radius: 20, x: 0, y: 10)

                Image(systemName: "checkmark")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(spacing: 12) {
                Text("Video Created!")
                    .font(.system(size: 34, weight: .bold))

                Text("Your video has been saved to your photos.")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            Spacer()

            VStack(spacing: 14) {
                if videoURL != nil {
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Label("Share Video", systemImage: "square.and.arrow.up")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: Color.brandGradient,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.brandSecondary.opacity(0.5), radius: 15, x: 0, y: 8)
                    }
                    .sheet(isPresented: $showingShareSheet) {
                        if let url = videoURL {
                            ShareSheet(items: [url])
                        }
                    }
                }

                if videoURL != nil {
                    Button(action: {
                        if let url = URL(string: "photos-redirect://") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Open Photos", systemImage: "photo.on.rectangle")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.systemGray))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                }

                Button(action: onCreateAnother) {
                    Text("Create Another Video")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .padding()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

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
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 150, height: 150)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.green)
            }

            VStack(spacing: 8) {
                Text("Video Created!")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Your video has been saved to your photos.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }

            Spacer()

            VStack(spacing: 12) {
                if videoURL != nil {
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Label("Share Video", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: Color.primaryGradient,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(14)
                            .shadow(color: Color.brandPrimary.opacity(0.5), radius: 15, x: 0, y: 8)
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
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(
                                                LinearGradient(
                                                    colors: Color.secondaryGradient,
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(14)
                                            .shadow(color: Color.brandSecondary.opacity(0.5), radius: 15, x: 0, y: 8)
                                    }
                                }
                Button(action: onCreateAnother) {
                    Text("Create Another Video")
                        .font(.headline)
                        .foregroundColor(.brandPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandPrimary.opacity(0.1))
                        .cornerRadius(14)
                }
            }
            .padding(.horizontal)
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

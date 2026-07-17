import SwiftUI

struct VideoCreationView: View {
    let selectedMedia: [MediaItem]
    let settings: VideoCompilationSettings // Add settings
    let onComplete: (URL) -> Void

    @EnvironmentObject var storeManager: StoreManager
    @State private var progress: Double = 0
    @State private var status: String = NSLocalizedString("Preparing...", comment: "Export progress status")
    @State private var showingError = false
    @State private var errorMessage = ""
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Progress indicator
            ZStack {
                Circle()
                    .stroke(lineWidth: 12)
                    .opacity(0.2)
                    .foregroundColor(Color.brandAccent)
                    .frame(width: 150, height: 150)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            colors: Color.primaryGradient + [Color.brandSecondary],
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360 * progress)
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: progress)

                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: Color.primaryGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundColor(Color.brandAccent)
                }
            }

            VStack(spacing: 8) {
                Text("Creating your video...")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(status)
                    .font(.callout)
                    .foregroundColor(.secondary)

                Text("You can close the app - we'll notify you when it's ready")
                    .font(.caption)
                    .foregroundColor(.brandPrimary)
                    .padding(.top, 4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            NotificationManager.shared.requestAuthorization()

            // Keep screen awake during video creation
            UIApplication.shared.isIdleTimerDisabled = true

            startCreation()
        }
        .onDisappear {
            // Re-enable screen auto-lock
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") {
                // No action needed, as there's no onError closure anymore
            }
        } message: {
            Text(errorMessage)
        }
    }

    private func startCreation() {
        status = NSLocalizedString("Compiling videos...", comment: "Export progress status")

        VideoCompiler.compileVideos(
            media: selectedMedia,
            settings: settings, // Use the passed settings object
            progressHandler: { progressValue in
                DispatchQueue.main.async {
                    self.progress = progressValue * 0.7 // Reserve 0.7-1.0 for saving

                    if progressValue < 0.5 {
                        status = NSLocalizedString("Adding videos...", comment: "Export progress status")
                    } else if progressValue < 0.8 {
                        status = NSLocalizedString("Composing video...", comment: "Export progress status")
                    } else {
                        status = NSLocalizedString("Almost done...", comment: "Export progress status")
                    }
                }
            },
            completion: { result in
                switch result {
                case .success(let url):
                    saveToPhotoLibrary(url: url)

                case .failure(let error):
                    showError(error.localizedDescription)
                }
            }
        )
    }

    private func saveToPhotoLibrary(url: URL) {
        DispatchQueue.main.async {
            status = NSLocalizedString("Saving to Photos...", comment: "Export progress status")
            progress = 0.8
        }

        VideoCompiler.saveToPhotoLibrary(videoURL: url) { result in
            DispatchQueue.main.async {
                progress = 1.0

                switch result {
                case .success:
                    // Count this against the free tier. StoreManager is a no-op
                    // for Pro users, so this is safe to call unconditionally.
                    storeManager.recordExport()

                    // Ask for an App Store review on the 3rd successful export,
                    // capped once per app version.
                    ReviewPrompt.recordExportAndMaybeAsk()

                    // Send notification if app is in background
                    if scenePhase == .background {
                        NotificationManager.shared.sendVideoCompleteNotification()
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onComplete(url)
                    }

                case .failure(let error):
                    showError(error.localizedDescription)
                }
            }
        }
    }

    private func showError(_ message: String) {
        DispatchQueue.main.async {
            errorMessage = message
            showingError = true
        }
    }
}

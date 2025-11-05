import SwiftUI

struct VideoCreationView: View {
    let selectedMedia: [MediaItem]
    let settings: SlideshowSettings
    let onComplete: (URL) -> Void
    let onError: () -> Void

    @State private var progress: Double = 0
    @State private var status: String = "Preparing..."
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
                    .opacity(0.3)
                    .foregroundColor(.blue)
                    .frame(width: 150, height: 150)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .foregroundColor(.blue)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: progress)

                VStack(spacing: 4) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 36, weight: .bold))

                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }

            VStack(spacing: 8) {
                Text("Creating your slideshow...")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(status)
                    .font(.callout)
                    .foregroundColor(.secondary)

                Text("You can close the app - we'll notify you when it's ready")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            // Request notification permission
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
                onError()
            }
        } message: {
            Text(errorMessage)
        }
    }

    private func startCreation() {
        status = "Processing media..."

        VideoComposer.createSlideshow(
            media: selectedMedia,
            settings: settings,
            progressHandler: { progressValue in
                DispatchQueue.main.async {
                    self.progress = progressValue * 0.7 // Reserve 0.7-1.0 for saving

                    if progressValue < 0.5 {
                        status = "Adding photos..."
                    } else if progressValue < 0.8 {
                        status = "Composing video..."
                    } else {
                        status = "Almost done..."
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
            status = "Saving to Photos..."
            progress = 0.8
        }

        VideoComposer.saveToPhotoLibrary(videoURL: url) { result in
            DispatchQueue.main.async {
                progress = 1.0

                switch result {
                case .success:
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

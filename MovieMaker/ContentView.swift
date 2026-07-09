import SwiftUI

enum AppScreen {
    case mediaSelection
    case settings
    case videoCreation
    case completion
}

struct ContentView: View {
    // MM_SCREEN=completion → jump straight to the finished screen (screenshot capture;
    // see the env-var block in ChannelLinkApp.swift). The dummy URL makes the
    // Share/Open Photos buttons render as they do after a real export.
    @State private var currentScreen: AppScreen =
        ProcessInfo.processInfo.environment["MM_SCREEN"] == "completion" ? .completion : .mediaSelection
    @State private var selectedMedia: [MediaItem] = []
    @State private var settings = VideoCompilationSettings()
    @State private var outputURL: URL? =
        ProcessInfo.processInfo.environment["MM_SCREEN"] == "completion"
            ? FileManager.default.temporaryDirectory.appendingPathComponent("demo.mp4") : nil

    var body: some View {
        NavigationView {
            ZStack {
                switch currentScreen {
                case .mediaSelection:
                    MediaSelectionView(
                        selectedMedia: $selectedMedia,
                        onNext: {
                            currentScreen = .settings
                        }
                    )

                case .settings:
                    SettingsView(
                        selectedMedia: $selectedMedia,
                        settings: $settings,
                        onBack: {
                            currentScreen = .mediaSelection
                        },
                        onCreate: {
                            currentScreen = .videoCreation
                        }
                    )

                case .videoCreation:
                    VideoCreationView(
                        selectedMedia: selectedMedia,
                        settings: settings, // Pass the settings object
                        onComplete: { url in
                            outputURL = url
                            currentScreen = .completion
                        }
                    )

                case .completion:
                    CompletionView(
                        videoURL: outputURL,
                        onCreateAnother: {
                            selectedMedia = []
                            settings = VideoCompilationSettings()
                            outputURL = nil
                            currentScreen = .mediaSelection
                        }
                    )
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

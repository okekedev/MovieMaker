import SwiftUI

enum AppScreen {
    case mediaSelection
    case settings
    case videoCreation
    case completion
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .mediaSelection
    @State private var selectedMedia: [MediaItem] = []
    @State private var settings = VideoCompilationSettings()
    @State private var outputURL: URL?

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
                        selectedMedia: selectedMedia,
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

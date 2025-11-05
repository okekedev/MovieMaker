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
    @State private var settings = SlideshowSettings()
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
                        settings: settings,
                        onComplete: { url in
                            outputURL = url
                            currentScreen = .completion
                        },
                        onError: {
                            currentScreen = .settings
                        }
                    )

                case .completion:
                    CompletionView(
                        videoURL: outputURL,
                        onCreateAnother: {
                            selectedMedia = []
                            settings = SlideshowSettings()
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

import SwiftUI
import Photos

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
    @State private var currentScreen: AppScreen = {
        let env = ProcessInfo.processInfo.environment
        if env["MM_SCREEN"] == "completion" { return .completion }
        if env["MM_PRELOAD_TEST_MEDIA"] == "1" { return .settings }
        return .mediaSelection
    }()
    @State private var selectedMedia: [MediaItem] = []
    @State private var settings: VideoCompilationSettings = {
        var s = VideoCompilationSettings()
        switch ProcessInfo.processInfo.environment["MM_ASPECT"] {
        case "square":   s.orientation = .square
        case "portrait": s.orientation = .portrait
        case "landscape": s.orientation = .landscape
        default: break
        }
        return s
    }()
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
                        orientation: $settings.orientation,
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
        .task { await preloadTestMediaIfRequested() }
    }

    /// MM_PRELOAD_TEST_MEDIA=1 → fetch the first photo + first video from the
    /// Photos library so debug automation can jump straight to Settings without
    /// clicking through the PHPicker. No-op otherwise.
    private func preloadTestMediaIfRequested() async {
        guard ProcessInfo.processInfo.environment["MM_PRELOAD_TEST_MEDIA"] == "1" else { return }
        guard selectedMedia.isEmpty else { return }
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .notDetermined {
            _ = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        }
        let imageOpts = PHFetchOptions()
        imageOpts.fetchLimit = 1
        imageOpts.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        let videoOpts = PHFetchOptions()
        videoOpts.fetchLimit = 1
        videoOpts.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        let photos = PHAsset.fetchAssets(with: imageOpts)
        let videos = PHAsset.fetchAssets(with: videoOpts)
        var items: [MediaItem] = []
        if let photo = photos.firstObject { items.append(MediaItem(asset: photo)) }
        if let video = videos.firstObject { items.append(MediaItem(asset: video)) }
        print("[Preload] Loaded \(items.count) test items (photos=\(photos.count), videos=\(videos.count))")
        await MainActor.run { selectedMedia = items }
    }
}

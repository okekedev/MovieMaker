import SwiftUI
import Photos
import AVFoundation

struct SettingsView: View {
    @Binding var selectedMedia: [MediaItem]
    @Binding var settings: VideoCompilationSettings
    let onBack: () -> Void
    let onCreate: () -> Void

    init(selectedMedia: Binding<[MediaItem]>, settings: Binding<VideoCompilationSettings>, onBack: @escaping () -> Void, onCreate: @escaping () -> Void) {
        self._selectedMedia = selectedMedia
        self._settings = settings
        self.onBack = onBack
        self.onCreate = onCreate
    }

    @State private var showingWarning = false
    @State private var warningMessage = ""
    @State private var showingPaywall = false
    @State private var showingMusicPicker = false
    @State private var selectedMusicTitle: String = "None"
    @State private var expandedTool: EditorTool?
    @State private var isPreviewPlaying: Bool = true
    @State private var previewProgress: Double = 0
    @State private var previewDuration: Double = 0
    @State private var isScrubbing: Bool = false
    @EnvironmentObject var storeManager: StoreManager

    enum EditorTool { case aspect, music }

    private static let photoDurationOptions: [Double] = [2, 3, 5, 10]

    private var hasPhotos: Bool {
        selectedMedia.contains { $0.asset.mediaType == .image }
    }

    var body: some View {
        VStack(spacing: 12) {
            // Live preview — takes remaining vertical space.
            CompositionPreviewPlayer(
                media: selectedMedia,
                settings: settings,
                isPlaying: $isPreviewPlaying,
                progress: $previewProgress,
                duration: $previewDuration,
                isScrubbing: $isScrubbing
            )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 12)
                .padding(.top, 12)

            // Timeline scrubber — playhead position across the composition.
            timelineBar
                .padding(.horizontal, 16)

            // Tool icon row — each expands a sub-tab below (matches Trim view).
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Button(action: { toggleTool(.aspect) }) {
                        toolIconBody(icon: "aspectratio", active: expandedTool == .aspect)
                    }.buttonStyle(.plain)

                    Button(action: {
                        if settings.musicAsset == nil {
                            showingMusicPicker = true
                        } else {
                            toggleTool(.music)
                        }
                    }) {
                        toolIconBody(
                            icon: settings.musicAsset != nil ? "music.note" : "music.note.list",
                            active: expandedTool == .music || settings.musicAsset != nil
                        )
                    }.buttonStyle(.plain)

                    // Transition is a direct toggle — fade on/off, no sub-tab.
                    Button(action: { settings.transition = settings.transition == .fade ? .none : .fade }) {
                        toolIconBody(icon: "arrow.left.and.right.circle", active: settings.transition == .fade)
                    }.buttonStyle(.plain)

                    // Direct toggle like Fade: on = today's date, off = nil.
                    Button(action: {
                        settings.dateStamp = settings.dateStamp == nil ? Date() : nil
                    }) {
                        toolIconBody(icon: "calendar", active: settings.dateStamp != nil)
                    }.buttonStyle(.plain)
                }
                .padding(.horizontal, 16)

                // Inline sub-tab under the icons.
                Group {
                    switch expandedTool {
                    case .aspect:
                        HStack(spacing: 8) {
                            aspectChip(.landscape)
                            aspectChip(.square)
                            aspectChip(.portrait)
                        }
                    case .music: musicSubTab
                    case .none: EmptyView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, expandedTool == nil ? 0 : 4)
                .animation(.easeInOut(duration: 0.08), value: expandedTool)
            }
            .layoutPriority(1)

            // Fixed gap before the action row (not a greedy Spacer — that
            // would fight the top Spacer that centers the preview).
            Color.clear.frame(height: 36)

            // Bottom action row — back, play/pause, check. Play/pause toggles
            // the preview player between back and the final commit.
            HStack(spacing: 20) {
                actionCircle(icon: "chevron.backward", tint: .brandPrimary, filled: false, action: onBack)
                actionCircle(
                    icon: isPreviewPlaying ? "pause.fill" : "play.fill",
                    tint: .brandPrimary,
                    filled: false,
                    action: { isPreviewPlaying.toggle() }
                )
                actionCircle(icon: "checkmark", tint: .white, filled: true, action: checkAndCreate)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
        .alert("Warning", isPresented: $showingWarning) {
            Button("Cancel", role: .cancel) {}
            Button("Create Anyway") { onCreate() }
        } message: {
            Text(warningMessage)
        }
        .fullScreenCover(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(storeManager)
        }
        .sheet(isPresented: $showingMusicPicker) {
            DocumentPicker(
                selectedMusicTitle: $selectedMusicTitle,
                musicAsset: $settings.musicAsset,
                onDismiss: { showingMusicPicker = false }
            )
        }
    }

    private func toggleTool(_ tool: EditorTool) {
        expandedTool = expandedTool == tool ? nil : tool
    }

    // MARK: - Timeline scrubber

    @ViewBuilder
    private var timelineBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.brandPrimary.opacity(0.15))
                    .frame(height: 6)
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(colors: Color.primaryGradient, startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: max(0, CGFloat(previewProgress) * geo.size.width), height: 6)
                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: isScrubbing ? 20 : 14, height: isScrubbing ? 20 : 14)
                    .shadow(color: Color.brandPrimary.opacity(0.5), radius: 4, x: 0, y: 2)
                    .offset(x: max(0, CGFloat(previewProgress) * geo.size.width - (isScrubbing ? 10 : 7)))
                    .animation(.easeOut(duration: 0.1), value: isScrubbing)
            }
            .contentShape(Rectangle())
            .frame(height: 20)
            .frame(maxHeight: .infinity, alignment: .center)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isScrubbing = true
                        let clamped = min(max(0, value.location.x), geo.size.width)
                        previewProgress = geo.size.width > 0 ? Double(clamped / geo.size.width) : 0
                    }
                    .onEnded { _ in isScrubbing = false }
            )
        }
        .frame(height: 20)
    }

    // MARK: - Sub-tabs (inline editors under the icon row)

    @ViewBuilder
    private var musicSubTab: some View {
        HStack(spacing: 10) {
            Image(systemName: "speaker.wave.2")
                .foregroundColor(.brandPrimary)
                .frame(width: 24)
            Slider(value: $settings.musicVolume, in: 0...1).tint(Color.brandAccent)
            Button(action: { showingMusicPicker = true }) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.brandPrimary)
            }.buttonStyle(.plain)
            Button(action: {
                settings.musicAsset = nil
                selectedMusicTitle = "None"
                expandedTool = nil
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }.buttonStyle(.plain)
        }
        .padding(10)
        .background(Color.brandPrimary.opacity(0.08))
        .cornerRadius(12)
    }


    @ViewBuilder
    private var transitionSubTab: some View {
        Picker("Transition", selection: $settings.transition) {
            ForEach(TransitionType.allCases, id: \.self) { t in
                Text(t.rawValue).tag(t)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(10)
        .background(Color.brandPrimary.opacity(0.08))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var durationSubTab: some View {
        VStack(spacing: 8) {
            if hasPhotos {
                HStack(spacing: 10) {
                    Image(systemName: "photo")
                        .foregroundColor(.brandPrimary)
                        .frame(width: 24)
                    Picker("Photo hold", selection: $settings.photoDuration) {
                        ForEach(Self.photoDurationOptions, id: \.self) { v in
                            Text("\(Int(v))s").tag(v)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            HStack(spacing: 10) {
                Image(systemName: "textformat")
                    .foregroundColor(.brandPrimary)
                    .frame(width: 24)
                Picker("Title hold", selection: $settings.titleDuration) {
                    ForEach(Self.photoDurationOptions, id: \.self) { v in
                        Text("\(Int(v))s").tag(v)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
        .padding(10)
        .background(Color.brandPrimary.opacity(0.08))
        .cornerRadius(12)
    }

    // MARK: - Chip / icon helpers

    @ViewBuilder
    private func aspectChip(_ o: VideoOrientation) -> some View {
        let active = settings.orientation == o
        Button(action: {
            settings.orientation = o
            expandedTool = nil
        }) {
            Text(o.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(active ? .white : .brandPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if active {
                            LinearGradient(colors: Color.primaryGradient, startPoint: .leading, endPoint: .trailing)
                        } else {
                            Color.brandPrimary.opacity(0.12)
                        }
                    }
                )
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func toolIconBody(icon: String, active: Bool) -> some View {
        Image(systemName: icon)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(active ? .white : .brandPrimary)
            .frame(width: 60, height: 50)
            .background(active ? Color.brandPrimary : Color.brandPrimary.opacity(0.12))
            .cornerRadius(12)
    }

    @ViewBuilder
    private func actionCircle(icon: String, tint: Color, filled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(tint)
                .frame(width: 72, height: 72)
                .background(
                    Group {
                        if filled {
                            LinearGradient(colors: Color.brandGradient, startPoint: .leading, endPoint: .trailing)
                        } else {
                            Color.brandPrimary.opacity(0.12)
                        }
                    }
                )
                .clipShape(Circle())
                .shadow(color: filled ? Color.brandSecondary.opacity(0.4) : .clear, radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Create action

    private func checkAndCreate() {
        if !storeManager.canStartExport {
            showingPaywall = true
            return
        }
        let longVideos = selectedMedia.filter { $0.asset.mediaType == .video && $0.asset.duration > 300 }
        if !longVideos.isEmpty {
            showingWarning = true
            warningMessage = "You have \(longVideos.count) video\(longVideos.count == 1 ? "" : "s") longer than 5 minutes. This may result in a very large file."
            return
        }
        if selectedMedia.count > 100 {
            showingWarning = true
            warningMessage = "You have \(selectedMedia.count) items. This may take several minutes to create."
            return
        }
        onCreate()
    }
}

// MARK: - CompositionPreviewPlayer

/// Live preview of the compilation as an AVAssetImageGenerator-backed
/// flipbook. We can't use AVPlayer + videoComposition on the iOS Simulator
/// because the sim's video compositor errors -19230 whenever the composition
/// mixes a photo-generated MP4 with a Photos-library video. The image
/// generator uses a different rendering path that works reliably on sim and
/// on device. Rebuilds when media or settings change.
struct CompositionPreviewPlayer: View {
    let media: [MediaItem]
    let settings: VideoCompilationSettings
    @Binding var isPlaying: Bool
    @Binding var progress: Double
    @Binding var duration: Double
    @Binding var isScrubbing: Bool

    @State private var frames: [UIImage] = []
    @State private var currentIndex: Int = 0
    @State private var wasPlayingBeforeScrub: Bool = false
    /// Retained composition + sources so the image generator's underlying
    /// tracks stay valid for the whole preview lifetime.
    @State private var retainedComposition: AVMutableComposition?
    @State private var retainedSources: [AVAsset] = []
    /// Wall-clock timer that advances currentIndex at real-time playback rate.
    @State private var tickTimer: Timer?

    private static let framesPerSecond: Double = 6

    var body: some View {
        GeometryReader { geo in
            let aspect = settings.orientation.size.width / settings.orientation.size.height
            let (fitW, fitH): (CGFloat, CGFloat) = {
                let scaleToWidth = geo.size.width / aspect
                if scaleToWidth <= geo.size.height {
                    return (geo.size.width, scaleToWidth)
                } else {
                    return (geo.size.height * aspect, geo.size.height)
                }
            }()

            ZStack {
                Color.black
                if !frames.isEmpty {
                    let idx = min(max(0, currentIndex), frames.count - 1)
                    Image(uiImage: frames[idx])
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView().tint(.white)
                }
            }
            .frame(width: fitW, height: fitH)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
        .task(id: rebuildKey) { await rebuild() }
        .onChange(of: isPlaying) {
            if isPlaying { startTicking() } else { stopTicking() }
        }
        .onChange(of: isScrubbing) {
            if isScrubbing {
                wasPlayingBeforeScrub = isPlaying
                stopTicking()
            } else if wasPlayingBeforeScrub {
                startTicking()
            }
        }
        .onChange(of: progress) {
            guard isScrubbing, !frames.isEmpty else { return }
            currentIndex = min(frames.count - 1, max(0, Int(progress * Double(frames.count - 1))))
        }
        .onDisappear { stopTicking() }
    }

    private var rebuildKey: String {
        let orient = settings.orientation.rawValue
        let mediaSig = media.map { item -> String in
            let start = item.startTime.seconds
            let end = item.endTime?.seconds ?? -1
            let crop = item.cropRect.map { "\($0.origin.x),\($0.origin.y),\($0.width),\($0.height)" } ?? "n"
            return "\(item.id)-\(start)-\(end)-\(item.isMuted)-\(item.playbackRate)-\(crop)"
        }.joined(separator: "|")
        return "\(orient)-\(mediaSig)"
    }

    private func rebuild() async {
        stopTicking()
        guard !media.isEmpty else {
            await MainActor.run { self.frames = []; self.duration = 0 }
            return
        }
        do {
            let fullSize = settings.orientation.size
            let previewScale = min(1.0, 640.0 / max(fullSize.width, fullSize.height))
            let (composition, videoComposition, sources) = try await VideoCompiler.buildComposition(
                media: media,
                settings: settings,
                attachOverlays: false,
                renderScale: previewScale
            )
            let totalSeconds = CMTimeGetSeconds(composition.duration)
            guard totalSeconds > 0 else { return }
            let frameCount = max(6, Int(totalSeconds * Self.framesPerSecond))
            print("[Preview] Generating \(frameCount) frames over \(totalSeconds)s at \(videoComposition.renderSize)")

            let gen = AVAssetImageGenerator(asset: composition)
            gen.videoComposition = videoComposition
            gen.appliesPreferredTrackTransform = false
            gen.requestedTimeToleranceBefore = CMTime(seconds: 0.05, preferredTimescale: 600)
            gen.requestedTimeToleranceAfter = CMTime(seconds: 0.05, preferredTimescale: 600)
            // Don't set maximumSize — videoComposition.renderSize already
            // controls output size, and maximumSize triggers a second aspect-fit
            // pass that letterboxes rotated sources.

            var newFrames: [UIImage] = []
            newFrames.reserveCapacity(frameCount)
            for i in 0..<frameCount {
                let t = CMTime(seconds: totalSeconds * Double(i) / Double(frameCount - 1),
                               preferredTimescale: 600)
                do {
                    let cg = try gen.copyCGImage(at: t, actualTime: nil)
                    newFrames.append(UIImage(cgImage: cg))
                } catch {
                    print("[Preview] frame \(i) failed: \(error)")
                }
            }
            print("[Preview] Generated \(newFrames.count)/\(frameCount) frames")

            await MainActor.run {
                self.retainedComposition = composition
                self.retainedSources = sources
                self.frames = newFrames
                self.duration = totalSeconds
                self.currentIndex = 0
                if isPlaying { startTicking() }
            }
        } catch {
            print("Preview build failed: \(error)")
        }
    }

    private func startTicking() {
        stopTicking()
        guard !frames.isEmpty else { return }
        let interval = 1.0 / Self.framesPerSecond
        tickTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            Task { @MainActor in
                guard !isScrubbing, !frames.isEmpty else { return }
                var next = currentIndex + 1
                if next >= frames.count { next = 0 }
                currentIndex = next
                progress = Double(next) / Double(max(1, frames.count - 1))
            }
        }
    }

    private func stopTicking() {
        tickTimer?.invalidate()
        tickTimer = nil
    }
}

/// Delegate that AVFoundation calls with specific reasons a video composition
/// fails validation. Per Apple TN2447 — helpful for diagnosing videoCompositor
/// -19230 errors that otherwise surface as opaque "invalid composition".
private final class CompositionValidator: NSObject, AVVideoCompositionValidationHandling {
    var issues: [String] = []

    func videoComposition(_ vc: AVVideoComposition, shouldContinueValidatingAfterFindingInvalidValueForKey key: String) -> Bool {
        issues.append("invalidValue key=\(key)")
        return true
    }
    func videoComposition(_ vc: AVVideoComposition, shouldContinueValidatingAfterFindingEmptyTimeRange range: CMTimeRange) -> Bool {
        issues.append("emptyTimeRange start=\(range.start.seconds) dur=\(range.duration.seconds)")
        return true
    }
    func videoComposition(_ vc: AVVideoComposition, shouldContinueValidatingAfterFindingInvalidTimeRangeIn instruction: AVVideoCompositionInstructionProtocol) -> Bool {
        issues.append("invalidTimeRangeIn instr start=\(instruction.timeRange.start.seconds) dur=\(instruction.timeRange.duration.seconds)")
        return true
    }
    func videoComposition(_ vc: AVVideoComposition, shouldContinueValidatingAfterFindingInvalidTrackIDIn instruction: AVVideoCompositionInstructionProtocol, layerInstruction: AVVideoCompositionLayerInstruction, asset: AVAsset) -> Bool {
        issues.append("invalidTrackID trackID=\(layerInstruction.trackID)")
        return true
    }
}

private struct PreviewPlayerLayerView: UIViewRepresentable {
    let player: AVPlayer

    final class Container: UIView {
        override class var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    }

    func makeUIView(context: Context) -> Container {
        let view = Container()
        view.backgroundColor = .black
        view.playerLayer.player = player
        // .resizeAspect (fit with letterbox) is safer than aspectFill for
        // preview — always shows the whole rendered composition content
        // even if the container aspect differs slightly.
        view.playerLayer.videoGravity = .resizeAspect
        return view
    }

    func updateUIView(_ uiView: Container, context: Context) {
        uiView.playerLayer.videoGravity = .resizeAspect
        if uiView.playerLayer.player !== player {
            uiView.playerLayer.player = player
        }
    }
}

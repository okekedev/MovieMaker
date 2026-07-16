import SwiftUI
import AVFoundation
import Photos

struct TrimmingView: View {
    @Binding var mediaItem: MediaItem
    /// Bound to the shared VideoCompilationSettings so the aspect chip row
    /// edits the composition-wide output orientation.
    @Binding var orientation: VideoOrientation
    var onSplit: ((CMTime) -> Void)? = nil
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var storeManager: StoreManager

    var targetAspectRatio: CGFloat { orientation.size.width / orientation.size.height }

    /// Draft playback rate + mute — applied on Done, matches trim's pattern.
    @State private var pendingPlaybackRate: Double = 1.0
    @State private var pendingIsMuted: Bool = false
    /// Which tool's sub-tab is currently expanded below the icon row. nil = collapsed.
    @State private var expandedTool: EditorTool?

    enum EditorTool { case speed, zoom, title }

    /// Display-oriented source dimensions (after preferredTransform).
    @State private var displaySourceSize: CGSize = .zero
    @State private var activeZoom: CGFloat? = nil
    @State private var pendingCropRect: CGRect?
    @State private var dragBaseRect: CGRect?

    // Tap-to-toggle overlay — briefly shows a play/pause icon on video tap.
    @State private var tapFeedbackIcon: String?

    @State private var player: AVPlayer?
    @State private var avAsset: AVAsset?
    @State private var isPlaying = false
    @State private var currentTime: CMTime = .zero
    @State private var duration: CMTime = .zero

    @State private var trimStartTime: CMTime = .zero
    @State private var trimEndTime: CMTime = .zero

    // UI state for draggable handles
    @State private var leftHandlePosition: CGFloat = 0
    @State private var rightHandlePosition: CGFloat = 1

    // Slow-mo state
    @State private var slowMoEnabled = false
    @State private var slowMoLeftHandlePosition: CGFloat = 0.25
    @State private var slowMoRightHandlePosition: CGFloat = 0.75
    @State private var slowMoStartTime: CMTime?
    @State private var slowMoEndTime: CMTime?

    // Playhead state
    @State private var playheadPosition: CGFloat = 0

    // Paywall state
    @State private var showingPaywall = false

    var body: some View {
        VStack(spacing: 0) {
            // Top-of-screen flexible space — pairs with the equal-priority
            // Spacer below the video (before the controls) to center the video
            // vertically in the top area regardless of source aspect.
            Spacer(minLength: 8)

            // Color.clear establishes the aspect-fit frame; overlay hosts the
            // actual video. Rounded corners applied via .clipShape so both the
            // black background AND the video are clipped to the same rectangle.
            Color.clear
                .aspectRatio(displaySourceSize.width > 0 ? sourceAspectRatio : 16.0/9.0, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .overlay(
                    GeometryReader { geo in
                        ZStack {
                            Color.black
                            if let player = player {
                                ZoomablePlayerView(player: player)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .scaleEffect(zoomScale, anchor: zoomAnchor)
                                    .clipped()
                                    .animation(.easeInOut(duration: 0.2), value: pendingCropRect)
                                    .onDisappear(perform: pausePlayer)
                            } else {
                                ProgressView("Loading video...")
                                    .tint(.white)
                                    .foregroundColor(.white)
                            }
                            if let icon = tapFeedbackIcon {
                                Image(systemName: icon)
                                    .font(.system(size: 50, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(24)
                                    .background(Circle().fill(Color.black.opacity(0.5)))
                                    .transition(.opacity)
                                    .allowsHitTesting(false)
                            }
                            // Live title/subtitle overlay so users see their
                            // per-clip text right in the editor preview.
                            titleOverlayView
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { handleVideoTap() }
                        .gesture(
                            DragGesture(minimumDistance: 10)
                                .onChanged { value in dragCrop(translation: value.translation, container: geo.size) }
                                .onEnded { _ in dragBaseRect = nil }
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 12)

            // Equal-weight Spacer to the one above the video — together they
            // split the leftover vertical space and center the video.
            Spacer(minLength: 8)

            VStack(spacing: 0) {
            // Trimming UI
            VStack(spacing: 10) {
                // Inline row: [start time] [play/pause] [end time]
                HStack {
                    Text(formatTime(trimStartTime))
                        .font(.system(size: 15.scaled, weight: .medium))
                        .monospacedDigit()
                    Spacer()
                    Button(action: togglePlayPause) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 36.scaled, weight: .semibold))
                            .foregroundColor(.brandPrimary)
                    }
                    .disabled(player == nil)
                    Spacer()
                    Text(formatTime(trimEndTime))
                        .font(.system(size: 15.scaled, weight: .medium))
                        .monospacedDigit()
                }
                .padding(.horizontal, 4)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background timeline
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 80)

                        // Trimmed section indicator
                        Rectangle()
                            .fill(Color.brandAccent.opacity(0.5))
                            .frame(width: (rightHandlePosition - leftHandlePosition) * geometry.size.width, height: 80)
                            .offset(x: leftHandlePosition * geometry.size.width)

                        // Slow-mo section indicator
                        if slowMoEnabled {
                            Rectangle()
                                .fill(Color.blue.opacity(0.7))
                                .frame(width: (slowMoRightHandlePosition - slowMoLeftHandlePosition) * geometry.size.width, height: 20)
                                .offset(x: slowMoLeftHandlePosition * geometry.size.width, y: 30)
                        }
                        
                        // Playhead — draggable within the trim range so the
                        // user can pick a split point without needing playback.
                        // A wider transparent hit target sits behind the 2pt line
                        // so it's actually grabbable.
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .frame(width: 32, height: 80)
                            .offset(x: playheadPosition * geometry.size.width - 16)
                            .gesture(playheadDragGesture(width: geometry.size.width))
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 5, height: 80)
                            .cornerRadius(2)
                            .offset(x: playheadPosition * geometry.size.width - 2)
                            .shadow(color: Color.orange.opacity(0.6), radius: 3, x: 0, y: 0)
                            .allowsHitTesting(false)

                        // Main Trim Handles
                        trimHandle(position: $leftHandlePosition, geometry: geometry, color: .brandPrimary)
                        trimHandle(position: $rightHandlePosition, geometry: geometry, color: .brandSecondary)

                        // Slow-mo Handles
                        if slowMoEnabled {
                            slowMoHandle(position: $slowMoLeftHandlePosition, geometry: geometry, color: .blue.opacity(0.8))
                            slowMoHandle(position: $slowMoRightHandlePosition, geometry: geometry, color: .blue.opacity(0.8))
                        }
                    }
                }
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                // Tool icons row — one icon per tool; tap to expand its sub-tab
                // below. Mute has no sub-tab, it toggles directly (red when on).
                HStack(spacing: 14) {
                    toolIcon(
                        icon: pendingIsMuted ? "speaker.slash.fill" : "speaker.wave.2.fill",
                        active: pendingIsMuted,
                        activeColor: .red,
                        action: {
                            pendingIsMuted.toggle()
                            expandedTool = nil
                        }
                    )
                    toolIcon(icon: "speedometer", active: expandedTool == .speed, activeColor: .brandPrimary,
                             action: { expandedTool = expandedTool == .speed ? nil : .speed })
                    toolIcon(icon: "plus.magnifyingglass", active: expandedTool == .zoom, activeColor: .brandPrimary,
                             action: { expandedTool = expandedTool == .zoom ? nil : .zoom })
                    toolIcon(icon: "textformat",
                             active: expandedTool == .title || !mediaItem.titleText.isEmpty || !mediaItem.subtitleText.isEmpty,
                             activeColor: .brandPrimary,
                             action: { expandedTool = expandedTool == .title ? nil : .title })
                }
                .padding(.top, 8)

                // Sub-tab — chips for whichever tool is expanded.
                Group {
                    switch expandedTool {
                    case .speed:
                        HStack(spacing: 8) {
                            speedChip("½×", rate: 0.5)
                            speedChip("1×", rate: 1.0)
                            speedChip("1½×", rate: 1.5)
                            speedChip("2×", rate: 2.0)
                        }
                    case .zoom:
                        HStack(spacing: 8) {
                            zoomPresetButton(label: "1×", zoom: nil)
                            zoomPresetButton(label: "1.5×", zoom: 1.5)
                            zoomPresetButton(label: "2×", zoom: 2.0)
                            zoomPresetButton(label: "3×", zoom: 3.0)
                        }
                    case .title:
                        VStack(spacing: 8) {
                            HStack(spacing: 10) {
                                Image(systemName: "textformat")
                                    .foregroundColor(.brandPrimary)
                                    .frame(width: 24)
                                TextField("", text: $mediaItem.titleText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            HStack(spacing: 10) {
                                Image(systemName: "textformat.size.smaller")
                                    .foregroundColor(.brandPrimary)
                                    .frame(width: 24)
                                TextField("", text: $mediaItem.subtitleText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            HStack(spacing: 10) {
                                colorSwatch(isWhite: true)
                                colorSwatch(isWhite: false)
                            }
                        }
                    case .none:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 4)
                .padding(.top, expandedTool == nil ? 0 : 6)
                .animation(.easeInOut(duration: 0.08), value: expandedTool)
            }
            .font(.system(size: 15.scaled))
            .padding(.horizontal)
            .padding(.top, 8)
            .onChange(of: pendingIsMuted) {
                Task { await updateAudioMix() }
            }

            // Fixed 36pt gap — NOT a greedy Spacer. If this were greedy, the
            // whole controls column would have infinite ideal size and
            // layoutPriority(1) would give it all the screen space, defeating
            // the outer video-centering Spacers.
            Color.clear.frame(height: 36)

            // Bottom action row — centered as a group.
            HStack(spacing: 20) {
                actionCircle(icon: "chevron.backward", tint: .brandPrimary, filled: false, action: dismissWithoutSaving)
                if onSplit != nil {
                    actionCircle(icon: "plus.square.on.square", tint: .brandPrimary, filled: false,
                                 disabled: !splitEnabled, action: performSplit)
                }
                actionCircle(icon: "checkmark", tint: .white, filled: true, action: performDone)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
            }
            // layoutPriority(1) makes the controls take their natural size, so
            // the two outer Spacers (above the video and here) share the
            // remaining space and center the video vertically in the top area.
            .layoutPriority(1)
            // Controls column: readable width + centered on iPad, full-bleed on iPhone.
            .iPadReadableWidth()
            .padding(.top, DeviceMetrics.isPad ? 12 : 0)
            .padding(.bottom, DeviceMetrics.isPad ? 28 : 0)
        }
        .onAppear {
            Task {
                await setupPlayer()
            }
        }
        .fullScreenCover(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(storeManager)
        }
    }

    // MARK: - Chip helpers

    @ViewBuilder
    private func toolIcon(icon: String, active: Bool, activeColor: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 26.scaled, weight: .semibold))
                .foregroundColor(active ? .white : .brandPrimary)
                .frame(width: 68.scaled, height: 58.scaled)
                .background(active ? activeColor : Color.brandPrimary.opacity(0.12))
                .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func speedChip(_ label: String, rate: Double) -> some View {
        let active = abs(pendingPlaybackRate - rate) < 0.01
        Button(action: {
            pendingPlaybackRate = rate
            expandedTool = nil
        }) {
            Text(label)
                .font(.system(size: 14.scaled, weight: .semibold))
                .foregroundColor(active ? .white : .brandPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8.scaled)
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
    private func actionCircle(icon: String, tint: Color, filled: Bool, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28.scaled, weight: .semibold))
                .foregroundColor(tint)
                .frame(width: 72.scaled, height: 72.scaled)
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
        .disabled(disabled)
        .opacity(disabled ? 0.35 : 1.0)
    }

    private func dismissWithoutSaving() {
        player?.pause()
        isPlaying = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismiss() }
    }

    private var splitEnabled: Bool {
        currentTime.seconds > trimStartTime.seconds + 0.1 &&
        currentTime.seconds < trimEndTime.seconds - 0.1
    }

    private func trimHandle(position: Binding<CGFloat>, geometry: GeometryProxy, color: Color) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: 10, height: 80)
            .offset(x: position.wrappedValue * geometry.size.width - (position.wrappedValue == rightHandlePosition ? 10 : 0))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        guard geometry.size.width > 0 else { return }
                        let newPosition = gesture.location.x / geometry.size.width
                        if position.wrappedValue == leftHandlePosition {
                            position.wrappedValue = max(0, min(rightHandlePosition - 0.05, newPosition))
                        } else {
                            position.wrappedValue = min(1, max(leftHandlePosition + 0.05, newPosition))
                        }
                        updateTrimTimes(width: geometry.size.width)
                    }
            )
    }

    private func playheadDragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                guard width > 0, duration.seconds > 0 else { return }
                let raw = gesture.location.x / width
                let clamped = max(leftHandlePosition, min(rightHandlePosition, raw))
                playheadPosition = clamped
                let t = CMTime(seconds: clamped * duration.seconds, preferredTimescale: 600)
                currentTime = t
                // Pause playback so the drag isn't fighting the time observer.
                if isPlaying {
                    player?.pause()
                    isPlaying = false
                }
                player?.seek(to: t, toleranceBefore: .zero, toleranceAfter: .zero)
            }
    }

    private func slowMoHandle(position: Binding<CGFloat>, geometry: GeometryProxy, color: Color) -> some View {
        Rectangle()
            .fill(color)
            .frame(width: 8, height: 30)
            .offset(x: position.wrappedValue * geometry.size.width - 4, y: 25)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        guard geometry.size.width > 0 else { return }
                        let newPosition = gesture.location.x / geometry.size.width
                        if position.wrappedValue == slowMoLeftHandlePosition {
                            position.wrappedValue = max(leftHandlePosition, min(slowMoRightHandlePosition - 0.05, newPosition))
                        } else {
                            position.wrappedValue = min(rightHandlePosition, max(slowMoLeftHandlePosition + 0.05, newPosition))
                        }
                        updateTrimTimes(width: geometry.size.width)
                    }
            )
    }

    private func setupPlayer() async {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat

        let avAsset = await withCheckedContinuation { continuation in
            PHImageManager.default().requestAVAsset(forVideo: mediaItem.asset, options: options) { avAsset, _, _ in
                continuation.resume(returning: avAsset)
            }
        }

        guard let avAsset = avAsset else { return }
        self.avAsset = avAsset
        let playerItem = AVPlayerItem(asset: avAsset)
        self.player = AVPlayer(playerItem: playerItem)

        // Seed draft edit state from the item so chip highlights are correct.
        self.pendingIsMuted = mediaItem.isMuted
        self.pendingPlaybackRate = mediaItem.playbackRate
        await updateAudioMix()

        do {
            self.duration = try await avAsset.load(.duration)
        } catch {
            print("Error loading duration: \(error)")
            return
        }

        // Display-oriented source size — mirrors the math in VideoCompiler so
        // the zoom presets produce a crop rect that matches what will render.
        if let videoTrack = try? await avAsset.load(.tracks).first(where: { $0.mediaType == .video }),
           let natural = try? await videoTrack.load(.naturalSize),
           let preferred = try? await videoTrack.load(.preferredTransform) {
            let isRotated = abs(preferred.b) > 0.1 || abs(preferred.c) > 0.1
            self.displaySourceSize = CGSize(
                width: isRotated ? natural.height : natural.width,
                height: isRotated ? natural.width : natural.height
            )
        }

        // Seed the draft crop from any already-saved value so re-entering the
        // trim view shows the previously-selected zoom highlighted.
        pendingCropRect = mediaItem.cropRect
        activeZoom = inferZoomFromCropRect(pendingCropRect)

        // Initialize trim times if not already set
        if mediaItem.startTime == .zero && mediaItem.endTime == nil {
            trimStartTime = .zero
            trimEndTime = duration
        } else {
            trimStartTime = mediaItem.startTime
            trimEndTime = mediaItem.endTime ?? duration
        }
        
        // Initialize slow-mo times
        if let start = mediaItem.slowMoStartTime, let end = mediaItem.slowMoEndTime {
            slowMoEnabled = true
            slowMoStartTime = start
            slowMoEndTime = end
            if duration.seconds > 0 {
                slowMoLeftHandlePosition = start.seconds / duration.seconds
                slowMoRightHandlePosition = end.seconds / duration.seconds
            }
        }

        // Set initial handle positions based on existing trim times
        if duration.seconds > 0 {
            leftHandlePosition = trimStartTime.seconds / duration.seconds
            rightHandlePosition = trimEndTime.seconds / duration.seconds
        }

        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.05, preferredTimescale: 600), queue: .main) { time in
            self.currentTime = time

            // Update playhead position
            if duration.seconds > 0 {
                self.playheadPosition = time.seconds / duration.seconds
            }

            // Handle slow-mo playback rate - only when playing
            if isPlaying {
                if slowMoEnabled, let slowStart = self.slowMoStartTime, let slowEnd = self.slowMoEndTime {
                    if time >= slowStart && time < slowEnd {
                        if player?.rate != 0.5 { player?.rate = 0.5 }
                    } else {
                        if player?.rate != 1.0 { player?.rate = 1.0 }
                    }
                } else {
                    if player?.rate != 1.0 { player?.rate = 1.0 }
                }
            }

            // Loop playback within trimmed range
            if isPlaying && time >= trimEndTime {
                player?.seek(to: trimStartTime)
            }
        }

        // Auto-play looped preview on entry — user can tap the video to pause.
        // completionHandler variant disambiguates from the async overload
        // Swift would otherwise pick inside this async function.
        player?.seek(to: trimStartTime, completionHandler: { _ in })
        player?.play()
        isPlaying = true
    }
    
    private func updateAudioMix() async {
        guard let player = player, let playerItem = player.currentItem else { return }

        if pendingIsMuted {
            let audioMix = AVMutableAudioMix()
            guard let audioTrack = try? await playerItem.asset.load(.tracks).first(where: { $0.mediaType == .audio }) else { return }
            
            let audioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
            audioMixInputParameters.setVolume(0.0, at: .zero)
            audioMix.inputParameters = [audioMixInputParameters]
            playerItem.audioMix = audioMix
        } else {
            // Restore default audio
            playerItem.audioMix = nil
        }
    }

    private func togglePlayPause() {
        guard let player = player else { return }
        if isPlaying {
            isPlaying = false  // Set this FIRST to prevent time observer from triggering loop
            player.pause()
        } else {
            isPlaying = true
            // Don't seek - just resume from current position
            player.play()
        }
    }

    private func pausePlayer() {
        player?.pause()
        isPlaying = false
    }

    private func updateTrimTimes(width: CGFloat) {
        guard duration.seconds > 0 else { return }
        trimStartTime = CMTime(seconds: leftHandlePosition * duration.seconds, preferredTimescale: 600)
        trimEndTime = CMTime(seconds: rightHandlePosition * duration.seconds, preferredTimescale: 600)

        if slowMoEnabled {
            slowMoStartTime = CMTime(seconds: slowMoLeftHandlePosition * duration.seconds, preferredTimescale: 600)
            slowMoEndTime = CMTime(seconds: slowMoRightHandlePosition * duration.seconds, preferredTimescale: 600)
        }

        // Snap the playhead to the left trim edge on any handle drag so Save
        // (which requires playhead inside the trim range) is always available.
        currentTime = trimStartTime
        playheadPosition = leftHandlePosition
        player?.seek(to: trimStartTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    @ViewBuilder
    private func zoomPresetButton(label: String, zoom: CGFloat?) -> some View {
        let active = activeZoom == zoom
        Button(action: {
            applyZoom(zoom)
            expandedTool = nil
        }) {
            Text(label)
                .font(.system(size: 14.scaled, weight: .semibold))
                .foregroundColor(active ? .white : .brandPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10.scaled)
                .background(
                    Group {
                        if active {
                            LinearGradient(
                                colors: Color.primaryGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.brandPrimary.opacity(0.12)
                        }
                    }
                )
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .disabled(displaySourceSize == .zero)
    }

    /// Sets `pendingCropRect` to a centered target-aspect rect at the given
    /// zoom. `nil` clears the crop (Fit). Applied to mediaItem on Done/Split.
    private func applyZoom(_ zoom: CGFloat?) {
        activeZoom = zoom
        guard let zoom = zoom,
              displaySourceSize.width > 0, displaySourceSize.height > 0,
              zoom > 0 else {
            pendingCropRect = nil
            return
        }
        let sourceAspect = displaySourceSize.width / displaySourceSize.height
        let baseW: CGFloat
        let baseH: CGFloat
        if sourceAspect >= targetAspectRatio {
            baseH = 1
            baseW = min(1, targetAspectRatio / sourceAspect)
        } else {
            baseW = 1
            baseH = min(1, sourceAspect / targetAspectRatio)
        }
        let w = min(1, baseW / zoom)
        let h = min(1, baseH / zoom)
        pendingCropRect = CGRect(x: (1 - w) / 2, y: (1 - h) / 2, width: w, height: h)
    }

    /// Best-effort reverse of `applyZoom` — matches an existing cropRect to
    /// whichever preset it was created from, so the button highlight is right
    /// when re-entering the trim view on a previously-cropped clip.
    private func inferZoomFromCropRect(_ rect: CGRect?) -> CGFloat? {
        guard let rect = rect,
              displaySourceSize.width > 0, displaySourceSize.height > 0 else { return nil }
        let sourceAspect = displaySourceSize.width / displaySourceSize.height
        let baseW: CGFloat = sourceAspect >= targetAspectRatio ? min(1, targetAspectRatio / sourceAspect) : 1
        guard rect.width > 0 else { return nil }
        let z = baseW / rect.width
        // Match with a small tolerance to the presets we offer.
        for preset in [1.5, 2.0, 3.0] as [CGFloat] where abs(z - preset) < 0.05 {
            return preset
        }
        return nil
    }

    private func formatTime(_ time: CMTime) -> String {
        guard time.isValid else { return "0:00" }
        let totalSeconds = CMTimeGetSeconds(time)
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Preview sizing / zoom

    private var sourceAspectRatio: CGFloat {
        guard displaySourceSize.height > 0 else { return 16.0 / 9.0 }
        return displaySourceSize.width / displaySourceSize.height
    }

    /// Live preview zoom scale — 1× if no crop, else `1 / min(width, height)`
    /// of the crop rect so the smaller dimension fills the container.
    private var zoomScale: CGFloat {
        guard let rect = pendingCropRect, rect.width > 0, rect.height > 0 else { return 1.0 }
        return 1.0 / min(rect.width, rect.height)
    }

    /// SwiftUI's .scaleEffect(anchor:) keeps the anchor point fixed while
    /// everything else scales around it. For the visible container region
    /// (0..1 normalized) to show `cropRect`, the anchor must be at
    /// `origin / (1 - 1/scale)` — not the midpoint, which would only work
    /// for centered crops. Getting this wrong makes off-center drags render
    /// the wrong region.
    private var zoomAnchor: UnitPoint {
        guard let rect = pendingCropRect else { return .center }
        let s = zoomScale
        guard s > 1 else { return .center }
        let invS = 1.0 / s
        let denom = 1 - invS
        guard denom > 0 else { return .center }
        // Anchor for the aspect-fit dimension where the crop covers the full container:
        //   x-axis: origin.x + rect.width == 1 iff cropRect fills width
        // Use midX/midY-based anchor for the axis that doesn't fill.
        let ax: CGFloat
        let ay: CGFloat
        // Approximate: for a square-ish scale we treat both axes identically.
        // (Aspect discrepancies are already absorbed into rect w/h at construction.)
        ax = min(1, max(0, rect.origin.x / denom))
        ay = min(1, max(0, rect.origin.y / denom))
        return UnitPoint(x: ax, y: ay)
    }

    private func commitPendingEditsToItem() {
        mediaItem.isMuted = pendingIsMuted
        mediaItem.playbackRate = pendingPlaybackRate
        mediaItem.cropRect = pendingCropRect
        // Region-based slow-mo UI was removed; whole-clip speed replaces it.
        // Preserve existing slow-mo state that may already be on the item
        // (legacy) so we don't destroy it, but no new writes.
    }

    private func performDone() {
        player?.pause()
        isPlaying = false
        mediaItem.startTime = trimStartTime
        mediaItem.endTime = trimEndTime
        commitPendingEditsToItem()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismiss() }
    }

    private func performSplit() {
        let splitTime = currentTime
        player?.pause()
        isPlaying = false
        mediaItem.startTime = trimStartTime
        mediaItem.endTime = splitTime
        commitPendingEditsToItem()

        onSplit?(splitTime)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismiss() }
    }

    @ViewBuilder
    private func colorSwatch(isWhite: Bool) -> some View {
        let active = mediaItem.titleIsWhite == isWhite
        Button(action: { mediaItem.titleIsWhite = isWhite }) {
            Circle()
                .fill(isWhite ? Color.white : Color.black)
                .frame(width: 30, height: 30)
                .overlay(Circle().stroke(active ? Color.brandPrimary : Color.gray.opacity(0.5), lineWidth: active ? 3 : 1))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var titleOverlayView: some View {
        let title = mediaItem.titleText
        let subtitle = mediaItem.subtitleText
        let fg: Color = mediaItem.titleIsWhite ? .white : .black
        let shadow: Color = mediaItem.titleIsWhite ? .black : .white
        if !title.isEmpty || !subtitle.isEmpty {
            VStack(spacing: 4) {
                if !title.isEmpty {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(fg)
                        .shadow(color: shadow.opacity(0.7), radius: 4, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(fg)
                        .shadow(color: shadow.opacity(0.7), radius: 3, x: 0, y: 1)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
    }

    /// Tap the video → toggle play/pause and flash a big icon in the center.
    private func handleVideoTap() {
        guard let player = player else { return }
        if isPlaying {
            player.pause()
            isPlaying = false
            flashTapIcon("pause.fill")
        } else {
            player.play()
            isPlaying = true
            flashTapIcon("play.fill")
        }
    }

    private func flashTapIcon(_ name: String) {
        withAnimation(.easeOut(duration: 0.15)) { tapFeedbackIcon = name }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            withAnimation(.easeIn(duration: 0.25)) { tapFeedbackIcon = nil }
        }
    }

    /// Pan the current crop rect within the source. No-op if not zoomed.
    private func dragCrop(translation: CGSize, container: CGSize) {
        guard pendingCropRect != nil, container.width > 0, container.height > 0 else { return }
        if dragBaseRect == nil { dragBaseRect = pendingCropRect }
        guard let base = dragBaseRect else { return }
        let scale = 1.0 / min(base.width, base.height)
        // Drag right → user sees content shift right → origin.x DECREASES.
        let dxN = translation.width / (container.width * scale)
        let dyN = translation.height / (container.height * scale)
        var newRect = base
        newRect.origin.x = max(0, min(1 - base.width, base.origin.x - dxN))
        newRect.origin.y = max(0, min(1 - base.height, base.origin.y - dyN))
        pendingCropRect = newRect
    }
}

// MARK: - AVPlayerLayer wrapper

/// Bare AVPlayerLayer — no chrome, so `.scaleEffect` cleanly zooms the video.
/// TrimmingView already has its own play/pause + scrubber below, so the
/// player controls that AVPlayerViewController would add are redundant.
private struct ZoomablePlayerView: UIViewRepresentable {
    let player: AVPlayer

    final class Container: UIView {
        override class var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    }

    func makeUIView(context: Context) -> Container {
        let view = Container()
        view.backgroundColor = .black
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: Container, context: Context) {
        // Reassert gravity every update — SwiftUI can recycle the view and
        // some hosting paths lose the makeUIView state.
        uiView.playerLayer.videoGravity = .resizeAspectFill
        if uiView.playerLayer.player !== player {
            uiView.playerLayer.player = player
        }
    }
}
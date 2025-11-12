import SwiftUI
import AVFoundation
import Photos

struct TrimmingView: View {
    @Binding var mediaItem: MediaItem
    @Environment(\.dismiss) var dismiss

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

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayerView(player: player)
                    .frame(height: 300)
                    .onDisappear(perform: pausePlayer)
            } else {
                ProgressView("Loading video...")
                    .frame(height: 300)
            }

            // Play/Pause Button
            Button(action: togglePlayPause) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.largeTitle)
                    .foregroundColor(.brandPrimary)
            }
            .padding()
            .disabled(player == nil)

            // Trimming UI
            VStack {
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
                        
                        // Playhead
                        Rectangle()
                            .fill(Color.pink)
                            .frame(width: 2, height: 80)
                            .offset(x: playheadPosition * geometry.size.width)

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
                
                Toggle("Enable Slow-Mo", isOn: $slowMoEnabled.animation())
                    .padding(.horizontal)
                
                Toggle("Mute Video", isOn: $mediaItem.isMuted)
                    .padding(.horizontal)
            }
            .padding()
            .onChange(of: mediaItem.isMuted) {
                Task {
                    await updateAudioMix()
                }
            }

            HStack {
                Text("Start: \(formatTime(trimStartTime))")
                Spacer()
                Text("End: \(formatTime(trimEndTime))")
            }
            .padding(.horizontal)

            Button("Done") {
                mediaItem.startTime = trimStartTime
                mediaItem.endTime = trimEndTime
                if slowMoEnabled {
                    mediaItem.slowMoStartTime = slowMoStartTime
                    mediaItem.slowMoEndTime = slowMoEndTime
                } else {
                    mediaItem.slowMoStartTime = nil
                    mediaItem.slowMoEndTime = nil
                }
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical)
            .padding(.horizontal, 50)
            .background(
                LinearGradient(
                    colors: Color.brandGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: Color.brandSecondary.opacity(0.5), radius: 15, x: 0, y: 8)
        }
        .onAppear {
            Task {
                await setupPlayer()
            }
        }
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
        
        await updateAudioMix()

        do {
            self.duration = try await avAsset.load(.duration)
        } catch {
            print("Error loading duration: \(error)")
            return
        }

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
            
            // Handle slow-mo playback rate
            if slowMoEnabled, let slowStart = self.slowMoStartTime, let slowEnd = self.slowMoEndTime {
                if time >= slowStart && time < slowEnd {
                    if player?.rate != 0.5 { player?.rate = 0.5 }
                } else {
                    if player?.rate != 1.0 { player?.rate = 1.0 }
                }
            } else {
                if player?.rate != 1.0 { player?.rate = 1.0 }
            }

            // Loop playback within trimmed range
            if isPlaying && time >= trimEndTime {
                player?.seek(to: trimStartTime)
            }
        }
    }
    
    private func updateAudioMix() async {
        guard let player = player, let playerItem = player.currentItem else { return }

        if mediaItem.isMuted {
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
            player.pause()
        } else {
            player.seek(to: trimStartTime)
            player.play()
        }
        isPlaying.toggle()
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
        
        // Seek player to new start time when handles are moved
        player?.seek(to: trimStartTime)
    }

    private func formatTime(_ time: CMTime) -> String {
        guard time.isValid else { return "0:00" }
        let totalSeconds = CMTimeGetSeconds(time)
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }
}
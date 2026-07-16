import AVFoundation
import Photos
import UIKit
import CoreVideo

enum VideoCompositionError: Error {
    case trackCreationFailed
    case exportFailed
    case videoLoadFailed
    case imageLoadFailed
}

class VideoCompiler {
    
    private actor BackgroundTaskActor {
        var taskID: UIBackgroundTaskIdentifier = .invalid

        func begin() async {
            let newBackgroundTaskID = await MainActor.run {
                UIApplication.shared.beginBackgroundTask { [weak self] in
                    Task {
                        await self?.end()
                    }
                }
            }
            self.taskID = newBackgroundTaskID
        }

        func end() async {
            let currentTaskID = self.taskID
            self.taskID = .invalid // Reset immediately within actor's context

            await MainActor.run {
                if currentTaskID != .invalid {
                    UIApplication.shared.endBackgroundTask(currentTaskID)
                }
            }
        }
    }
    
    static func compileVideos(
        media: [MediaItem],
        settings: VideoCompilationSettings,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let taskActor = BackgroundTaskActor()
        
        Task.detached(priority: .userInitiated) {
            await taskActor.begin()

            do {
                try await performCompilation(
                    media: media,
                    settings: settings,
                    progressHandler: progressHandler,
                    completion: completion
                )
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }

            await taskActor.end()
        }
    }

    private static func performCompilation(
        media: [MediaItem],
        settings: VideoCompilationSettings,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<URL, Error>) -> Void
    ) async throws {
        do {
            let (composition, videoComposition, retainedSources) = try await buildComposition(
                media: media,
                settings: settings,
                progressHandler: progressHandler
            )
            // Keep retained sources alive for the duration of the export.
            _ = retainedSources

            // Export
            let outputURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("mp4")
            try? FileManager.default.removeItem(at: outputURL)

            guard let exportSession = AVAssetExportSession(
                asset: composition,
                presetName: AVAssetExportPresetHighestQuality
            ) else {
                throw VideoCompositionError.exportFailed
            }
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            exportSession.videoComposition = videoComposition

            await exportSession.export()

            if exportSession.status == .failed {
                throw exportSession.error ?? VideoCompositionError.exportFailed
            }

            await MainActor.run { progressHandler(0.9) }

            let finalURL: URL
            if let musicAsset = settings.musicAsset {
                finalURL = try await addBackgroundMusic(
                    to: outputURL,
                    musicAsset: musicAsset,
                    volume: settings.musicVolume
                )
            } else {
                finalURL = outputURL
            }

            await MainActor.run { progressHandler(1.0) }
            await MainActor.run { completion(.success(finalURL)) }
        } catch {
            await MainActor.run { completion(.failure(error)) }
        }
    }

    /// Build an AVMutableComposition + AVMutableVideoComposition from the media
    /// list and settings. This is the same composition the exporter uses, so
    /// SettingsView can hand it to an AVPlayer for real-time preview WITHOUT
    /// running the (slow) AVAssetExportSession encoder.
    static func buildComposition(
        media: [MediaItem],
        settings: VideoCompilationSettings,
        progressHandler: @escaping (Double) -> Void = { _ in },
        attachOverlays: Bool = true,
        renderScale: CGFloat = 1.0
    ) async throws -> (AVMutableComposition, AVMutableVideoComposition, [AVAsset]) {
        do {
            // Preview path can down-scale the render target so the sim's
            // videoCompositor doesn't choke on 1920x1080 (error -19230).
            // Round to even dimensions — H.264 requires even width/height.
            let fullSize = settings.orientation.size
            let targetSize = renderScale >= 0.999
                ? fullSize
                : CGSize(width: floor(fullSize.width * renderScale / 2) * 2,
                         height: floor(fullSize.height * renderScale / 2) * 2)
            let composition = AVMutableComposition()

            guard let videoTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid
            ) else {
                throw VideoCompositionError.trackCreationFailed
            }

            // Only add an audio track if at least one clip has usable audio.
            // An empty audio track on a photo-only composition triggers
            // AVError -11838 / VT -16976 at export under HighestQuality.
            let needsAudioTrack = media.contains { item in
                item.asset.mediaType == .video && !item.isMuted
            }
            let audioTrack: AVMutableCompositionTrack? = needsAudioTrack
                ? composition.addMutableTrack(
                    withMediaType: .audio,
                    preferredTrackID: kCMPersistentTrackID_Invalid
                  )
                : nil
            if needsAudioTrack && audioTrack == nil {
                throw VideoCompositionError.trackCreationFailed
            }

            var instructions: [AVMutableVideoCompositionInstruction] = []
            // Track each clip's placement in the composition so the
            // animationTool block below can add per-clip text overlays.
            var clipRanges: [(item: MediaItem, start: CMTime, duration: CMTime)] = []
            // Retain source AVAssets to prevent them from being deallocated
            // mid-playback — image segments' AVURLAssets in particular need
            // this because the composition doesn't strongly hold sources.
            var retainedSources: [AVAsset] = []

            await MainActor.run { progressHandler(0.1) }

            var insertionPoint = CMTime.zero
            var videoInstructions: [AVMutableVideoCompositionInstruction] = []

            // Process each item (video or photo)
            for (index, item) in media.enumerated() {
                let clipStartTime = insertionPoint // Mark the start of this clip in the composition

                let progress = 0.1 + (Double(index) / Double(media.count)) * 0.7
                await MainActor.run { progressHandler(progress) }

                let isImage = item.asset.mediaType == .image
                let videoAsset: AVAsset
                if isImage {
                    let image = try await loadFullImage(for: item.asset, targetSize: targetSize)
                    // Per-photo override wins; fall back to global setting.
                    let secs = item.photoDuration ?? settings.photoDuration
                    let photoDuration = CMTime(seconds: secs, preferredTimescale: 30)
                    let segmentURL = try await createImageVideoSegment(
                        image: image,
                        duration: photoDuration,
                        size: targetSize
                    )
                    videoAsset = AVURLAsset(url: segmentURL)
                } else {
                    videoAsset = try await loadVideoAsset(for: item.asset)
                }
                retainedSources.append(videoAsset)

                guard let sourceVideoTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .video }) else {
                    continue
                }

                let originalVideoDuration = try await videoAsset.load(.duration)

                // For photos use the full segment; for videos honor user trim
                let actualStartTime: CMTime
                let actualEndTime: CMTime
                if isImage {
                    actualStartTime = .zero
                    actualEndTime = originalVideoDuration
                } else {
                    actualStartTime = item.startTime
                    actualEndTime = item.endTime ?? originalVideoDuration
                }

                let currentClipDuration = CMTimeSubtract(actualEndTime, actualStartTime)

                var effectiveClipDurationInComposition = CMTime.zero // This will be the duration of the clip in the composition, including slow-mo

                // Handle slow-mo if present (videos only — images skip this branch)
                if !isImage, let slowMoStartTime = item.slowMoStartTime, let slowMoEndTime = item.slowMoEndTime {
                    let preSlowMoDuration = CMTimeSubtract(slowMoStartTime, actualStartTime)
                    let slowMoDuration = CMTimeSubtract(slowMoEndTime, slowMoStartTime)
                    let postSlowMoDuration = CMTimeSubtract(actualEndTime, slowMoEndTime)
                    let scaledSlowMoDuration = CMTimeMultiplyByFloat64(slowMoDuration, multiplier: 2.0) // Half speed

                    var tempClipDuration = CMTime.zero // Track duration of this specific slow-mo processed clip

                    // Insert pre-slow-mo part
                    if preSlowMoDuration > .zero {
                        try videoTrack.insertTimeRange(CMTimeRange(start: actualStartTime, duration: preSlowMoDuration), of: sourceVideoTrack, at: insertionPoint)
                        if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                            try? audioTrack?.insertTimeRange(CMTimeRange(start: actualStartTime, duration: preSlowMoDuration), of: sourceAudioTrack, at: insertionPoint)
                        }
                        insertionPoint = CMTimeAdd(insertionPoint, preSlowMoDuration)
                        tempClipDuration = CMTimeAdd(tempClipDuration, preSlowMoDuration)
                    }

                    // Insert and scale slow-mo part
                    try videoTrack.insertTimeRange(CMTimeRange(start: slowMoStartTime, duration: slowMoDuration), of: sourceVideoTrack, at: insertionPoint)
                    videoTrack.scaleTimeRange(CMTimeRange(start: insertionPoint, duration: slowMoDuration), toDuration: scaledSlowMoDuration)

                    if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                        try? audioTrack?.insertTimeRange(CMTimeRange(start: slowMoStartTime, duration: slowMoDuration), of: sourceAudioTrack, at: insertionPoint)
                        audioTrack?.scaleTimeRange(CMTimeRange(start: insertionPoint, duration: slowMoDuration), toDuration: scaledSlowMoDuration)
                    }
                    insertionPoint = CMTimeAdd(insertionPoint, scaledSlowMoDuration)
                    tempClipDuration = CMTimeAdd(tempClipDuration, scaledSlowMoDuration)

                    // Insert post-slow-mo part
                    if postSlowMoDuration > .zero {
                        try videoTrack.insertTimeRange(CMTimeRange(start: slowMoEndTime, duration: postSlowMoDuration), of: sourceVideoTrack, at: insertionPoint)
                        if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                            try? audioTrack?.insertTimeRange(CMTimeRange(start: slowMoEndTime, duration: postSlowMoDuration), of: sourceAudioTrack, at: insertionPoint)
                        }
                        insertionPoint = CMTimeAdd(insertionPoint, postSlowMoDuration)
                        tempClipDuration = CMTimeAdd(tempClipDuration, postSlowMoDuration)
                    }
                    effectiveClipDurationInComposition = tempClipDuration // Correct calculation
                } else {
                    // Handle video without slow-mo (original trimming logic)
                    try videoTrack.insertTimeRange(CMTimeRange(start: actualStartTime, duration: currentClipDuration), of: sourceVideoTrack, at: insertionPoint)
                    if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                        try? audioTrack?.insertTimeRange(CMTimeRange(start: actualStartTime, duration: currentClipDuration), of: sourceAudioTrack, at: insertionPoint)
                    }

                    // Apply whole-clip playback rate (Speed picker) via scaleTimeRange.
                    // rate == 1.0 → no-op. rate == 0.5 → clip plays half-speed (2x
                    // duration). rate == 2.0 → clip plays 2x speed (half duration).
                    if item.playbackRate > 0 && abs(item.playbackRate - 1.0) > 0.001 {
                        let scaledDuration = CMTimeMultiplyByFloat64(currentClipDuration, multiplier: 1.0 / item.playbackRate)
                        let insertedRange = CMTimeRange(start: insertionPoint, duration: currentClipDuration)
                        videoTrack.scaleTimeRange(insertedRange, toDuration: scaledDuration)
                        audioTrack?.scaleTimeRange(insertedRange, toDuration: scaledDuration)
                        insertionPoint = CMTimeAdd(insertionPoint, scaledDuration)
                        effectiveClipDurationInComposition = scaledDuration
                    } else {
                        insertionPoint = CMTimeAdd(insertionPoint, currentClipDuration)
                        effectiveClipDurationInComposition = currentClipDuration
                    }
                }

                // Create instruction for proper sizing for the entire duration of the clip in the composition
                let instruction = AVMutableVideoCompositionInstruction()
                instruction.timeRange = CMTimeRange(start: clipStartTime, duration: effectiveClipDurationInComposition) // Use the effective duration

                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)

                // Calculate transform to fit target size
                let naturalSize = try await sourceVideoTrack.load(.naturalSize)
                let preferredTransform = try await sourceVideoTrack.load(.preferredTransform)
                let transform = calculateTransform(
                    from: naturalSize,
                    to: targetSize,
                    preferredTransform: preferredTransform,
                    cropRect: isImage ? nil : item.cropRect
                )

                // Set transform for this time range
                layerInstruction.setTransform(transform, at: clipStartTime) // Set transform for the entire clip

                instruction.layerInstructions = [layerInstruction]
                videoInstructions.append(instruction)

                clipRanges.append((item, clipStartTime, effectiveClipDurationInComposition))

                // Fade-to-black transitions used to be implemented here via
                // CALayer/CABasicAnimation feeding a CoreAnimationTool, but
                // that tool was disabled (see AVError -11838 diagnostic notes
                // in the git history) and the layer code became dead. Removed
                // as part of the buildComposition refactor.
            }
            instructions = videoInstructions

            let videoComposition = AVMutableVideoComposition()
            videoComposition.instructions = instructions
            videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
            videoComposition.renderSize = targetSize

            // Overlays: per-clip title/subtitle + global retro date stamp.
            // Skipped entirely when attachOverlays=false (preview path) because
            // AVVideoCompositionCoreAnimationTool is export-only.
            let hasPerClipText = clipRanges.contains { !$0.item.titleText.isEmpty || !$0.item.subtitleText.isEmpty }
            let hasDate = settings.dateStamp != nil

            if attachOverlays && (hasPerClipText || hasDate) {
                let renderSize = settings.orientation.size
                let parentLayer = CALayer()
                parentLayer.frame = CGRect(origin: .zero, size: renderSize)
                let videoLayer = CALayer()
                videoLayer.frame = CGRect(origin: .zero, size: renderSize)
                parentLayer.addSublayer(videoLayer)

                // Per-clip title/subtitle overlays — CATextLayer per clip, with
                // opacity keyframes so it appears only during that clip's range.
                for range in clipRanges {
                    let title = range.item.titleText
                    let subtitle = range.item.subtitleText
                    guard !title.isEmpty || !subtitle.isEmpty else { continue }
                    let clipStart = range.start.seconds
                    let clipEnd = clipStart + range.duration.seconds
                    let fadeDur: Double = 0.15
                    let combined: String = {
                        if !title.isEmpty && !subtitle.isEmpty { return title + "\n" + subtitle }
                        return title.isEmpty ? subtitle : title
                    }()

                    let textLayer = CATextLayer()
                    textLayer.string = combined
                    textLayer.font = CTFontCreateWithName("HelveticaNeue-Bold" as CFString, 0, nil)
                    textLayer.fontSize = min(renderSize.width, renderSize.height) * 0.048
                    textLayer.foregroundColor = (range.item.titleIsWhite ? UIColor.white : UIColor.black).cgColor
                    textLayer.alignmentMode = .center
                    textLayer.isWrapped = true
                    textLayer.contentsScale = UIScreen.main.scale
                    textLayer.shadowColor = (range.item.titleIsWhite ? UIColor.black : UIColor.white).cgColor
                    textLayer.shadowOpacity = 0.7
                    textLayer.shadowOffset = CGSize(width: 0, height: -1)
                    textLayer.shadowRadius = 4
                    let textHeight = textLayer.fontSize * 3
                    let sideMargin: CGFloat = renderSize.width * 0.05
                    // Center vertically instead of bottom-anchored.
                    let centerY: CGFloat = (renderSize.height - textHeight) / 2
                    textLayer.frame = CGRect(
                        x: sideMargin,
                        y: centerY,
                        width: renderSize.width - sideMargin * 2,
                        height: textHeight
                    )
                    textLayer.opacity = 0

                    // Keyframe: fade in at clipStart, hold until near end, fade out.
                    let anim = CAKeyframeAnimation(keyPath: "opacity")
                    anim.values = [0.0, 1.0, 1.0, 0.0]
                    let visibleStart = clipStart
                    let visibleFadeInEnd = min(clipStart + fadeDur, clipEnd)
                    let visibleFadeOutStart = max(clipEnd - fadeDur, clipStart)
                    let visibleEnd = clipEnd
                    // Whole composition times, referenced from AVCoreAnimationBeginTimeAtZero.
                    anim.keyTimes = [
                        NSNumber(value: visibleStart),
                        NSNumber(value: visibleFadeInEnd),
                        NSNumber(value: visibleFadeOutStart),
                        NSNumber(value: visibleEnd),
                    ]
                    anim.calculationMode = .linear
                    anim.beginTime = AVCoreAnimationBeginTimeAtZero
                    anim.duration = max(0.01, visibleEnd)
                    anim.isRemovedOnCompletion = false
                    anim.fillMode = .forwards
                    // Above uses absolute-composition-time keyTimes with
                    // beginTime=AVCoreAnimationBeginTimeAtZero; we treat the
                    // keyTimes as SECONDS by using a duration equal to visibleEnd
                    // — CAKeyframeAnimation interprets keyTimes as [0,1] ratios
                    // by default, so normalize:
                    let total = max(0.001, visibleEnd)
                    anim.keyTimes = [
                        NSNumber(value: visibleStart / total),
                        NSNumber(value: visibleFadeInEnd / total),
                        NSNumber(value: visibleFadeOutStart / total),
                        NSNumber(value: visibleEnd / total),
                    ]
                    textLayer.add(anim, forKey: "opacity")
                    parentLayer.addSublayer(textLayer)
                }

                // Global retro date stamp in bottom-right.
                if let stampDate = settings.dateStamp {
                    let df = DateFormatter()
                    df.dateFormat = "MMM d yyyy"
                    let dateText = df.string(from: stampDate).uppercased()

                    let dateLayer = CATextLayer()
                    dateLayer.string = dateText
                    dateLayer.font = CTFontCreateWithName("Courier-Bold" as CFString, 0, nil)
                    dateLayer.fontSize = min(renderSize.width, renderSize.height) * 0.038
                    dateLayer.foregroundColor = UIColor(red: 1.0, green: 0.55, blue: 0.15, alpha: 0.95).cgColor
                    dateLayer.alignmentMode = .right
                    dateLayer.contentsScale = UIScreen.main.scale
                    dateLayer.shadowColor = UIColor.black.cgColor
                    dateLayer.shadowOpacity = 0.6
                    dateLayer.shadowOffset = CGSize(width: 1, height: -1)
                    dateLayer.shadowRadius = 2
                    let textWidth: CGFloat = renderSize.width * 0.35
                    let textHeight: CGFloat = dateLayer.fontSize * 1.4
                    let margin: CGFloat = min(renderSize.width, renderSize.height) * 0.04
                    dateLayer.frame = CGRect(
                        x: renderSize.width - textWidth - margin,
                        y: margin,
                        width: textWidth,
                        height: textHeight
                    )
                    parentLayer.addSublayer(dateLayer)
                }

                videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
                    postProcessingAsVideoLayer: videoLayer,
                    in: parentLayer
                )
            }

            await MainActor.run { progressHandler(0.8) }

            return (composition, videoComposition, retainedSources)
        } catch {
            throw error
        }
    }

    private static func loadVideoAsset(for asset: PHAsset) async throws -> AVAsset {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat

        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error)
                } else if let avAsset = avAsset {
                    continuation.resume(returning: avAsset)
                } else {
                    continuation.resume(throwing: VideoCompositionError.videoLoadFailed)
                }
            }
        }
    }

    private static func loadFullImage(for asset: PHAsset, targetSize: CGSize) async throws -> UIImage {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isSynchronous = false

        return try await withCheckedThrowingContinuation { continuation in
            var didResume = false
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: options
            ) { image, info in
                // PHImageManager may call the handler twice (low-res then high-res).
                // We only want to resume the continuation on the final delivery.
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                guard !isDegraded, !didResume else { return }
                didResume = true
                if let image = image {
                    continuation.resume(returning: image)
                } else if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: VideoCompositionError.imageLoadFailed)
                }
            }
        }
    }

    private static func createImageVideoSegment(image: UIImage, duration: CMTime, size: CGSize) async throws -> URL {
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + "_image_segment")
            .appendingPathExtension("mp4")

        try? FileManager.default.removeItem(at: outputURL)

        let assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)

        // Force Baseline profile (no B-frames) — Main profile with B-frames caused
        // AVError -11838 / VideoToolbox -16976 at export time when these segments
        // were inserted into a composition exported with AVAssetExportPresetHighestQuality.
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height,
            AVVideoCompressionPropertiesKey: [
                AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel,
                AVVideoAverageBitRateKey: 6_000_000,
                AVVideoMaxKeyFrameIntervalKey: 30,
                AVVideoAllowFrameReorderingKey: false
            ],
            AVVideoColorPropertiesKey: [
                AVVideoColorPrimariesKey: AVVideoColorPrimaries_ITU_R_709_2,
                AVVideoTransferFunctionKey: AVVideoTransferFunction_ITU_R_709_2,
                AVVideoYCbCrMatrixKey: AVVideoYCbCrMatrix_ITU_R_709_2
            ]
        ]

        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput.expectsMediaDataInRealTime = false

        let pixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
            kCVPixelBufferWidthKey as String: size.width,
            kCVPixelBufferHeightKey as String: size.height
        ]

        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: videoInput,
            sourcePixelBufferAttributes: pixelBufferAttributes
        )

        assetWriter.add(videoInput)
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: .zero)

        // Aspect-FILL the photo into the target frame. Any excess bleeds off
        // the edges — we prefer edge-crop over letterboxing so every clip fills
        // the frame consistently.
        let composited = UIGraphicsImageRenderer(size: size).image { _ in
            UIColor.black.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            let imgSize = image.size
            guard imgSize.width > 0, imgSize.height > 0 else { return }
            let scale = max(size.width / imgSize.width, size.height / imgSize.height)
            let drawSize = CGSize(width: imgSize.width * scale, height: imgSize.height * scale)
            let drawOrigin = CGPoint(
                x: (size.width - drawSize.width) / 2,
                y: (size.height - drawSize.height) / 2
            )
            image.draw(in: CGRect(origin: drawOrigin, size: drawSize))
        }

        guard let pixelBuffer = bgraPixelBuffer(from: composited, size: size) else {
            throw VideoCompositionError.imageLoadFailed
        }

        let frameDuration = CMTime(value: 1, timescale: 30)
        let totalFrames = Int64(duration.seconds * 30)

        var frameCount: Int64 = 0
        while frameCount < totalFrames {
            if videoInput.isReadyForMoreMediaData {
                let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameCount))
                pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                frameCount += 1
            } else {
                try? await Task.sleep(nanoseconds: 10_000_000)
            }
        }

        videoInput.markAsFinished()
        await assetWriter.finishWriting()

        if assetWriter.status == .failed {
            throw assetWriter.error ?? VideoCompositionError.exportFailed
        }

        return outputURL
    }

    private static func calculateTransform(
        from sourceSize: CGSize,
        to targetSize: CGSize,
        preferredTransform: CGAffineTransform,
        cropRect: CGRect? = nil
    ) -> CGAffineTransform {
        // Handle edge cases
        guard sourceSize.width > 0 && sourceSize.height > 0 &&
              targetSize.width > 0 && targetSize.height > 0 else {
            return .identity
        }

        // Determine if the video is rotated (portrait vs landscape)
        let isRotated = abs(preferredTransform.b) > 0.1 || abs(preferredTransform.c) > 0.1

        // Get actual dimensions considering rotation
        let actualWidth = isRotated ? sourceSize.height : sourceSize.width
        let actualHeight = isRotated ? sourceSize.width : sourceSize.height

        if let crop = cropRect,
           crop.width > 0, crop.height > 0,
           crop.width.isFinite, crop.height.isFinite,
           crop.origin.x.isFinite, crop.origin.y.isFinite {
            // Aspect-FILL the crop region into the target. Take max so the crop
            // covers the whole target frame (any excess bleeds off-screen).
            let cropPixelWidth = crop.width * actualWidth
            let cropPixelHeight = crop.height * actualHeight
            let scale = max(targetSize.width / cropPixelWidth,
                            targetSize.height / cropPixelHeight)

            guard scale > 0 && !scale.isNaN && !scale.isInfinite else {
                return .identity
            }

            // Move crop's top-left to (0,0), then re-center any leftover excess
            // when the crop aspect doesn't match target aspect.
            let translateX = -crop.origin.x * actualWidth * scale
                + (targetSize.width - cropPixelWidth * scale) / 2.0
            let translateY = -crop.origin.y * actualHeight * scale
                + (targetSize.height - cropPixelHeight * scale) / 2.0

            var transform = preferredTransform
            transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
            transform = transform.concatenating(CGAffineTransform(translationX: translateX, y: translateY))
            return transform
        }

        // Aspect-FILL the video into the target size. Every clip fills the
        // frame; excess bleeds off. Consistent with photo pre-compositing.
        let scaleWidth = targetSize.width / actualWidth
        let scaleHeight = targetSize.height / actualHeight
        let scale = max(scaleWidth, scaleHeight)

        // Prevent invalid scale values
        guard scale > 0 && !scale.isNaN && !scale.isInfinite else {
            return .identity
        }

        // Calculate translation to center the video
        let scaledWidth = actualWidth * scale
        let scaledHeight = actualHeight * scale
        let translateX = (targetSize.width - scaledWidth) / 2.0
        let translateY = (targetSize.height - scaledHeight) / 2.0

        // Build the transform
        var transform = preferredTransform
        transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
        transform = transform.concatenating(CGAffineTransform(translationX: translateX, y: translateY))

        return transform
    }

    private static func createTitleScreen(title: String, subtitle: String, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let titleImage = renderer.image { context in
            // Black background (for the image itself, though it will be overlaid)
            UIColor.clear.setFill() // Use clear background for overlay
            context.fill(CGRect(origin: .zero, size: size))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

                        // Title text (larger)
                        let titleAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.boldSystemFont(ofSize: min(size.width, size.height) * 0.08),
                            .foregroundColor: UIColor.white,
                            .paragraphStyle: paragraphStyle
                        ]
            
                        // Calculate title height based on content
                        let estimatedTitleHeight = title.boundingRect(with: CGSize(width: size.width - 80, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: titleAttributes, context: nil).height
                        let titleHeight = max(100, estimatedTitleHeight + 40) // Increased base height and padding
            
                        let titleYPosition: CGFloat
                        if subtitle.isEmpty {
                            titleYPosition = (size.height - titleHeight) / 2
                        } else {
                            // If subtitle exists, position title higher to make room for subtitle
                            titleYPosition = (size.height / 2) - (titleHeight / 2) - 60 // Shifted further up
                        }
                        let titleRect = CGRect(x: 40, y: titleYPosition, width: size.width - 80, height: titleHeight)
                        title.draw(in: titleRect, withAttributes: titleAttributes)
            
                        // Subtitle text (smaller, optional)
                        if !subtitle.isEmpty {
                            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                                .font: UIFont.systemFont(ofSize: min(size.width, size.height) * 0.04, weight: .regular),
                                .foregroundColor: UIColor.white.withAlphaComponent(0.8),
                                .paragraphStyle: paragraphStyle
                            ]
            
                            // Calculate subtitle height based on content
                            let estimatedSubtitleHeight = subtitle.boundingRect(with: CGSize(width: size.width - 80, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: subtitleAttributes, context: nil).height
                            let subtitleHeight = max(80, estimatedSubtitleHeight + 40) // Increased base height and padding
            
                            let subtitleRect = CGRect(x: 40, y: titleRect.maxY + 20, width: size.width - 80, height: subtitleHeight) // Position below title with more padding
                            subtitle.draw(in: subtitleRect, withAttributes: subtitleAttributes)
                        }
                    }
                    return titleImage
    }

    private static func bgraPixelBuffer(from image: UIImage, size: CGSize) -> CVPixelBuffer? {
        let attrs: CFDictionary = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(size.width),
            Int(size.height),
            kCVPixelFormatType_32BGRA,
            attrs,
            &pixelBuffer
        )
        guard status == kCVReturnSuccess, let buffer = pixelBuffer, let cgImage = image.cgImage else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        // BGRA byte order with premultipliedFirst alpha = the native iOS bitmap context layout
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue
            | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo.rawValue
        ) else { return nil }

        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        return buffer
    }

    private static func pixelBufferFromImage(image: UIImage, size: CGSize) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(size.width),
            Int(size.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )

        context?.draw(image.cgImage!, in: CGRect(origin: .zero, size: size))
        CVPixelBufferUnlockBaseAddress(buffer, [])

        return buffer
    }

    private static func addBackgroundMusic(
        to videoURL: URL,
        musicAsset: AVURLAsset,
        volume: Float
    ) async throws -> URL {
        let videoAsset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()

        guard let videoTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .video }),
              let compositionVideoTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid
              ) else {
            throw VideoCompositionError.trackCreationFailed
        }

        let videoDuration = try await videoAsset.load(.duration)

        try compositionVideoTrack.insertTimeRange(
            CMTimeRange(start: .zero, duration: videoDuration),
            of: videoTrack,
            at: .zero
        )

        // Add original audio if exists
        if let originalAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }),
           let compositionAudioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid
           ) {
            try compositionAudioTrack.insertTimeRange(
                CMTimeRange(start: .zero, duration: videoDuration),
                of: originalAudioTrack,
                at: .zero
            )
        }

        // Add music track with looping
        guard let musicTrack = try await musicAsset.load(.tracks).first(where: { $0.mediaType == .audio }),
              let compositionMusicTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
              ) else {
            throw VideoCompositionError.trackCreationFailed
        }

        let musicDuration = try await musicAsset.load(.duration)
        var currentTime = CMTime.zero

        while currentTime < videoDuration {
            let remainingTime = CMTimeSubtract(videoDuration, currentTime)
            let insertDuration = CMTimeMinimum(remainingTime, musicDuration)

            try compositionMusicTrack.insertTimeRange(
                CMTimeRange(start: .zero, duration: insertDuration),
                of: musicTrack,
                at: currentTime
            )

            currentTime = CMTimeAdd(currentTime, insertDuration)
        }

        let audioMix = AVMutableAudioMix()
        let musicMixParam = AVMutableAudioMixInputParameters(track: compositionMusicTrack)
        musicMixParam.setVolume(volume, at: .zero)
        audioMix.inputParameters = [musicMixParam]

        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mp4")

        try? FileManager.default.removeItem(at: outputURL)

        guard let exportSession = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality
        ) else {
            throw VideoCompositionError.exportFailed
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.audioMix = audioMix

        await exportSession.export()

        if exportSession.status == .failed {
            throw exportSession.error ?? VideoCompositionError.exportFailed
        }

        try? FileManager.default.removeItem(at: videoURL)
        return outputURL
    }

    static func saveToPhotoLibrary(videoURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized else {
                completion(.failure(VideoCompositionError.exportFailed))
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { success, error in
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(error ?? VideoCompositionError.exportFailed))
                }
            }
        }
    }

    private static func createBlackVideoSegment(duration: CMTime, size: CGSize) async throws -> URL {
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + "_black_segment")
            .appendingPathExtension("mp4")

        try? FileManager.default.removeItem(at: outputURL)

        let assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)

        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height
        ]

        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput.expectsMediaDataInRealTime = false

        let pixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: size.width,
            kCVPixelBufferHeightKey as String: size.height
        ]

        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: videoInput,
            sourcePixelBufferAttributes: pixelBufferAttributes
        )

        assetWriter.add(videoInput)
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: .zero)

        let frameDuration = CMTime(value: 1, timescale: 30)
        let totalFrames = Int64(duration.seconds * 30)

        // Create a solid black pixel buffer
        let blackImage = UIGraphicsImageRenderer(size: size).image { context in
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }

        guard let pixelBuffer = pixelBufferFromImage(image: blackImage, size: size) else {
            throw VideoCompositionError.imageLoadFailed
        }

        var frameCount: Int64 = 0
        while frameCount < totalFrames && videoInput.isReadyForMoreMediaData {
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameCount))
            pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
            frameCount += 1
        }

        videoInput.markAsFinished()
        await assetWriter.finishWriting()

        return outputURL
    }
}

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
            let composition = AVMutableComposition()

            guard let videoTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid
            ),
            let audioTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
            ) else {
                throw VideoCompositionError.trackCreationFailed
            }

            var instructions: [AVMutableVideoCompositionInstruction] = []
            let transitionDuration = CMTime(seconds: 0.2, preferredTimescale: 30)

            // Add black background layer to prevent green flash
            let backgroundLayer = CALayer()
            backgroundLayer.frame = CGRect(origin: .zero, size: settings.orientation.size)
            backgroundLayer.backgroundColor = UIColor.black.cgColor

            let videoLayer = CALayer()
            videoLayer.frame = CGRect(origin: .zero, size: settings.orientation.size)
            
            // Add blur filter for transitions
            let blurFilter = CIFilter(name: "CIGaussianBlur")!
            blurFilter.name = "blur"
            blurFilter.setValue(0, forKey: kCIInputRadiusKey)
            videoLayer.filters = [blurFilter]

            let parentLayer = CALayer()
            parentLayer.frame = CGRect(origin: .zero, size: settings.orientation.size)
            parentLayer.addSublayer(backgroundLayer)
            parentLayer.addSublayer(videoLayer)

            if settings.includeTitleScreen && !settings.titleText.isEmpty {
                if let titleImage = createTitleScreen(title: settings.titleText, subtitle: settings.subtitleText, size: settings.orientation.size) {
                    let titleLayer = CALayer()
                    titleLayer.contents = titleImage.cgImage
                    titleLayer.frame = CGRect(origin: .zero, size: settings.orientation.size)
                    titleLayer.opacity = 1.0 // Start visible
                    titleLayer.isGeometryFlipped = true // Correct orientation for UIImage

                    let titleOverlayDuration = CMTime(seconds: 3, preferredTimescale: 30)

                    // Fade Out
                    let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
                    fadeOutAnimation.fromValue = 1.0
                    fadeOutAnimation.toValue = 0.0
                    fadeOutAnimation.duration = transitionDuration.seconds
                    fadeOutAnimation.beginTime = AVCoreAnimationBeginTimeAtZero + titleOverlayDuration.seconds - transitionDuration.seconds
                    fadeOutAnimation.isRemovedOnCompletion = false
                    fadeOutAnimation.fillMode = .forwards
                    titleLayer.add(fadeOutAnimation, forKey: "titleFadeOut")

                    parentLayer.addSublayer(titleLayer)
                }
            }

            await MainActor.run { progressHandler(0.1) }

            var insertionPoint = CMTime.zero
            var videoInstructions: [AVMutableVideoCompositionInstruction] = []

            // Process each video
            for (index, item) in media.enumerated() {
                let clipStartTime = insertionPoint // Mark the start of this clip in the composition

                let progress = 0.1 + (Double(index) / Double(media.count)) * 0.7
                await MainActor.run { progressHandler(progress) }

                let videoAsset = try await loadVideoAsset(for: item.asset)

                guard let sourceVideoTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .video }) else {
                    continue
                }

                let originalVideoDuration = try await videoAsset.load(.duration)

                // Calculate the actual time range to insert based on trimming
                let actualStartTime = item.startTime
                let actualEndTime = item.endTime ?? originalVideoDuration
                
                let currentClipDuration = CMTimeSubtract(actualEndTime, actualStartTime) // Changed to let

                var effectiveClipDurationInComposition = CMTime.zero // This will be the duration of the clip in the composition, including slow-mo

                // Handle slow-mo if present
                if let slowMoStartTime = item.slowMoStartTime, let slowMoEndTime = item.slowMoEndTime {
                    let preSlowMoDuration = CMTimeSubtract(slowMoStartTime, actualStartTime)
                    let slowMoDuration = CMTimeSubtract(slowMoEndTime, slowMoStartTime)
                    let postSlowMoDuration = CMTimeSubtract(actualEndTime, slowMoEndTime)
                    let scaledSlowMoDuration = CMTimeMultiplyByFloat64(slowMoDuration, multiplier: 2.0) // Half speed

                    var tempClipDuration = CMTime.zero // Track duration of this specific slow-mo processed clip

                    // Insert pre-slow-mo part
                    if preSlowMoDuration > .zero {
                        try videoTrack.insertTimeRange(CMTimeRange(start: actualStartTime, duration: preSlowMoDuration), of: sourceVideoTrack, at: insertionPoint)
                        if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                            try? audioTrack.insertTimeRange(CMTimeRange(start: actualStartTime, duration: preSlowMoDuration), of: sourceAudioTrack, at: insertionPoint)
                        }
                        insertionPoint = CMTimeAdd(insertionPoint, preSlowMoDuration)
                        tempClipDuration = CMTimeAdd(tempClipDuration, preSlowMoDuration)
                    }

                    // Insert and scale slow-mo part
                    try videoTrack.insertTimeRange(CMTimeRange(start: slowMoStartTime, duration: slowMoDuration), of: sourceVideoTrack, at: insertionPoint)
                    if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                        try? audioTrack.insertTimeRange(CMTimeRange(start: slowMoStartTime, duration: slowMoDuration), of: sourceAudioTrack, at: insertionPoint)
                        audioTrack.scaleTimeRange(CMTimeRange(start: insertionPoint, duration: slowMoDuration), toDuration: scaledSlowMoDuration)
                    }
                    insertionPoint = CMTimeAdd(insertionPoint, scaledSlowMoDuration)
                    tempClipDuration = CMTimeAdd(tempClipDuration, scaledSlowMoDuration)

                    // Insert post-slow-mo part
                    if postSlowMoDuration > .zero {
                        try videoTrack.insertTimeRange(CMTimeRange(start: slowMoEndTime, duration: postSlowMoDuration), of: sourceVideoTrack, at: insertionPoint)
                        if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                            try? audioTrack.insertTimeRange(CMTimeRange(start: slowMoEndTime, duration: postSlowMoDuration), of: sourceAudioTrack, at: insertionPoint)
                        }
                        insertionPoint = CMTimeAdd(insertionPoint, postSlowMoDuration)
                        tempClipDuration = CMTimeAdd(tempClipDuration, postSlowMoDuration)
                    }
                    effectiveClipDurationInComposition = tempClipDuration // Correct calculation
                } else {
                    // Handle video without slow-mo (original trimming logic)
                    try videoTrack.insertTimeRange(CMTimeRange(start: actualStartTime, duration: currentClipDuration), of: sourceVideoTrack, at: insertionPoint)
                    if !item.isMuted, let sourceAudioTrack = try await videoAsset.load(.tracks).first(where: { $0.mediaType == .audio }) {
                        try? audioTrack.insertTimeRange(CMTimeRange(start: actualStartTime, duration: currentClipDuration), of: sourceAudioTrack, at: insertionPoint)
                    }
                    insertionPoint = CMTimeAdd(insertionPoint, currentClipDuration)
                    effectiveClipDurationInComposition = currentClipDuration // Correct calculation
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
                    to: settings.orientation.size,
                    preferredTransform: preferredTransform
                )

                // Set transform for this time range
                layerInstruction.setTransform(transform, at: clipStartTime) // Set transform for the entire clip

                instruction.layerInstructions = [layerInstruction]
                videoInstructions.append(instruction)

                // Implement Fade to Black using a dedicated black CALayer
                if settings.transition == .fade && index < media.count - 1 {
                    let blackTransitionLayer = CALayer()
                    blackTransitionLayer.frame = CGRect(origin: .zero, size: settings.orientation.size)
                    blackTransitionLayer.backgroundColor = UIColor.black.cgColor
                    blackTransitionLayer.opacity = 0.0 // Start transparent

                    // Fade in to black
                    let fadeInBlack = CABasicAnimation(keyPath: "opacity")
                    fadeInBlack.fromValue = 0.0
                    fadeInBlack.toValue = 1.0
                    fadeInBlack.duration = transitionDuration.seconds
                    fadeInBlack.beginTime = AVCoreAnimationBeginTimeAtZero + clipStartTime.seconds + effectiveClipDurationInComposition.seconds - transitionDuration.seconds
                    fadeInBlack.isRemovedOnCompletion = false
                    fadeInBlack.fillMode = .forwards
                    blackTransitionLayer.add(fadeInBlack, forKey: "fadeInBlack-\(clipStartTime.seconds)")

                    // Fade out from black
                    let fadeOutBlack = CABasicAnimation(keyPath: "opacity")
                    fadeOutBlack.fromValue = 1.0
                    fadeOutBlack.toValue = 0.0
                    fadeOutBlack.duration = transitionDuration.seconds
                    fadeOutBlack.beginTime = AVCoreAnimationBeginTimeAtZero + clipStartTime.seconds + effectiveClipDurationInComposition.seconds
                    fadeOutBlack.isRemovedOnCompletion = false
                    fadeOutBlack.fillMode = .forwards
                    blackTransitionLayer.add(fadeOutBlack, forKey: "fadeOutBlack-\(clipStartTime.seconds)")

                    parentLayer.addSublayer(blackTransitionLayer)
                }


            }
            instructions = videoInstructions // Assign to global instructions

            await MainActor.run { progressHandler(0.8) }

            // Create video composition with black background
            let videoComposition = AVMutableVideoComposition()
            videoComposition.instructions = instructions
            videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
            videoComposition.renderSize = settings.orientation.size

            videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
                postProcessingAsVideoLayer: videoLayer,
                in: parentLayer
            )

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

            // Add background music if provided
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

            await MainActor.run {
                completion(.success(finalURL))
            }
        } catch {
            await MainActor.run {
                completion(.failure(error))
            }
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

    private static func calculateTransform(
        from sourceSize: CGSize,
        to targetSize: CGSize,
        preferredTransform: CGAffineTransform
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

        // Calculate scale to fit the video in the target size (aspect fit - letterboxing)
        let scaleWidth = targetSize.width / actualWidth
        let scaleHeight = targetSize.height / actualHeight
        let scale = min(scaleWidth, scaleHeight)

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

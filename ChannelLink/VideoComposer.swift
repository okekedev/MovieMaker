import AVFoundation
import Photos
import UIKit
import CoreMedia

class VideoComposer {
    static func createSlideshow(
        media: [MediaItem],
        settings: SlideshowSettings,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        // Request background task to allow completion even if app is backgrounded
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            // If we run out of time, end the task
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }

        DispatchQueue.global(qos: .userInitiated).async {
            defer {
                // Always end background task when done
                if backgroundTaskID != .invalid {
                    UIApplication.shared.endBackgroundTask(backgroundTaskID)
                }
            }

            do {
                // Create output URL
                let outputURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension("mp4")

                // Delete if exists
                try? FileManager.default.removeItem(at: outputURL)

                // Use composition for videos
                let composition = AVMutableComposition()
                let videoComposition = AVMutableVideoComposition()

                guard let videoTrack = composition.addMutableTrack(
                    withMediaType: .video,
                    preferredTrackID: kCMPersistentTrackID_Invalid
                ) else {
                    throw VideoCompositionError.trackCreationFailed
                }

                guard let audioTrack = composition.addMutableTrack(
                    withMediaType: .audio,
                    preferredTrackID: kCMPersistentTrackID_Invalid
                ) else {
                    throw VideoCompositionError.trackCreationFailed
                }

                var currentTime = CMTime.zero
                let targetSize = settings.orientation.size

                let videoSettings: [String: Any] = [
                    AVVideoCodecKey: AVVideoCodecType.h264,
                    AVVideoWidthKey: targetSize.width,
                    AVVideoHeightKey: targetSize.height
                ]

                let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
                videoInput.expectsMediaDataInRealTime = false

                let pixelBufferAttributes: [String: Any] = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                    kCVPixelBufferWidthKey as String: targetSize.width,
                    kCVPixelBufferHeightKey as String: targetSize.height
                ]

                let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                    assetWriterInput: videoInput,
                    sourcePixelBufferAttributes: pixelBufferAttributes
                )

                guard assetWriter.canAdd(videoInput) else {
                    throw VideoCompositionError.trackCreationFailed
                }
                assetWriter.add(videoInput)

                // Start writing
                guard assetWriter.startWriting() else {
                    throw VideoCompositionError.exportFailed
                }
                assetWriter.startSession(atSourceTime: .zero)

                var currentTime = CMTime.zero
                let frameDuration = CMTime(value: 1, timescale: 30)

                // Add intro if present
                if !settings.introText.isEmpty {
                    let introImage = createIntroImage(
                        title: settings.introText,
                        size: targetSize
                    )
                    let introDuration = CMTime(seconds: 4, preferredTimescale: 30)

                    try writeImageToVideo(
                        image: introImage,
                        duration: introDuration,
                        startTime: currentTime,
                        pixelBufferAdaptor: pixelBufferAdaptor,
                        videoInput: videoInput,
                        frameDuration: frameDuration,
                        targetSize: targetSize
                    )

                    currentTime = CMTimeAdd(currentTime, introDuration)
                }

                progressHandler(0.2)

                // Process each photo
                for (index, mediaItem) in media.enumerated() {
                    let asset = PHAsset.fetchAssets(withLocalIdentifiers: [mediaItem.asset.localIdentifier], options: nil).firstObject

                    guard let asset = asset else { continue }

                    // Load and process image
                    let image = try loadImage(from: asset, targetSize: targetSize)
                    let photoDuration = CMTime(seconds: settings.photoDuration, preferredTimescale: 30)

                    try writeImageToVideo(
                        image: image,
                        duration: photoDuration,
                        startTime: currentTime,
                        pixelBufferAdaptor: pixelBufferAdaptor,
                        videoInput: videoInput,
                        frameDuration: frameDuration,
                        targetSize: targetSize
                    )

                    currentTime = CMTimeAdd(currentTime, photoDuration)

                    progressHandler(0.2 + (0.6 * Double(index + 1) / Double(media.count)))
                }

                // Finish writing video
                videoInput.markAsFinished()

                progressHandler(0.9)

                let semaphore = DispatchSemaphore(value: 0)
                var finishError: Error?

                assetWriter.finishWriting {
                    if assetWriter.status == .failed {
                        finishError = assetWriter.error ?? VideoCompositionError.exportFailed
                    }
                    semaphore.signal()
                }

                semaphore.wait()

                if let error = finishError {
                    throw error
                }

                progressHandler(0.9)

                // Add background music if provided
                let finalURL: URL
                if let musicAsset = settings.musicAsset {
                    finalURL = try Self.addBackgroundMusic(
                        to: outputURL,
                        musicAsset: musicAsset,
                        volume: settings.musicVolume
                    )
                } else {
                    finalURL = outputURL
                }

                progressHandler(1.0)

                DispatchQueue.main.async {
                    completion(.success(finalURL))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private static func writeImageToVideo(
        image: UIImage,
        duration: CMTime,
        startTime: CMTime,
        pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor,
        videoInput: AVAssetWriterInput,
        frameDuration: CMTime,
        targetSize: CGSize
    ) throws {
        let resizedImage = resizeImage(image, targetSize: targetSize)!

        // Create pixel buffer ONCE and reuse it for all frames
        guard let pixelBuffer = pixelBufferFromImage(image: resizedImage) else {
            throw VideoCompositionError.imageLoadFailed
        }

        var frameCount: Int64 = 0
        let totalFrames = Int64(duration.seconds * 30)

        while frameCount < totalFrames {
            while !videoInput.isReadyForMoreMediaData {
                Thread.sleep(forTimeInterval: 0.01)
            }

            let frameTime = CMTimeAdd(startTime, CMTimeMultiply(frameDuration, multiplier: Int32(frameCount)))

            // Reuse the same pixel buffer for every frame
            if !pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: frameTime) {
                throw VideoCompositionError.exportFailed
            }

            frameCount += 1
        }
    }

    private static func pixelBufferFromImage(image: UIImage) -> CVPixelBuffer? {
        let width = Int(image.size.width)
        let height = Int(image.size.height)

        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        let pixelData = CVPixelBufferGetBaseAddress(buffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            return nil
        }

        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context)
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()

        return buffer
    }

    private static func createIntroImage(title: String, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // Black background
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            // Calculate card size and position
            let cardWidth = size.width * 0.7
            let cardHeight: CGFloat = 150
            let cardX = (size.width - cardWidth) / 2
            let cardY = (size.height - cardHeight) / 2

            let cardRect = CGRect(x: cardX, y: cardY, width: cardWidth, height: cardHeight)

            // White card with rounded corners and shadow
            let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 20)

            // Shadow
            context.cgContext.setShadow(offset: CGSize(width: 0, height: 4), blur: 20, color: UIColor.black.withAlphaComponent(0.3).cgColor)
            UIColor.white.setFill()
            cardPath.fill()

            // Reset shadow
            context.cgContext.setShadow(offset: .zero, blur: 0, color: nil)

            // Title text
            if !title.isEmpty {
                let titleParagraphStyle = NSMutableParagraphStyle()
                titleParagraphStyle.alignment = .center
                titleParagraphStyle.lineBreakMode = .byWordWrapping

                let titleFontSize: CGFloat = size.width > size.height ? 56 : 48
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: titleFontSize, weight: .bold),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: titleParagraphStyle
                ]

                let titleY = cardY + (cardHeight - 60) / 2
                let titleRect = CGRect(
                    x: cardX + 30,
                    y: titleY,
                    width: cardWidth - 60,
                    height: 80
                )

                title.draw(in: titleRect, withAttributes: titleAttributes)
            }
        }
    }

    private static func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { context in
            // Fill with black background
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: targetSize))

            // Fit: Show entire photo with black bars if needed
            let imageAspect = image.size.width / image.size.height
            let targetAspect = targetSize.width / targetSize.height

            let drawRect: CGRect
            if imageAspect > targetAspect {
                // Image is wider
                let width = targetSize.width
                let height = width / imageAspect
                drawRect = CGRect(
                    x: 0,
                    y: (targetSize.height - height) / 2,
                    width: width,
                    height: height
                )
            } else {
                // Image is taller
                let height = targetSize.height
                let width = height * imageAspect
                drawRect = CGRect(
                    x: (targetSize.width - width) / 2,
                    y: 0,
                    width: width,
                    height: height
                )
            }

            image.draw(in: drawRect)
        }
    }

    private static func loadImage(from asset: PHAsset, targetSize: CGSize = CGSize(width: 1920, height: 1080)) throws -> UIImage {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true

        var resultImage: UIImage?
        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: requestOptions
        ) { image, _ in
            resultImage = image
        }

        guard let image = resultImage else {
            throw VideoCompositionError.imageLoadFailed
        }

        return image
    }

    static func saveToPhotoLibrary(videoURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async {
                    completion(.failure(VideoCompositionError.permissionDenied))
                }
                return
            }

            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.failure(error ?? VideoCompositionError.saveFailed))
                    }
                }
            }
        }
    }

    // MARK: - Background Music
    private static func addBackgroundMusic(
        to videoURL: URL,
        musicAsset: AVURLAsset,
        volume: Float
    ) throws -> URL {
        let videoAsset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()

        // Add video track
        guard let videoTrack = videoAsset.tracks(withMediaType: .video).first,
              let compositionVideoTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid
              ) else {
            throw VideoCompositionError.trackCreationFailed
        }

        try compositionVideoTrack.insertTimeRange(
            CMTimeRange(start: .zero, duration: videoAsset.duration),
            of: videoTrack,
            at: .zero
        )

        // Add audio track with looping
        guard let audioTrack = musicAsset.tracks(withMediaType: .audio).first,
              let compositionAudioTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
              ) else {
            throw VideoCompositionError.trackCreationFailed
        }

        let videoDuration = videoAsset.duration
        let audioDuration = musicAsset.duration
        var currentTime = CMTime.zero

        // Loop audio to match video duration
        while currentTime < videoDuration {
            let remainingTime = CMTimeSubtract(videoDuration, currentTime)
            let insertDuration = CMTimeMinimum(remainingTime, audioDuration)

            try compositionAudioTrack.insertTimeRange(
                CMTimeRange(start: .zero, duration: insertDuration),
                of: audioTrack,
                at: currentTime
            )

            currentTime = CMTimeAdd(currentTime, insertDuration)
        }

        // Apply volume
        let audioMix = AVMutableAudioMix()
        let audioMixParam = AVMutableAudioMixInputParameters(track: compositionAudioTrack)
        audioMixParam.setVolume(volume, at: .zero)
        audioMix.inputParameters = [audioMixParam]

        // Export with audio
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

        let semaphore = DispatchSemaphore(value: 0)
        var exportError: Error?

        exportSession.exportAsynchronously {
            if exportSession.status == .failed {
                exportError = exportSession.error ?? VideoCompositionError.exportFailed
            }
            semaphore.signal()
        }

        semaphore.wait()

        if let error = exportError {
            throw error
        }

        // Delete original video without music
        try? FileManager.default.removeItem(at: videoURL)

        return outputURL
    }
}

enum VideoCompositionError: LocalizedError {
    case trackCreationFailed
    case imageLoadFailed
    case videoLoadFailed
    case exportFailed
    case saveFailed
    case permissionDenied
    case cancelled
    case unknown

    var errorDescription: String? {
        switch self {
        case .trackCreationFailed:
            return "Failed to create video track"
        case .imageLoadFailed:
            return "Failed to load image"
        case .videoLoadFailed:
            return "Failed to load video"
        case .exportFailed:
            return "Failed to export video"
        case .saveFailed:
            return "Failed to save video to Photos"
        case .permissionDenied:
            return "Permission denied to access Photos"
        case .cancelled:
            return "Video creation was cancelled"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

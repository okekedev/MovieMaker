import AVFoundation
import Photos
import UIKit

enum VideoCompositionError: Error {
    case trackCreationFailed
    case exportFailed
    case videoLoadFailed
    case imageLoadFailed
}

class VideoCompiler {
    static func compileVideos(
        media: [MediaItem],
        settings: VideoCompilationSettings,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }

        DispatchQueue.global(qos: .userInitiated).async {
            defer {
                if backgroundTaskID != .invalid {
                    UIApplication.shared.endBackgroundTask(backgroundTaskID)
                }
            }

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

                var currentTime = CMTime.zero
                var instructions: [AVMutableVideoCompositionInstruction] = []

                progressHandler(0.1)

                // Process each video
                for (index, item) in media.enumerated() {
                    let progress = 0.1 + (Double(index) / Double(media.count)) * 0.7
                    progressHandler(progress)

                    let videoAsset = try loadVideoAsset(for: item.asset)

                    guard let sourceVideoTrack = videoAsset.tracks(withMediaType: .video).first else {
                        continue
                    }

                    let videoDuration = videoAsset.duration

                    // Insert video
                    try videoTrack.insertTimeRange(
                        CMTimeRange(start: .zero, duration: videoDuration),
                        of: sourceVideoTrack,
                        at: currentTime
                    )

                    // Insert audio if available
                    if let sourceAudioTrack = videoAsset.tracks(withMediaType: .audio).first {
                        try? audioTrack.insertTimeRange(
                            CMTimeRange(start: .zero, duration: videoDuration),
                            of: sourceAudioTrack,
                            at: currentTime
                        )
                    }

                    // Create instruction for proper sizing
                    let instruction = AVMutableVideoCompositionInstruction()
                    instruction.timeRange = CMTimeRange(start: currentTime, duration: videoDuration)

                    let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)

                    // Calculate transform to fit target size
                    let transform = calculateTransform(
                        from: sourceVideoTrack.naturalSize,
                        to: settings.orientation.size,
                        preferredTransform: sourceVideoTrack.preferredTransform
                    )

                    // Set transform for this time range
                    layerInstruction.setTransformRamp(fromStart: transform, toEnd: transform, timeRange: CMTimeRange(start: currentTime, duration: videoDuration))

                    instruction.layerInstructions = [layerInstruction]
                    instructions.append(instruction)

                    currentTime = CMTimeAdd(currentTime, videoDuration)
                }

                progressHandler(0.8)

                // Create video composition
                let videoComposition = AVMutableVideoComposition()
                videoComposition.instructions = instructions
                videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
                videoComposition.renderSize = settings.orientation.size

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

                progressHandler(0.9)

                // Add background music if provided
                let finalURL: URL
                if let musicAsset = settings.musicAsset {
                    finalURL = try addBackgroundMusic(
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

    private static func loadVideoAsset(for asset: PHAsset) throws -> AVAsset {
        let semaphore = DispatchSemaphore(value: 0)
        var resultAsset: AVAsset?
        var resultError: Error?

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat

        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
            if let error = info?[PHImageErrorKey] as? Error {
                resultError = error
            } else {
                resultAsset = avAsset
            }
            semaphore.signal()
        }

        semaphore.wait()

        if let error = resultError {
            throw error
        }

        guard let asset = resultAsset else {
            throw VideoCompositionError.videoLoadFailed
        }

        return asset
    }

    private static func calculateTransform(
        from sourceSize: CGSize,
        to targetSize: CGSize,
        preferredTransform: CGAffineTransform
    ) -> CGAffineTransform {
        // Get the actual dimensions after applying the preferred transform
        let transformedSize = sourceSize.applying(preferredTransform)
        let actualWidth = abs(transformedSize.width)
        let actualHeight = abs(transformedSize.height)

        // Calculate scale to fit the video in the target size (aspect fit)
        let scaleWidth = targetSize.width / actualWidth
        let scaleHeight = targetSize.height / actualHeight
        let scale = min(scaleWidth, scaleHeight)

        // Calculate translation to center the video
        let scaledWidth = actualWidth * scale
        let scaledHeight = actualHeight * scale
        let translateX = (targetSize.width - scaledWidth) / 2.0
        let translateY = (targetSize.height - scaledHeight) / 2.0

        // Build the transform: start with preferred transform (handles rotation),
        // then scale, then translate to center
        var transform = preferredTransform
        transform = transform.scaledBy(x: scale, y: scale)
        transform = transform.translatedBy(x: translateX / scale, y: translateY / scale)

        return transform
    }

    private static func createIntroVideo(title: String, size: CGSize) throws -> URL {
        // Create a simple intro video with text
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + "_intro")
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
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
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

        let introDuration = CMTime(seconds: 4, preferredTimescale: 30)
        let frameDuration = CMTime(value: 1, timescale: 30)
        let totalFrames = Int64(introDuration.seconds * 30)

        // Create intro image
        let renderer = UIGraphicsImageRenderer(size: size)
        let introImage = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: min(size.width, size.height) * 0.08),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]

            let textRect = CGRect(x: 0, y: (size.height - 100) / 2, width: size.width, height: 100)
            title.draw(in: textRect, withAttributes: attributes)
        }

        guard let pixelBuffer = pixelBufferFromImage(image: introImage, size: size) else {
            throw VideoCompositionError.imageLoadFailed
        }

        var frameCount: Int64 = 0
        while frameCount < totalFrames && videoInput.isReadyForMoreMediaData {
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameCount))
            pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
            frameCount += 1
        }

        videoInput.markAsFinished()
        let semaphore = DispatchSemaphore(value: 0)

        assetWriter.finishWriting {
            semaphore.signal()
        }

        semaphore.wait()

        return outputURL
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
    ) throws -> URL {
        let videoAsset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition()

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

        // Add original audio if exists
        if let originalAudioTrack = videoAsset.tracks(withMediaType: .audio).first,
           let compositionAudioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid
           ) {
            try compositionAudioTrack.insertTimeRange(
                CMTimeRange(start: .zero, duration: videoAsset.duration),
                of: originalAudioTrack,
                at: .zero
            )
        }

        // Add music track with looping
        guard let musicTrack = musicAsset.tracks(withMediaType: .audio).first,
              let compositionMusicTrack = composition.addMutableTrack(
                withMediaType: .audio,
                preferredTrackID: kCMPersistentTrackID_Invalid
              ) else {
            throw VideoCompositionError.trackCreationFailed
        }

        let videoDuration = videoAsset.duration
        let musicDuration = musicAsset.duration
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
}

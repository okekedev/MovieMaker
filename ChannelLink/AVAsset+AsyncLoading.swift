import AVFoundation

// MARK: - Async helpers for iOS 16+ compatibility
extension AVAsset {
    func loadDuration() async throws -> CMTime {
        if #available(iOS 16.0, *) {
            return try await load(.duration)
        } else {
            return duration
        }
    }

    func loadTracksAsync(withMediaType mediaType: AVMediaType) async throws -> [AVAssetTrack] {
        if #available(iOS 15.0, *) {
            return try await loadTracks(withMediaType: mediaType)
        } else {
            return tracks(withMediaType: mediaType)
        }
    }
}

extension AVAssetTrack {
    func loadNaturalSize() async throws -> CGSize {
        if #available(iOS 16.0, *) {
            return try await load(.naturalSize)
        } else {
            return naturalSize
        }
    }

    func loadPreferredTransform() async throws -> CGAffineTransform {
        if #available(iOS 16.0, *) {
            return try await load(.preferredTransform)
        } else {
            return preferredTransform
        }
    }
}

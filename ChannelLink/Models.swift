import Foundation
import Photos
import UIKit
import AVFoundation

struct VideoCompilationSettings {
    var loopDuration: LoopDuration = .noLoop
    var orientation: VideoOrientation = .landscape
    var musicAsset: AVURLAsset?
    var musicVolume: Float = 0.5
    var titleText: String = ""
    var subtitleText: String = ""
    var includeTitleScreen: Bool = false
    var transition: TransitionType = .fade
}

enum TransitionType: String, CaseIterable {
    case fade = "Fade to Black"
    case none = "None"
}

enum LoopDuration: String, CaseIterable {
    case noLoop = "No loop (play once)"
    case oneHour = "Loop for 1 hour"
    case twoHours = "Loop for 2 hours"

    var hours: Double {
        switch self {
        case .noLoop: return 0
        case .oneHour: return 1
        case .twoHours: return 2
        }
    }
}

enum VideoOrientation: String, CaseIterable {
    case landscape = "Landscape"
    case portrait = "Portrait"

    var size: CGSize {
        switch self {
        case .landscape: return CGSize(width: 1920, height: 1080)
        case .portrait: return CGSize(width: 1080, height: 1920)
        }
    }
}

struct MediaItem: Identifiable {
    let id = UUID()
    let asset: PHAsset
    var thumbnail: UIImage?
    var startTime: CMTime = .zero
    var endTime: CMTime?
    var slowMoStartTime: CMTime?
    var slowMoEndTime: CMTime?
    var isMuted: Bool = false
}

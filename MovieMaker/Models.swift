import Foundation
import Photos
import UIKit
import AVFoundation
import SwiftUI

struct VideoCompilationSettings {
    var loopDuration: LoopDuration = .noLoop
    var orientation: VideoOrientation = .landscape
    var musicAsset: AVURLAsset?
    var musicVolume: Float = 0.5
    var titleText: String = ""
    var subtitleText: String = ""
    var includeTitleScreen: Bool = true
    var transition: TransitionType = .fade
    var transitionColor: CodableColor = CodableColor(uiColor: .black)
}

enum TransitionType: String, CaseIterable {
    case fade = "Fade"
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

struct CodableColor: Codable, Equatable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat

    init(uiColor: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
            self.red = r
            self.green = g
            self.blue = b
            self.alpha = a
        } else {
            // Fallback to black if not an RGB color
            self.red = 0
            self.green = 0
            self.blue = 0
            self.alpha = 1
        }
    }

    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    var swiftuiColor: Color {
        get {
            return Color(uiColor: uiColor)
        }
        set {
            let uiColor = UIColor(newValue)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            if uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
                self.red = r
                self.green = g
                self.blue = b
                self.alpha = a
            } else {
                // Fallback to black if not an RGB color
                self.red = 0
                self.green = 0
                self.blue = 0
                self.alpha = 1
            }
        }
    }
}

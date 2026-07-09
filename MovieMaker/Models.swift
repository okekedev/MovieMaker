import Foundation
import Photos
import UIKit
import AVFoundation
import SwiftUI

// MARK: - Color Theme
extension Color {
    static let brandPrimary = Color(red: 0.2, green: 0.6, blue: 0.86)
    static let brandSecondary = Color(red: 0.2, green: 0.8, blue: 0.6)
    static let brandAccent = Color(red: 0.1, green: 0.7, blue: 0.75)
    static let brandGradient = [brandPrimary, brandAccent, brandSecondary]
    static let primaryGradient = [brandPrimary, brandAccent]
    static let secondaryGradient = [brandAccent, brandSecondary]
}

// MARK: - Device Metrics (iPad-adaptive sizing)
// The app was built iPhone-first with hardcoded point sizes, so on iPad they
// render tiny in a huge canvas. `DeviceMetrics` gives one multiplier so type,
// spacing, and controls scale up on iPad, plus a readable content-column width
// so full-bleed layouts don't stretch edge-to-edge. iPhone is unchanged
// (scale == 1, contentMaxWidth == .infinity).
// NOTE: lives here (not AppTheme.swift) because AppTheme.swift is not in the
// Xcode compile sources — Models.swift is the file that actually builds.
enum DeviceMetrics {
    static var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    /// Type + control multiplier. Tuned so a 44pt title reads ~62pt on iPad.
    static var scale: CGFloat { isPad ? 1.4 : 1.0 }
    /// Max width for stacked content columns (settings rows, buttons, cards).
    static var contentMaxWidth: CGFloat { isPad ? 620 : .infinity }
    /// Wider cap for paywall/spin card columns.
    static var wideContentMaxWidth: CGFloat { isPad ? 720 : .infinity }
}

extension BinaryInteger {
    /// Scale a hardcoded iPhone point value up for iPad. No-op on iPhone.
    /// Works on integer literals: `34.scaled`.
    var scaled: CGFloat { CGFloat(self) * DeviceMetrics.scale }
}

extension BinaryFloatingPoint {
    /// Scale a hardcoded iPhone point value up for iPad. No-op on iPhone.
    /// Works on CGFloat/Double literals: `15.5.scaled`.
    var scaled: CGFloat { CGFloat(self) * DeviceMetrics.scale }
}

extension View {
    /// Center a content column and cap its width on iPad; full-bleed on iPhone.
    func iPadReadableWidth(wide: Bool = false) -> some View {
        self
            .frame(maxWidth: wide ? DeviceMetrics.wideContentMaxWidth : DeviceMetrics.contentMaxWidth)
            .frame(maxWidth: .infinity)
    }
}

struct VideoCompilationSettings {
    var orientation: VideoOrientation = .landscape
    var musicAsset: AVURLAsset?
    var musicVolume: Float = 0.5
    var titleText: String = ""
    var subtitleText: String = ""
    var includeTitleScreen: Bool = true
    var transition: TransitionType = .fade
    var transitionColor: CodableColor = CodableColor(uiColor: .black)
    var photoDuration: Double = 3.0
}

enum TransitionType: String, CaseIterable {
    case fade = "Fade"
    case none = "None"
}
enum VideoOrientation: String, CaseIterable {
    case landscape = "16:9"
    case square = "1:1"
    case portrait = "9:16"

    var size: CGSize {
        switch self {
        case .landscape: return CGSize(width: 1920, height: 1080)
        case .square:    return CGSize(width: 1080, height: 1080)
        case .portrait:  return CGSize(width: 1080, height: 1920)
        }
    }

    /// Platform hint shown under the picker so users know which ratio to pick.
    var platformHint: String {
        switch self {
        case .landscape: return "YouTube"
        case .square:    return "Instagram"
        case .portrait:  return "Reels & TikTok"
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

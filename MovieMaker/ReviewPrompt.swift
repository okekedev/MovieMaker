import Foundation
import StoreKit
import UIKit

/// In-app review prompt. Fires Apple's SKStoreReviewController the third
/// time the user successfully exports a video, once per app version.
/// Apple additionally caps to 3 prompts per 365 days per user, so the
/// per-version guard prevents pestering across quick releases.
enum ReviewPrompt {
    private static let exportCountKey = "moviemaker.successfulExportCount"
    private static let lastVersionKey = "moviemaker.lastReviewPromptVersion"
    private static let triggerAfterExports = 3

    /// Call once per successful export, from the .success branch of the
    /// saveToPhotoLibrary callback.
    static func recordExportAndMaybeAsk() {
        let defaults = UserDefaults.standard
        let newCount = defaults.integer(forKey: exportCountKey) + 1
        defaults.set(newCount, forKey: exportCountKey)

        guard newCount >= triggerAfterExports else { return }

        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        if defaults.string(forKey: lastVersionKey) == currentVersion, !currentVersion.isEmpty {
            return
        }

        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
            else { return }
            SKStoreReviewController.requestReview(in: scene)
            defaults.set(currentVersion, forKey: lastVersionKey)
        }
    }
}

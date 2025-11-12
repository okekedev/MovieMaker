import SwiftUI

extension Color {
    // Brand Colors - Blue-Green Gradient Theme
    static let brandPrimary = Color(red: 0.2, green: 0.6, blue: 0.86) // Vibrant Blue
    static let brandSecondary = Color(red: 0.2, green: 0.8, blue: 0.6) // Vibrant Green
    static let brandAccent = Color(red: 0.1, green: 0.7, blue: 0.75) // Teal

    // Gradient Arrays
    static let brandGradient = [brandPrimary, brandAccent, brandSecondary]
    static let primaryGradient = [brandPrimary, brandAccent]
    static let secondaryGradient = [brandAccent, brandSecondary]
}

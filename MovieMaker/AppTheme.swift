import SwiftUI

// MARK: - App Theme
// Centralized styling constants for consistent UI across the app

// MARK: - Colors
extension Color {
    // Brand Colors - Blue-Green Gradient Theme
    static let brandPrimary = Color(red: 0.2, green: 0.6, blue: 0.86) // Vibrant Blue
    static let brandSecondary = Color(red: 0.2, green: 0.8, blue: 0.6) // Vibrant Green
    static let brandAccent = Color(red: 0.1, green: 0.7, blue: 0.75) // Teal

    // Gradient Arrays (for backgrounds and special effects only)
    static let brandGradient = [brandPrimary, brandAccent, brandSecondary]
    static let primaryGradient = [brandPrimary, brandAccent]
    static let secondaryGradient = [brandAccent, brandSecondary]
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.black)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.systemGray))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct TertiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

// MARK: - Typography
extension Font {
    // Display & Titles (Large, prominent text)
    static let displayLarge = Font.system(size: 52, weight: .heavy, design: .rounded) // Hero text
    static let displayMedium = Font.system(size: 44, weight: .bold) // App title
    static let titleLarge = Font.system(size: 42, weight: .bold) // Screen titles
    static let titleMedium = Font.system(size: 34, weight: .bold) // Section titles
    static let titleSmall = Font.system(size: 28, weight: .semibold) // Subsection titles

    // Headings
    static let headlineLarge = Font.system(size: 22, weight: .bold)
    static let headline = Font.system(size: 17, weight: .semibold)
    static let headlineLight = Font.system(size: 17, weight: .medium)

    // Body Text
    static let bodyLarge = Font.system(size: 18, weight: .regular)
    static let body = Font.system(size: 17, weight: .regular)
    static let bodyMedium = Font.system(size: 17, weight: .medium)
    static let bodySemibold = Font.system(size: 17, weight: .semibold)
    static let bodySmall = Font.system(size: 15, weight: .regular)

    // Supporting Text
    static let caption = Font.system(size: 16, weight: .medium)
    static let captionSmall = Font.system(size: 14, weight: .regular)
    static let label = Font.system(size: 12, weight: .semibold)

    // Buttons
    static let buttonLarge = Font.system(size: 18, weight: .semibold)
    static let button = Font.system(size: 17, weight: .semibold)
    static let buttonSmall = Font.system(size: 15, weight: .semibold)
}

// MARK: - Spacing
enum Spacing {
    static let gridSpacing: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 40
}

// MARK: - Layout
enum Layout {
    static let cornerRadius: CGFloat = 12
    static let headerHeight: CGFloat = 60
    static let thumbnailSize: CGFloat = 110
}

// MARK: - Shadows
struct AppShadow {
    static let button = Shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
    static let card = Shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    static let light = Shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers
extension View {
    func primaryButtonStyle() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }

    func secondaryButtonStyle() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }

    func tertiaryButtonStyle() -> some View {
        self.buttonStyle(TertiaryButtonStyle())
    }

    func appShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

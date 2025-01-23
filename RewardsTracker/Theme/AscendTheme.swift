import SwiftUI

enum AscendTheme {
    enum Colors {
        // Static colors to avoid any initialization issues
        static let primary = Color(uiColor: UIColor(named: "AccentColor") ?? UIColor(red: 0.22, green: 0.29, blue: 0.34, alpha: 1.0))  // #374957
        static let background = Color(uiColor: .systemBackground)
        static let surface = Color.white
        static let text = Color.primary
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let divider = Color.gray.opacity(0.2)
        static let accent = Color(uiColor: UIColor(named: "AccentColor") ?? UIColor(red: 0.22, green: 0.29, blue: 0.34, alpha: 1.0))  // #374957
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
    }

    struct TabBar {
        static let height: CGFloat = 80
        static let iconSize: CGFloat = 24
        static let bottomPadding: CGFloat = 16
    }
}

// Custom Button Style
struct AscendButtonStyle: ButtonStyle {
    let isSecondary: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, AscendTheme.Spacing.md)
            .padding(.horizontal, AscendTheme.Spacing.xl)
            .frame(maxWidth: .infinity)
            .background(isSecondary ? AscendTheme.Colors.background : AscendTheme.Colors.primary)
            .foregroundColor(isSecondary ? AscendTheme.Colors.primary : .white)
            .cornerRadius(AscendTheme.CornerRadius.md)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Custom TextField Style
struct AscendTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(AscendTheme.Colors.surface)
            .cornerRadius(AscendTheme.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AscendTheme.CornerRadius.md)
                    .stroke(AscendTheme.Colors.divider, lineWidth: 1)
            )
    }
}

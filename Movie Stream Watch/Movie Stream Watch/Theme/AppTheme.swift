import SwiftUI

// MARK: - Colors
extension Color {
    static let appBackground = Color(hex: "0A0A0E")
    static let appPrimary = Color(hex: "FF3B30")
    static let appSecondary = Color(hex: "8E44FF")
    static let cardBackground = Color(hex: "1A1A2E")
    static let surfaceColor = Color(hex: "12121A")
    static let textGray = Color(hex: "B0B0B0")

    static let primaryGradient = LinearGradient(
        colors: [.appPrimary, .appSecondary],
        startPoint: .leading,
        endPoint: .trailing
    )

    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}

// MARK: - Fonts
extension Font {
    static let appTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let appSubtitle = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let appBody = Font.system(size: 15, weight: .regular, design: .default)
    static let appCaption = Font.system(size: 12, weight: .medium, design: .default)
}

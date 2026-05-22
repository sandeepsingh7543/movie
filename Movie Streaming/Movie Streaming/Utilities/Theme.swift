import SwiftUI

// MARK: - App Theme
extension Color {
    static let appBackground  = Color(hex: "#0D0D0D")
    static let appSurface     = Color(hex: "#1A1A1A")
    static let appAccent      = Color(hex: "#E50914")
    static let appSecondary   = Color(hex: "#B3B3B3")
    static let appGold        = Color(hex: "#F5C518")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Typography
extension Font {
    static let appTitle    = Font.system(size: 28, weight: .bold, design: .default)
    static let appHeadline = Font.system(size: 18, weight: .semibold)
    static let appBody     = Font.system(size: 14, weight: .regular)
    static let appCaption  = Font.system(size: 12, weight: .medium)
}

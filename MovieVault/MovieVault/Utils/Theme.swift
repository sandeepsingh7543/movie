import SwiftUI

struct Theme {
    static let background = Color(hex: "0A0A0F")
    static let surface = Color(hex: "12121A")
    static let card = Color(hex: "1A1A28")
    static let accent = Color(hex: "F5C518")
    static let accentGold = Color(hex: "F5C518")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "9999AA")
    static let glass = Color.white.opacity(0.06)
    static let glassBorder = Color.white.opacity(0.12)
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

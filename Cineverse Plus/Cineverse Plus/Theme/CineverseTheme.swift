import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}

enum CineverseTheme {
    static let deepBlack = Color(hex: "0B0B0F")
    static let neonPurple = Color(hex: "7B61FF")
    static let electricBlue = Color(hex: "00D4FF")
    static let lightGray = Color(white: 0.7)
    static let cardBackground = Color(white: 0.1)

    static let purpleBlueGradient = LinearGradient(
        colors: [neonPurple, electricBlue],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let heroGradient = LinearGradient(
        colors: [.clear, deepBlack],
        startPoint: .top,
        endPoint: .bottom
    )
}

// Theme.swift - MoviShow exp+ Color & Theme System

import SwiftUI

// MARK: - App Colors
enum AppColors {
    static let background = Color(hex: "0B0F1A")
    static let cardBackground = Color(hex: "141929")
    static let accent = Color(hex: "FF2E63")       // Neon Pink
    static let secondary = Color(hex: "00F5FF")    // Electric Cyan
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.7)
    static let divider = Color.white.opacity(0.1)
    
    // Gradient
    static let cinematicGradient = LinearGradient(
        colors: [accent, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.black.opacity(0.8), Color.clear],
        startPoint: .bottom,
        endPoint: .top
    )
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255
        g = Double((int >> 8) & 0xFF) / 255
        b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - View Modifiers
struct CinematicCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: AppColors.accent.opacity(0.15), radius: 10, y: 5)
    }
}

extension View {
    func cinematicCard() -> some View {
        modifier(CinematicCard())
    }
}

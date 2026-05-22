//
//  ColorExtensions.swift
//  MovieApppss
//
//  Color extensions for consistent theming
//

import SwiftUI

extension Color {
    // Primary Colors
    static let primaryPurple = Color(red: 0.6, green: 0.3, blue: 0.9)
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    
    // Background Colors
    static let backgroundPrimary = Color.black
    static let backgroundSecondary = Color(white: 0.1)
    static let backgroundTertiary = Color(white: 0.15)
    
    // Card Colors
    static let cardBackground = Color.black.opacity(0.3)
    static let cardBorder = Color.white.opacity(0.1)
    
    // Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
    static let textTertiary = Color.white.opacity(0.6)
    
    // Accent Colors
    static let accentRed = Color.red
    static let accentGreen = Color.green
    static let accentYellow = Color.yellow
    static let accentOrange = Color.orange
    static let accentCyan = Color.cyan
    
    // Gradient Colors
    static let gradientPurpleBlue = LinearGradient(
        gradient: Gradient(colors: [primaryPurple, primaryBlue]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let gradientPurpleBlueDiagonal = LinearGradient(
        gradient: Gradient(colors: [primaryPurple, primaryBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.black,
            Color.purple.opacity(0.3),
            Color.black
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// Custom View Modifiers
struct GlassmorphismModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
    }
}

extension View {
    func glassmorphism() -> some View {
        modifier(GlassmorphismModifier())
    }
    
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}

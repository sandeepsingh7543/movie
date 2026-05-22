//
//  ThemeManager.swift
//  MyTv123Moviesbox
//
//  Enhanced theme management with better colors
//

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var isDarkMode: Bool = true
    @Published var currentTheme: AppTheme = .cinema
    @Published var accentColor: Color = .red
    
    enum AppTheme: String, CaseIterable {
        case cinema = "Cinema"
        case neon = "Neon"
        case midnight = "Midnight"
        case sunset = "Sunset"
        case ocean = "Ocean"
        
        var primaryGradient: LinearGradient {
            switch self {
            case .cinema:
                return LinearGradient(
                    colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .neon:
                return LinearGradient(
                    colors: [Color.black, Color(red: 0.1, green: 0.05, blue: 0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .midnight:
                return LinearGradient(
                    colors: [Color.black, Color(white: 0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            case .sunset:
                return LinearGradient(
                    colors: [Color.black, Color(red: 0.15, green: 0.05, blue: 0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .ocean:
                return LinearGradient(
                    colors: [Color.black, Color(red: 0.05, green: 0.1, blue: 0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        
        var cardBackground: Color {
            switch self {
            case .cinema: return Color(white: 0.1).opacity(0.8)
            case .neon: return Color(red: 0.15, green: 0.1, blue: 0.25).opacity(0.8)
            case .midnight: return Color(white: 0.08).opacity(0.8)
            case .sunset: return Color(red: 0.2, green: 0.1, blue: 0.1).opacity(0.8)
            case .ocean: return Color(red: 0.1, green: 0.15, blue: 0.2).opacity(0.8)
            }
        }
        
        var textPrimary: Color {
            return .white
        }
        
        var textSecondary: Color {
            return Color(white: 0.7)
        }
        
        var backgroundColor: Color {
            return Color.black
        }
    }
    
    private init() {
        setTheme(.cinema)
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        switch theme {
        case .cinema: accentColor = .red
        case .neon: accentColor = Color(red: 0.8, green: 0.2, blue: 1.0)
        case .midnight: accentColor = .white
        case .sunset: accentColor = .orange
        case .ocean: accentColor = Color(red: 0.2, green: 0.8, blue: 1.0)
        }
    }
}

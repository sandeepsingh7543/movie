import SwiftUI

struct StarmaxPalette {
    let isDark: Bool
    let accentTheme: AppThemeStyle

    var accentColor: Color { accentTheme.accentColor }

    var backgroundGradients: [Color] {
        if isDark {
            return accentTheme.gradients
        }

        switch accentTheme {
        case .obsidian:
            return [Color(hex: 0xF3F6FB), Color(hex: 0xE6EEF8), Color(hex: 0xDCE7F4)]
        case .ocean:
            return [Color(hex: 0xF2FBFF), Color(hex: 0xE0F5FD), Color(hex: 0xD1EDF8)]
        case .ember:
            return [Color(hex: 0xFFF7F3), Color(hex: 0xFDE9DF), Color(hex: 0xFAD8C8)]
        case .aurora:
            return [Color(hex: 0xF3FFF8), Color(hex: 0xE3F7EC), Color(hex: 0xD5F0E3)]
        }
    }

    var textPrimary: Color {
        isDark ? .white : Color(hex: 0x101828)
    }

    var textSecondary: Color {
        isDark ? Color.white.opacity(0.72) : Color(hex: 0x475467)
    }

    var textMuted: Color {
        isDark ? Color.white.opacity(0.55) : Color(hex: 0x667085)
    }

    var surfaceFill: Color {
        isDark ? Color.white.opacity(0.08) : Color.white.opacity(0.78)
    }

    var surfaceStroke: Color {
        isDark ? Color.white.opacity(0.12) : Color.black.opacity(0.06)
    }

    var surfaceShadow: Color {
        isDark ? Color.black.opacity(0.22) : Color.black.opacity(0.10)
    }

    var subtleFill: Color {
        isDark ? Color.white.opacity(0.06) : Color.black.opacity(0.04)
    }

    var inverseText: Color {
        isDark ? Color.black : Color.white
    }

    var chipFill: Color {
        isDark ? Color.white.opacity(0.08) : Color.black.opacity(0.05)
    }
}

private struct StarmaxPaletteKey: EnvironmentKey {
    static let defaultValue = StarmaxPalette(isDark: true, accentTheme: .obsidian)
}

extension EnvironmentValues {
    var starmaxPalette: StarmaxPalette {
        get { self[StarmaxPaletteKey.self] }
        set { self[StarmaxPaletteKey.self] = newValue }
    }
}


import SwiftUI

enum MovieStatus: String, CaseIterable, Identifiable, Codable {
    case watched = "Watched"
    case planToWatch = "Plan to Watch"

    var id: String { rawValue }
}

enum MovieSortOption: String, CaseIterable, Identifiable {
    case recent = "Recent"
    case rating = "Rating"
    case title = "Name"

    var id: String { rawValue }
}

enum MovieFilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case watched = "Watched"
    case pending = "Pending"
    case favorites = "Favorites"

    var id: String { rawValue }
}

enum MoodTag: String, CaseIterable, Identifiable, Codable {
    case happy = "Happy"
    case action = "Action"
    case chill = "Chill"
    case dramatic = "Dramatic"
    case nostalgic = "Nostalgic"
    case focused = "Focused"
    case cozy = "Cozy"
    case adrenaline = "Adrenaline"
    case rainy = "Rainy Night"
    case lateNight = "Late Night"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .happy: return "sun.max.fill"
        case .action: return "bolt.fill"
        case .chill: return "wind"
        case .dramatic: return "theatermasks.fill"
        case .nostalgic: return "clock.arrow.circlepath"
        case .focused: return "scope"
        case .cozy: return "house.fill"
        case .adrenaline: return "flame.fill"
        case .rainy: return "cloud.rain.fill"
        case .lateNight: return "moon.stars.fill"
        }
    }
}

enum ThemeMode: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum AppThemeStyle: String, CaseIterable, Identifiable {
    case obsidian = "Obsidian"
    case ocean = "Ocean"
    case ember = "Ember"
    case aurora = "Aurora"

    var id: String { rawValue }

    var accentColor: Color {
        switch self {
        case .obsidian: return Color(hex: 0x89C2FF)
        case .ocean: return Color(hex: 0x6EE7F9)
        case .ember: return Color(hex: 0xFF9E6B)
        case .aurora: return Color(hex: 0x8EF7C9)
        }
    }

    var gradients: [Color] {
        switch self {
        case .obsidian:
            return [Color(hex: 0x0B1020), Color(hex: 0x111B34), Color(hex: 0x1D2443)]
        case .ocean:
            return [Color(hex: 0x04131F), Color(hex: 0x12314A), Color(hex: 0x1A4B6D)]
        case .ember:
            return [Color(hex: 0x1A0B0B), Color(hex: 0x3A1710), Color(hex: 0x7A2F17)]
        case .aurora:
            return [Color(hex: 0x07180F), Color(hex: 0x113022), Color(hex: 0x225240)]
        }
    }
}

enum MovieGenreCatalog {
    static let genres = [
        "Action", "Adventure", "Animation", "Biography", "Comedy",
        "Crime", "Documentary", "Drama", "Family", "Fantasy",
        "History", "Horror", "Music", "Mystery", "Romance",
        "Sci-Fi", "Sport", "Thriller", "War", "Western"
    ]
}

struct WeeklyTrendPoint: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let watchCount: Int
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}


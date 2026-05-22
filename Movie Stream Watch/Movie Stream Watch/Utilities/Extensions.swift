import SwiftUI

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self.padding()
            .background(Color.cardBackground)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }

    func fadeIn(_ active: Bool = true) -> some View {
        self.opacity(active ? 1 : 0)
            .animation(.easeIn(duration: 0.4), value: active)
    }
}

// MARK: - String Extensions
extension String {
    var genreEmoji: String {
        switch self.lowercased() {
        case "action": return "💥"
        case "comedy": return "😂"
        case "drama": return "🎭"
        case "horror": return "👻"
        case "romance": return "❤️"
        case "sci-fi", "science fiction": return "🚀"
        case "thriller": return "🔪"
        case "animation": return "🎨"
        case "documentary": return "📹"
        case "fantasy": return "🧙"
        case "mystery": return "🔍"
        case "musical": return "🎵"
        default: return "🎬"
        }
    }
}

// MARK: - Date Extensions
extension Date {
    var timeAgo: String {
        let interval = Date().timeIntervalSince(self)
        let minutes = Int(interval / 60)
        let hours = minutes / 60
        let days = hours / 24

        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes)m ago" }
        if hours < 24 { return "\(hours)h ago" }
        if days < 30 { return "\(days)d ago" }
        return "\(days / 30)mo ago"
    }
}

// MARK: - Double Extensions
extension Double {
    var ratingStars: String {
        let full = Int(self)
        let half = (self - Double(full)) >= 0.5
        return String(repeating: "★", count: full)
            + (half ? "½" : "")
            + String(repeating: "☆", count: 5 - full - (half ? 1 : 0))
    }
}

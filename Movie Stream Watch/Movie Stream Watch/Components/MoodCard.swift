import SwiftUI

struct MoodCard: View {
    let mood: String
    let action: () -> Void

    private var emoji: String {
        switch mood.lowercased() {
        case "action": return "💥"
        case "chill": return "😌"
        case "romantic": return "❤️‍🔥"
        case "focus": return "🧠"
        default: return "🎬"
        }
    }

    private var gradient: [Color] {
        switch mood.lowercased() {
        case "action": return [.appPrimary, .orange]
        case "chill": return [.blue, .appSecondary]
        case "romantic": return [.pink, .appPrimary]
        case "focus": return [.appSecondary, .indigo]
        default: return [.appPrimary, .appSecondary]
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 32))
                Text(mood)
                    .font(.appSubtitle)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                LinearGradient(colors: gradient.map { $0.opacity(0.7) },
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(16)
        }
    }
}

import SwiftUI

struct MoodCard: View {
    let mood: String
    let icon: String

    private var moodGradient: LinearGradient {
        let colors: [Color] = switch mood.lowercased() {
        case "happy": [.yellow, .orange]
        case "sad": [.blue, .indigo]
        case "thrilling": [.red, .orange]
        case "romantic": [.pink, .red]
        case "scary": [.purple, .black]
        case "chill": [.teal, .mint]
        default: [CineverseTheme.neonPurple, CineverseTheme.electricBlue]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            Text(mood)
                .font(.subheadline.bold())
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(moodGradient)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

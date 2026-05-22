import SwiftUI

struct StarRatingView: View {
    let rating: Int
    var size: CGFloat = 14
    var interactive = false
    var onRate: ((Int) -> Void)? = nil

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundColor(star <= rating ? Theme.accentGold : Theme.textSecondary)
                    .onTapGesture {
                        if interactive { onRate?(star) }
                    }
            }
        }
    }
}

struct GenreBadge: View {
    let genre: String
    var body: some View {
        Text(genre)
            .font(.caption2).fontWeight(.semibold)
            .foregroundColor(Theme.accent)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Theme.accent.opacity(0.15))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Theme.accent.opacity(0.3), lineWidth: 0.5))
    }
}

struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .background(Theme.glass)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.glassBorder, lineWidth: 0.5))
    }
}

struct PosterImage: View {
    let data: Data?
    var cornerRadius: CGFloat = 12
    var body: some View {
        Group {
            if let data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable().scaledToFill()
            } else {
                ZStack {
                    Theme.card
                    VStack(spacing: 8) {
                        Image(systemName: "film")
                            .font(.system(size: 32))
                            .foregroundColor(Theme.textSecondary)
                        Text("No Poster")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct WatchedBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption2)
            Text("Watched")
                .font(.caption2).fontWeight(.semibold)
        }
        .foregroundColor(.green)
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(Color.green.opacity(0.15))
        .clipShape(Capsule())
    }
}

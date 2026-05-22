import SwiftUI

struct MovieCard: View {
    @ObservedObject var movie: Movie

    enum CardSize {
        case small, medium, large
        var width: CGFloat {
            switch self { case .small: return 120; case .medium: return 150; case .large: return 180 }
        }
        var height: CGFloat { width * 1.5 }
    }

    var size: CardSize = .medium

    private var isSeries: Bool { (movie.contentType ?? "Movie") == "Series" }

    var body: some View {
        ZStack(alignment: .bottom) {
            PosterImage(posterData: movie.posterData)
                .frame(width: size.width, height: size.height)
                .clipped()

            // Title + episode overlay
            LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                .frame(height: size.height * 0.45)
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(movie.title ?? "")
                            .font(.appCaption)
                            .foregroundColor(.white)
                            .lineLimit(2)
                        if isSeries && movie.currentEpisode > 0 {
                            Text("S\(movie.currentSeason) • E\(movie.currentEpisode)")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.appSecondary)
                        }
                    }
                    .padding(8)
                }

            // Progress bar (movies)
            if !isSeries && movie.watchProgress > 0 {
                VStack {
                    Spacer()
                    GeometryReader { geo in
                        Color.appPrimary
                            .frame(width: geo.size.width * movie.watchProgress)
                    }
                    .frame(height: 3)
                }
            }

            // Top badges
            VStack {
                HStack {
                    // Series badge
                    if isSeries {
                        Text("SERIES")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color.appSecondary)
                            .cornerRadius(4)
                    }
                    if movie.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundColor(.appPrimary)
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Spacer()
                    if movie.rating > 0 {
                        Text(String(format: "%.1f", movie.rating))
                            .font(.appCaption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.appPrimary)
                            .cornerRadius(6)
                    }
                }
                .padding(6)
                Spacer()
            }
        }
        .frame(width: size.width, height: size.height)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }
}

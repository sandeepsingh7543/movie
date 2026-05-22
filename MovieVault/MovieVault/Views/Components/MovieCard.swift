import SwiftUI

struct MovieCard: View {
    let movie: Movie
    // Decode image once, not on every render
    private let poster: UIImage?

    init(movie: Movie) {
        self.movie = movie
        if let data = movie.posterData {
            self.poster = UIImage(data: data)
        } else {
            self.poster = nil
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if let poster {
                        Image(uiImage: poster)
                            .resizable()
                            .scaledToFill()
                    } else {
                        ZStack {
                            Theme.card
                            Image(systemName: "film")
                                .font(.system(size: 32))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 200)
                .clipped()

                if movie.isWatched {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .padding(8)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)

                HStack {
                    StarRatingView(rating: movie.rating, size: 11)
                    Spacer()
                    GenreBadge(genre: movie.genre)
                }
            }
            .padding(10)
        }
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.glassBorder, lineWidth: 0.5))
        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
    }
}

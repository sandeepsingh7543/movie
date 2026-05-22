import SwiftUI

struct MovieDetailView: View {
    @Bindable var movie: Movie
    let vm: MovieViewModel

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Full-width poster with gradient fade at bottom ──
                    ZStack(alignment: .bottom) {
                        GeometryReader { geo in
                            if let data = movie.posterData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: 480)
                                    .clipped()
                            } else {
                                ZStack {
                                    Theme.card
                                    Image(systemName: "film")
                                        .font(.system(size: 60))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .frame(width: geo.size.width, height: 480)
                            }
                        }
                        .frame(height: 480)

                        // Gradient so text below is readable
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: Theme.background.opacity(0.6), location: 0.6),
                                .init(color: Theme.background, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 480)

                        // Title + badges overlaid at bottom of poster
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.title).fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)

                            HStack(spacing: 10) {
                                GenreBadge(genre: movie.genre)
                                if movie.isWatched { WatchedBadge() }
                                Spacer()
                                StarRatingView(rating: movie.rating, size: 16)
                            }

                            Text(movie.releaseDate, style: .date)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }

                    // ── Content below poster ──
                    VStack(alignment: .leading, spacing: 20) {

                        if !movie.desc.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Overview")
                                    .font(.headline)
                                    .foregroundColor(Theme.textPrimary)
                                Text(movie.desc)
                                    .font(.body)
                                    .foregroundColor(Theme.textSecondary)
                                    .lineSpacing(5)
                            }
                        }

                        // Action buttons
                        VStack(spacing: 12) {
                            Button {
                                withAnimation(.spring()) { vm.toggleWatched(movie) }
                            } label: {
                                Label(
                                    movie.isWatched ? "Watched" : "Mark as Watched",
                                    systemImage: movie.isWatched ? "checkmark.circle.fill" : "circle"
                                )
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(movie.isWatched ? Color.green.opacity(0.2) : Theme.glass)
                                .foregroundColor(movie.isWatched ? .green : Theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(
                                    movie.isWatched ? Color.green.opacity(0.4) : Theme.glassBorder, lineWidth: 0.5
                                ))
                            }

                            Button {
                                withAnimation(.spring()) { vm.toggleWatchlist(movie) }
                            } label: {
                                Label(
                                    movie.isInWatchlist ? "In Watchlist" : "Add to Watchlist",
                                    systemImage: movie.isInWatchlist ? "bookmark.fill" : "bookmark"
                                )
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(movie.isInWatchlist ? Theme.accent.opacity(0.2) : Theme.accent)
                                .foregroundColor(movie.isInWatchlist ? Theme.accent : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(
                                    movie.isInWatchlist ? Theme.accent.opacity(0.4) : .clear, lineWidth: 0.5
                                ))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 60)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

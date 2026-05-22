import SwiftUI
import SwiftData

struct WatchlistView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var vm: MovieViewModel?
    @Query(filter: #Predicate<Movie> { $0.isInWatchlist },
           sort: \Movie.createdAt, order: .reverse)
    private var movies: [Movie]

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if movies.isEmpty {
                    EmptyStateView(
                        icon: "bookmark.slash",
                        title: "Watchlist is empty",
                        subtitle: "Add movies to your watchlist from the detail screen"
                    )
                } else {
                    List {
                        ForEach(movies) { movie in
                            if let vm = vm {
                                NavigationLink(destination: {
                                    MovieDetailView(movie: movie, vm: vm)
                                }, label: {
                                    WatchlistRow(movie: movie)
                                })
                                .listRowBackground(Theme.card)
                                .listRowSeparatorTint(Theme.glassBorder)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { movies[$0].isInWatchlist = false }
                            try? modelContext.save()
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Watchlist")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if vm == nil { vm = MovieViewModel(modelContext: modelContext) }
        }
        .preferredColorScheme(.dark)
    }
}

struct WatchlistRow: View {
    let movie: Movie
    var body: some View {
        HStack(spacing: 14) {
            PosterImage(data: movie.posterData, cornerRadius: 8)
                .frame(width: 60, height: 85)

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)

                GenreBadge(genre: movie.genre)
                StarRatingView(rating: movie.rating, size: 12)

                if movie.isWatched { WatchedBadge() }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

import Foundation

// MARK: - Movie Detail ViewModel (local only)
@MainActor
final class DetailViewModel: ObservableObject {
    @Published var isInWatchlist = false
    @Published var isFavorite = false

    private let persistence = PersistenceManager.shared

    func load(movie: Movie) {
        isInWatchlist = persistence.isInWatchlist(movie.id)
        isFavorite = persistence.isFavorite(movie.id)
        persistence.markViewed(movie)
    }

    func toggleWatchlist(movie: Movie) {
        if isInWatchlist {
            persistence.removeFromWatchlist(movie.id)
        } else {
            persistence.addToWatchlist(movie)
        }
        isInWatchlist.toggle()
    }

    func toggleFavorite(movie: Movie) {
        persistence.toggleFavorite(movie)
        isFavorite.toggle()
    }
}

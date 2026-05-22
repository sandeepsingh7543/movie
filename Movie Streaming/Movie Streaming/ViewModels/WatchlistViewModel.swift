import Foundation

// MARK: - Watchlist ViewModel
@MainActor
final class WatchlistViewModel: ObservableObject {
    @Published var watchlist: [SavedMovie] = []
    @Published var favorites: [SavedMovie] = []
    @Published var recentlyViewed: [SavedMovie] = []
    @Published var selectedCategory: String = "All"

    private let persistence = PersistenceManager.shared

    var allCategories: [String] {
        let cats = watchlist.compactMap { $0.manualCategory }
        let unique = Array(Set(cats)).sorted()
        return ["All"] + unique
    }

    var filteredWatchlist: [SavedMovie] {
        guard selectedCategory != "All" else { return watchlist }
        return watchlist.filter { $0.manualCategory == selectedCategory }
    }

    func refresh() {
        watchlist = persistence.fetchWatchlist()
        favorites = persistence.fetchFavorites()
        recentlyViewed = persistence.fetchRecentlyViewed()
    }

    func removeFromWatchlist(_ movieId: Int) {
        persistence.removeFromWatchlist(movieId)
        refresh()
    }
}

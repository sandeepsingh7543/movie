import SwiftData
import Foundation

// MARK: - Persistence Manager
@MainActor
final class PersistenceManager {
    static let shared = PersistenceManager()

    let container: ModelContainer

    private init() {
        let schema = Schema([SavedMovie.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        if let c = try? ModelContainer(for: schema, configurations: [config]) {
            container = c
        } else {
            // Schema changed — wipe store and recreate
            if let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                try? FileManager.default.removeItem(at: appSupport.appendingPathComponent("default.store"))
            }
            container = try! ModelContainer(for: schema, configurations: [config])
        }
    }

    var context: ModelContext { container.mainContext }

    // MARK: - Manual Movie
    func addManualMovie(title: String, posterPath: String?, overview: String, rating: Double, releaseDate: String?, category: String) {
        let saved = SavedMovie(manualTitle: title, posterPath: posterPath, overview: overview, voteAverage: rating, releaseDate: releaseDate, category: category)
        context.insert(saved)
        save()
    }

    // MARK: - Watchlist
    func addToWatchlist(_ movie: Movie) {
        if let existing = fetchSaved(movieId: movie.id) {
            existing.isWatchlist = true
        } else {
            context.insert(SavedMovie(from: movie, isWatchlist: true))
        }
        save()
    }

    func removeFromWatchlist(_ movieId: Int) {
        guard let saved = fetchSaved(movieId: movieId) else { return }
        saved.isWatchlist = false
        // Only delete if nothing else references it AND it's not manually added
        if !saved.isFavorite && saved.lastViewedDate == nil && !saved.isManuallyAdded {
            context.delete(saved)
        }
        save()
    }

    func isInWatchlist(_ movieId: Int) -> Bool {
        fetchSaved(movieId: movieId)?.isWatchlist == true
    }

    // MARK: - Favorites
    func toggleFavorite(_ movie: Movie) {
        if let existing = fetchSaved(movieId: movie.id) {
            existing.isFavorite.toggle()
            if !existing.isFavorite && !existing.isWatchlist && existing.lastViewedDate == nil && !existing.isManuallyAdded {
                context.delete(existing)
            }
        } else {
            context.insert(SavedMovie(from: movie, isFavorite: true))
        }
        save()
    }

    func isFavorite(_ movieId: Int) -> Bool {
        fetchSaved(movieId: movieId)?.isFavorite == true
    }

    // MARK: - Recently Viewed
    func markViewed(_ movie: Movie) {
        if let existing = fetchSaved(movieId: movie.id) {
            existing.lastViewedDate = Date()
        } else {
            // Don't create new record for non-manually-added movies that aren't saved
            let saved = SavedMovie(from: movie)
            saved.lastViewedDate = Date()
            context.insert(saved)
        }
        save()
    }

    // MARK: - Fetch
    func fetchSaved(movieId: Int) -> SavedMovie? {
        let descriptor = FetchDescriptor<SavedMovie>(predicate: #Predicate { $0.movieId == movieId })
        return try? context.fetch(descriptor).first
    }

    func fetchAllSaved() -> [SavedMovie] {
        let descriptor = FetchDescriptor<SavedMovie>(sortBy: [SortDescriptor(\.addedDate, order: .reverse)])
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchWatchlist() -> [SavedMovie] {
        let descriptor = FetchDescriptor<SavedMovie>(
            predicate: #Predicate { $0.isWatchlist == true },
            sortBy: [SortDescriptor(\.addedDate, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchManualMovies() -> [SavedMovie] {
        let descriptor = FetchDescriptor<SavedMovie>(
            predicate: #Predicate { $0.isManuallyAdded == true },
            sortBy: [SortDescriptor(\.addedDate, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchFavorites() -> [SavedMovie] {
        let descriptor = FetchDescriptor<SavedMovie>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.addedDate, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchRecentlyViewed(limit: Int = 20) -> [SavedMovie] {
        var descriptor = FetchDescriptor<SavedMovie>(
            predicate: #Predicate { $0.lastViewedDate != nil },
            sortBy: [SortDescriptor(\.lastViewedDate, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? context.fetch(descriptor)) ?? []
    }

    private func save() { try? context.save() }
}

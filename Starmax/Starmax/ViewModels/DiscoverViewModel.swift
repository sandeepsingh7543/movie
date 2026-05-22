import SwiftUI

@MainActor
final class DiscoverViewModel: ObservableObject {
    func surprisePick(from movies: [StarMovie]) -> StarMovie? {
        guard !movies.isEmpty else { return nil }
        let candidates = movies.filter { $0.status == .planToWatch }
        return (candidates.isEmpty ? movies : candidates).randomElement()
    }

    func highestRatedMovie(from movies: [StarMovie]) -> StarMovie? {
        movies.sorted {
            if $0.rating == $1.rating { return $0.updatedAt > $1.updatedAt }
            return $0.rating > $1.rating
        }.first
    }

    func leastWatchedGenreMovie(from movies: [StarMovie]) -> StarMovie? {
        let grouped = Dictionary(grouping: movies) { $0.genre }
        let rankedGenres = grouped
            .map { genre, entries -> (genre: String, watchedCount: Int, score: Double) in
                let watchedCount = entries.filter { $0.status == .watched }.count
                let averageRating = entries.map(\.rating).reduce(0, +) / Double(max(entries.count, 1))
                return (genre, watchedCount, averageRating)
            }
            .sorted {
                if $0.watchedCount == $1.watchedCount { return $0.score > $1.score }
                return $0.watchedCount < $1.watchedCount
            }

        guard let targetGenre = rankedGenres.first?.genre else { return nil }
        return movies
            .filter { $0.genre == targetGenre }
            .sorted {
                if $0.rating == $1.rating { return $0.updatedAt > $1.updatedAt }
                return $0.rating > $1.rating
            }
            .first
    }

    func randomWatchPrompt(from movies: [StarMovie]) -> String {
        guard !movies.isEmpty else {
            return "Start by adding your first movie. Then Starmax will begin curating suggestions from your own library."
        }

        let count = movies.count
        let watched = movies.filter { $0.status == .watched }.count
        let favoriteCount = movies.filter(\.isFavorite).count
        return "You have \(count) movies, \(watched) watched, and \(favoriteCount) favorites ready for a private movie night."
    }
}

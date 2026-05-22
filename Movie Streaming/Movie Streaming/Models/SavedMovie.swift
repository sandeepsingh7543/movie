import Foundation
import SwiftData

// MARK: - Persisted Movie (SwiftData)
@Model
final class SavedMovie {
    @Attribute(.unique) var movieId: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double
    var releaseDate: String?
    var addedDate: Date
    var isWatchlist: Bool
    var isFavorite: Bool
    var lastViewedDate: Date?
    var manualCategory: String?   // e.g. "Trending", "Popular", etc.
    var isManuallyAdded: Bool = false

    init(from movie: Movie, isWatchlist: Bool = false, isFavorite: Bool = false) {
        self.movieId = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.backdropPath = movie.backdropPath
        self.voteAverage = movie.voteAverage
        self.releaseDate = movie.releaseDate
        self.addedDate = Date()
        self.isWatchlist = isWatchlist
        self.isFavorite = isFavorite
        self.manualCategory = nil
        self.isManuallyAdded = false
    }

    // Manual init
    init(manualTitle: String, posterPath: String?, overview: String, voteAverage: Double, releaseDate: String?, category: String) {
        self.movieId = Int.random(in: 1_000_000...9_999_999)
        self.title = manualTitle
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = nil
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.addedDate = Date()
        self.isWatchlist = true
        self.isFavorite = false
        self.manualCategory = category
        self.isManuallyAdded = true
    }

    var posterURL: URL? {
        guard let path = posterPath, !path.isEmpty else { return nil }
        // Full http/https URL
        if path.hasPrefix("http") { return URL(string: path) }
        // Filename only — reconstruct from Documents directory (sandbox-safe)
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(path)
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }

    var releaseYear: String {
        guard let date = releaseDate, date.count >= 4 else { return "N/A" }
        return String(date.prefix(4))
    }

    func toMovie() -> Movie {
        Movie(
            id: movieId,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            voteCount: 0,
            releaseDate: releaseDate,
            genreIds: [],
            popularity: 0
        )
    }
}

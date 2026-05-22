import Foundation

// MARK: - Movie Model (local only, no API)
struct Movie: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String?
    let genreIds: [Int]
    let popularity: Double

    var posterURL: URL? {
        guard let path = posterPath, !path.isEmpty else { return nil }
        if path.hasPrefix("http") { return URL(string: path) }
        // Filename — reconstruct from Documents (matches SavedMovie logic)
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(path)
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }

    var backdropURL: URL? { posterURL }

    var releaseYear: String {
        guard let date = releaseDate, date.count >= 4 else { return "N/A" }
        return String(date.prefix(4))
    }

    var ratingFormatted: String { String(format: "%.1f", voteAverage) }
}

// MARK: - Movie Category
enum MovieCategory: String, CaseIterable, Identifiable {
    case trending  = "Trending"
    case popular   = "Popular"
    case topRated  = "Top Rated"
    case upcoming  = "Upcoming"
    case nowPlaying = "Now Playing"

    var id: String { rawValue }
}

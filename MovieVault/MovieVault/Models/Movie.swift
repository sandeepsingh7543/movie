import Foundation
import SwiftData

@Model
final class Movie {
    var id: UUID
    var title: String
    var desc: String
    var genre: String
    var releaseDate: Date
    var rating: Int
    var isWatched: Bool
    var isInWatchlist: Bool
    var posterData: Data?
    var createdAt: Date

    init(
        title: String,
        desc: String,
        genre: String,
        releaseDate: Date,
        rating: Int,
        posterData: Data? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.desc = desc
        self.genre = genre
        self.releaseDate = releaseDate
        self.rating = rating
        self.isWatched = false
        self.isInWatchlist = false
        self.posterData = posterData
        self.createdAt = Date()
    }
}

enum Genre: String, CaseIterable {
    case action = "Action"
    case comedy = "Comedy"
    case drama = "Drama"
    case horror = "Horror"
    case sciFi = "Sci-Fi"
    case thriller = "Thriller"
    case romance = "Romance"
    case animation = "Animation"
    case documentary = "Documentary"
    case crime = "Crime"
}

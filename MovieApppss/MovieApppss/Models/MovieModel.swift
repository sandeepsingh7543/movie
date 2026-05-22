//
//  MovieModel.swift
//  MovieApppss
//
//  Enhanced Movie Model with additional features
//

import Foundation

struct MovieModel: Identifiable, Codable {
    var id = UUID()
    var title: String
    var genre: String
    var description: String
    var duration: String
    var posterImageData: String
    var backdropImageData: String?
    var isPurchased: Bool
    var isFavorite: Bool
    var isWatched: Bool
    var watchProgress: Double // 0.0 to 1.0
    
    // Enhanced details
    var releaseDate: String
    var rating: Double
    var imdbRating: Double?
    var rottenTomatoesScore: Int?
    var director: String
    var cast: [String]
    var language: String
    var subtitlesAvailable: Bool
    var trailerURL: String?
    var price: Double?
    var reviews: [String]
    var categories: [String]
    var streamingPlatforms: [String]
    
    // New features
    var watchedDate: Date?
    var personalRating: Double?
    var personalNotes: String
    var tags: [String]
    var seasons: Int?
    var episodes: Int?
    var contentType: ContentType
    var ageRating: String
    var country: String
    var budget: String?
    var boxOffice: String?
    
    enum ContentType: String, CaseIterable, Codable {
        case movie = "Movie"
        case tvShow = "TV Show"
        case webSeries = "Web Series"
        case documentary = "Documentary"
        case shortFilm = "Short Film"
    }
    
    // Computed properties
    var formattedRating: String {
        return String(format: "%.1f", rating)
    }
    
    var isMultiSeason: Bool {
        return contentType != .movie && (seasons ?? 0) > 1
    }
    
    var watchProgressPercentage: Int {
        return Int(watchProgress * 100)
    }
}

// Sample data for testing
extension MovieModel {
    static let sampleMovies: [MovieModel] = [
        MovieModel(
            title: "The Dark Knight",
            genre: "Action, Crime, Drama",
            description: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
            duration: "2h 32min",
            posterImageData: "",
            isPurchased: true,
            isFavorite: true,
            isWatched: false,
            watchProgress: 0.0,
            releaseDate: "July 18, 2008",
            rating: 9.0,
            imdbRating: 9.0,
            rottenTomatoesScore: 94,
            director: "Christopher Nolan",
            cast: ["Christian Bale", "Heath Ledger", "Aaron Eckhart"],
            language: "English",
            subtitlesAvailable: true,
            price: 12.99,
            reviews: ["Masterpiece!", "Best Batman movie ever"],
            categories: ["Superhero", "Crime", "Thriller"],
            streamingPlatforms: ["Netflix", "HBO Max"],
            personalNotes: "",
            tags: ["must-watch", "superhero"],
            contentType: .movie,
            ageRating: "PG-13",
            country: "USA",
            budget: "$185 million",
            boxOffice: "$1.005 billion"
        )
    ]
}

//
//  MovieModel.swift
//  MyTv123Moviesbox
//
//  Enhanced Movie Model for streaming content
//

import Foundation

struct MovieModel: Identifiable, Codable {
    var id = UUID()
    var title: String
    var genre: String
    var description: String
    var duration: String
    var posterURL: String
    var backdropURL: String?
    var isFavorite: Bool
    var isWatched: Bool
    var watchProgress: Double
    
    // Enhanced details
    var releaseYear: String
    var rating: Double
    var imdbRating: Double?
    var director: String
    var cast: [String]
    var language: String
    var subtitles: [String]
    var trailerURL: String?
    var streamingURL: String?
    var categories: [String]
    var quality: VideoQuality
    
    // Unique features
    var watchedDate: Date?
    var personalRating: Double?
    var personalNotes: String
    var tags: [String]
    var seasons: Int?
    var episodes: Int?
    var contentType: ContentType
    var ageRating: String
    var country: String
    var popularity: Double
    var trendingScore: Double
    
    enum ContentType: String, CaseIterable, Codable {
        case movie = "Movie"
        case tvShow = "TV Show"
        case webSeries = "Web Series"
        case documentary = "Documentary"
        case anime = "Anime"
        case liveTV = "Live TV"
    }
    
    enum VideoQuality: String, CaseIterable, Codable {
        case sd = "SD"
        case hd = "HD"
        case fullHD = "Full HD"
        case fourK = "4K"
        case eightK = "8K"
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

// Sample data
extension MovieModel {
    static let sampleMovies: [MovieModel] = [
        MovieModel(
            title: "Avengers: Endgame",
            genre: "Action, Adventure, Drama",
            description: "After the devastating events of Avengers: Infinity War, the universe is in ruins.",
            duration: "3h 1min",
            posterURL: "https://example.com/endgame.jpg",
            isFavorite: true,
            isWatched: false,
            watchProgress: 0.0,
            releaseYear: "2019",
            rating: 8.4,
            imdbRating: 8.4,
            director: "Anthony Russo, Joe Russo",
            cast: ["Robert Downey Jr.", "Chris Evans", "Mark Ruffalo"],
            language: "English",
            subtitles: ["English", "Spanish", "French"],
            categories: ["Superhero", "Action", "Drama"],
            quality: .fourK,
            personalNotes: "",
            tags: ["marvel", "superhero"],
            contentType: .movie,
            ageRating: "PG-13",
            country: "USA",
            popularity: 9.5,
            trendingScore: 8.8
        ),
        MovieModel(
            title: "Stranger Things",
            genre: "Drama, Fantasy, Horror",
            description: "When a young boy disappears, his mother, a police chief and his friends must confront terrifying supernatural forces.",
            duration: "50min per episode",
            posterURL: "https://example.com/stranger-things.jpg",
            isFavorite: true,
            isWatched: true,
            watchProgress: 0.75,
            releaseYear: "2016",
            rating: 8.7,
            imdbRating: 8.7,
            director: "The Duffer Brothers",
            cast: ["Millie Bobby Brown", "Finn Wolfhard", "Winona Ryder"],
            language: "English",
            subtitles: ["English", "Spanish", "French", "German"],
            categories: ["Sci-Fi", "Horror", "Drama"],
            quality: .fourK,
            personalNotes: "Amazing series!",
            tags: ["netflix", "sci-fi"],
            seasons: 4,
            episodes: 34,
            contentType: .tvShow,
            ageRating: "TV-14",
            country: "USA",
            popularity: 9.2,
            trendingScore: 9.1
        )
    ]
}

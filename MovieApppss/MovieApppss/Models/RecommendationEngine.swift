//
//  RecommendationEngine.swift
//  MovieApppss
//
//  AI-Powered Movie Recommendation Engine
//

import Foundation

class RecommendationEngine: ObservableObject {
    static let shared = RecommendationEngine()
    
    @Published var personalizedRecommendations: [MovieModel] = []
    @Published var trendingRecommendations: [MovieModel] = []
    @Published var moodBasedRecommendations: [String: [MovieModel]] = [:]
    
    private init() {}
    
    // Generate personalized recommendations based on user behavior
    func generatePersonalizedRecommendations(for movies: [MovieModel]) {
        let watchedMovies = movies.filter { $0.isWatched }
        let favoriteMovies = movies.filter { $0.isFavorite }
        let highRatedMovies = movies.filter { ($0.personalRating ?? 0) >= 4.0 }
        
        // Analyze user preferences
        let preferredGenres = extractPreferredGenres(from: favoriteMovies + highRatedMovies)
        let preferredDirectors = extractPreferredDirectors(from: favoriteMovies)
        let preferredActors = extractPreferredActors(from: favoriteMovies)
        
        // Generate recommendations based on preferences
        personalizedRecommendations = generateRecommendations(
            basedOn: preferredGenres,
            directors: preferredDirectors,
            actors: preferredActors,
            excludeWatched: watchedMovies
        )
    }
    
    // Generate mood-based recommendations
    func generateMoodBasedRecommendations() {
        let moods = ["Happy", "Sad", "Excited", "Relaxed", "Adventurous", "Romantic"]
        
        for mood in moods {
            moodBasedRecommendations[mood] = getMoodBasedMovies(for: mood)
        }
    }
    
    private func extractPreferredGenres(from movies: [MovieModel]) -> [String] {
        var genreCount: [String: Int] = [:]
        
        for movie in movies {
            let genres = movie.genre.components(separatedBy: ", ")
            for genre in genres {
                genreCount[genre, default: 0] += 1
            }
        }
        
        return genreCount.sorted { $0.value > $1.value }.prefix(3).map { $0.key }
    }
    
    private func extractPreferredDirectors(from movies: [MovieModel]) -> [String] {
        var directorCount: [String: Int] = [:]
        
        for movie in movies {
            directorCount[movie.director, default: 0] += 1
        }
        
        return directorCount.sorted { $0.value > $1.value }.prefix(2).map { $0.key }
    }
    
    private func extractPreferredActors(from movies: [MovieModel]) -> [String] {
        var actorCount: [String: Int] = [:]
        
        for movie in movies {
            for actor in movie.cast {
                actorCount[actor, default: 0] += 1
            }
        }
        
        return actorCount.sorted { $0.value > $1.value }.prefix(3).map { $0.key }
    }
    
    private func generateRecommendations(basedOn genres: [String], directors: [String], actors: [String], excludeWatched: [MovieModel]) -> [MovieModel] {
        // Sample recommendations - in real app, this would connect to movie database API
        return [
            MovieModel(
                title: "Inception",
                genre: "Sci-Fi, Thriller",
                description: "A thief who steals corporate secrets through dream-sharing technology.",
                duration: "2h 28min",
                posterImageData: "",
                isPurchased: false,
                isFavorite: false,
                isWatched: false,
                watchProgress: 0.0,
                releaseDate: "July 16, 2010",
                rating: 8.8,
                director: "Christopher Nolan",
                cast: ["Leonardo DiCaprio", "Marion Cotillard"],
                language: "English",
                subtitlesAvailable: true,
                reviews: [],
                categories: ["Mind-bending", "Sci-Fi"],
                streamingPlatforms: ["Netflix"],
                personalNotes: "",
                tags: ["recommended"],
                contentType: .movie,
                ageRating: "PG-13",
                country: "USA"
            )
        ]
    }
    
    private func getMoodBasedMovies(for mood: String) -> [MovieModel] {
        switch mood {
        case "Happy":
            return getComedyMovies()
        case "Sad":
            return getDramaMovies()
        case "Excited":
            return getActionMovies()
        case "Relaxed":
            return getRomanticMovies()
        case "Adventurous":
            return getAdventureMovies()
        case "Romantic":
            return getRomanticMovies()
        default:
            return []
        }
    }
    
    private func getComedyMovies() -> [MovieModel] {
        return [
            MovieModel(
                title: "The Grand Budapest Hotel",
                genre: "Comedy, Drama",
                description: "A legendary concierge and his protégé at a famous European hotel.",
                duration: "1h 39min",
                posterImageData: "",
                isPurchased: false,
                isFavorite: false,
                isWatched: false,
                watchProgress: 0.0,
                releaseDate: "March 28, 2014",
                rating: 8.1,
                director: "Wes Anderson",
                cast: ["Ralph Fiennes", "F. Murray Abraham"],
                language: "English",
                subtitlesAvailable: true,
                reviews: [],
                categories: ["Comedy", "Quirky"],
                streamingPlatforms: ["Hulu"],
                personalNotes: "",
                tags: ["mood-happy"],
                contentType: .movie,
                ageRating: "R",
                country: "USA"
            )
        ]
    }
    
    private func getDramaMovies() -> [MovieModel] { return [] }
    private func getActionMovies() -> [MovieModel] { return [] }
    private func getRomanticMovies() -> [MovieModel] { return [] }
    private func getAdventureMovies() -> [MovieModel] { return [] }
}

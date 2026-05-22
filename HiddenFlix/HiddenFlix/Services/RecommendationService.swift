import Foundation
import CoreData

class RecommendationService {
    static let shared = RecommendationService()
    
    private init() {}
    
    func getRecommendations(for user: UserPreferences, from movies: [Movie]) -> [Movie] {
        var recommendations: [Movie] = []
        
        // Get user's favorite genres
        let favoriteGenres = getFavoriteGenres(from: movies)
        
        // Get highly rated movies in favorite genres
        let genreBasedRecommendations = movies.filter { movie in
            favoriteGenres.contains(movie.genre) && movie.rating >= 7.5 && !movie.isFavorite
        }
        
        recommendations.append(contentsOf: genreBasedRecommendations.prefix(3))
        
        // Get AI-generated movies if user likes them
        let aiMovies = movies.filter { $0.isAIGenerated && !recommendations.contains($0) }
        recommendations.append(contentsOf: aiMovies.prefix(2))
        
        // Get recent additions
        let recentMovies = movies.sorted { $0.dateAdded > $1.dateAdded }
            .filter { !recommendations.contains($0) }
        recommendations.append(contentsOf: recentMovies.prefix(2))
        
        return Array(recommendations.prefix(5))
    }
    
    private func getFavoriteGenres(from movies: [Movie]) -> [String] {
        let favoriteMovies = movies.filter { $0.isFavorite }
        let genreCounts = Dictionary(grouping: favoriteMovies, by: { $0.genre })
            .mapValues { $0.count }
        
        return genreCounts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
    }
    
    func getSimilarMovies(to movie: Movie, from movies: [Movie]) -> [Movie] {
        return movies.filter { otherMovie in
            otherMovie.id != movie.id &&
            (otherMovie.genre == movie.genre ||
             abs(otherMovie.rating - movie.rating) <= 1.0 ||
             abs(Int(otherMovie.releaseYear) - Int(movie.releaseYear)) <= 3)
        }
        .sorted { abs($0.rating - movie.rating) < abs($1.rating - movie.rating) }
        .prefix(4)
        .map { $0 }
    }
}

struct UserPreferences {
    let favoriteGenres: [String]
    let preferredRatingRange: ClosedRange<Double>
    let likesAIGenerated: Bool
}



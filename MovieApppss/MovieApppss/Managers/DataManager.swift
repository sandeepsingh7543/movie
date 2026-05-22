//
//  DataManager.swift
//  MovieApppss
//
//  Enhanced Data Management with Core Data support
//

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var movies: [MovieModel] = []
    @Published var actors: [ActorModel] = []
    @Published var watchlist: [MovieModel] = []
    @Published var favorites: [MovieModel] = []
    
    private let moviesKey = "SavedMovies"
    private let actorsKey = "SavedActors"
    private let watchlistKey = "SavedWatchlist"
    private let favoritesKey = "SavedFavorites"
    
    private init() {
        loadData()
        
        // Add sample data if no movies exist (for testing)
        if movies.isEmpty {
            addSampleData()
        }
    }
    
    private func addSampleData() {
        print("Adding sample data...")
        
        let sampleMovie1 = MovieModel(
            title: "The Matrix",
            genre: "Sci-Fi",
            description: "A computer programmer discovers reality is a simulation.",
            duration: "2h 16m",
            posterImageData: "",
            backdropImageData: "",
            isPurchased: false,
            isFavorite: false,
            isWatched: false,
            watchProgress: 0.0,
            releaseDate: "1999",
            rating: 8.7,
            imdbRating: 8.7,
            rottenTomatoesScore: 88,
            director: "The Wachowskis",
            cast: ["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss"],
            language: "English",
            subtitlesAvailable: true,
            trailerURL: nil,
            price: nil,
            reviews: [],
            categories: ["Sci-Fi", "Action"],
            streamingPlatforms: ["Netflix"],
            personalNotes: "",
            tags: ["cyberpunk", "philosophy"],
            seasons: nil,
            episodes: nil,
            contentType: .movie,
            ageRating: "R",
            country: "USA",
            budget: nil,
            boxOffice: nil
        )
        
        let sampleMovie2 = MovieModel(
            title: "Inception",
            genre: "Sci-Fi",
            description: "A thief who steals corporate secrets through dream-sharing technology.",
            duration: "2h 28m",
            posterImageData: "",
            backdropImageData: "",
            isPurchased: false,
            isFavorite: true,
            isWatched: true,
            watchProgress: 1.0,
            releaseDate: "2010",
            rating: 8.8,
            imdbRating: 8.8,
            rottenTomatoesScore: 87,
            director: "Christopher Nolan",
            cast: ["Leonardo DiCaprio", "Marion Cotillard", "Tom Hardy"],
            language: "English",
            subtitlesAvailable: true,
            trailerURL: nil,
            price: nil,
            reviews: [],
            categories: ["Sci-Fi", "Thriller"],
            streamingPlatforms: ["HBO Max"],
            personalNotes: "Amazing movie!",
            tags: ["dreams", "heist"],
            seasons: nil,
            episodes: nil,
            contentType: .movie,
            ageRating: "PG-13",
            country: "USA",
            budget: nil,
            boxOffice: nil
        )
        
        movies.append(sampleMovie1)
        movies.append(sampleMovie2)
        saveMovies()
        
        print("Sample data added: \(movies.count) movies")
    }
    
    // MARK: - Movie Management
    func addMovie(_ movie: MovieModel) {
        print("Adding movie: \(movie.title)")
        movies.append(movie)
        print("Total movies after adding: \(movies.count)")
        saveMovies()
        print("Movie saved to UserDefaults")
    }
    
    func updateMovie(_ movie: MovieModel) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    func deleteMovie(_ movie: MovieModel) {
        movies.removeAll { $0.id == movie.id }
        watchlist.removeAll { $0.id == movie.id }
        favorites.removeAll { $0.id == movie.id }
        saveMovies()
        saveWatchlist()
        saveFavorites()
    }
    
    func toggleFavorite(_ movie: MovieModel) {
        var updatedMovie = movie
        updatedMovie.isFavorite.toggle()
        updateMovie(updatedMovie)
        
        if updatedMovie.isFavorite {
            if !favorites.contains(where: { $0.id == movie.id }) {
                favorites.append(updatedMovie)
            }
        } else {
            favorites.removeAll { $0.id == movie.id }
        }
        saveFavorites()
    }
    
    func addToWatchlist(_ movie: MovieModel) {
        if !watchlist.contains(where: { $0.id == movie.id }) {
            watchlist.append(movie)
            saveWatchlist()
        }
    }
    
    func removeFromWatchlist(_ movie: MovieModel) {
        watchlist.removeAll { $0.id == movie.id }
        saveWatchlist()
    }
    
    func updateWatchProgress(_ movie: MovieModel, progress: Double) {
        var updatedMovie = movie
        updatedMovie.watchProgress = progress
        if progress >= 0.9 {
            updatedMovie.isWatched = true
            updatedMovie.watchedDate = Date()
        }
        updateMovie(updatedMovie)
    }
    
    // MARK: - Actor Management
    func addActor(_ actor: ActorModel) {
        actors.append(actor)
        saveActors()
    }
    
    func updateActor(_ actor: ActorModel) {
        if let index = actors.firstIndex(where: { $0.id == actor.id }) {
            actors[index] = actor
            saveActors()
        }
    }
    
    func deleteActor(_ actor: ActorModel) {
        actors.removeAll { $0.id == actor.id }
        saveActors()
    }
    
    func toggleActorFavorite(_ actor: ActorModel) {
        var updatedActor = actor
        updatedActor.isFavorite.toggle()
        updateActor(updatedActor)
    }
    
    // MARK: - Search and Filter
    func searchMovies(query: String) -> [MovieModel] {
        if query.isEmpty {
            return movies
        }
        return movies.filter { movie in
            movie.title.localizedCaseInsensitiveContains(query) ||
            movie.genre.localizedCaseInsensitiveContains(query) ||
            movie.director.localizedCaseInsensitiveContains(query) ||
            movie.cast.joined().localizedCaseInsensitiveContains(query)
        }
    }
    
    func filterMovies(by genre: String) -> [MovieModel] {
        if genre == "All" {
            return movies
        }
        return movies.filter { $0.categories.contains(genre) || $0.genre.contains(genre) }
    }
    
    func sortMovies(_ movies: [MovieModel], by option: AppEnvironmentManager.SortOption) -> [MovieModel] {
        switch option {
        case .title:
            return movies.sorted { $0.title < $1.title }
        case .rating:
            return movies.sorted { $0.rating > $1.rating }
        case .releaseDate:
            return movies.sorted { $0.releaseDate > $1.releaseDate }
        case .dateAdded:
            return movies // Assuming they're already in order of addition
        case .watchProgress:
            return movies.sorted { $0.watchProgress > $1.watchProgress }
        }
    }
    
    // MARK: - Statistics
    func getWatchedMoviesCount() -> Int {
        return movies.filter { $0.isWatched }.count
    }
    
    func getTotalWatchTime() -> String {
        let totalMinutes = movies.filter { $0.isWatched }.compactMap { movie in
            let components = movie.duration.components(separatedBy: CharacterSet.decimalDigits.inverted)
            let numbers = components.compactMap { Int($0) }
            return numbers.first
        }.reduce(0, +) * 60 // Assuming duration is in hours
        
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    func getFavoriteGenres() -> [String] {
        let allGenres = movies.flatMap { $0.categories }
        let genreCounts = Dictionary(grouping: allGenres, by: { $0 })
            .mapValues { $0.count }
        return genreCounts.sorted { $0.value > $1.value }.prefix(5).map { $0.key }
    }
    
    // MARK: - Data Persistence
    private func saveMovies() {
        print("Saving \(movies.count) movies to UserDefaults...")
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: moviesKey)
            print("Movies successfully saved to UserDefaults")
        } else {
            print("Failed to encode movies for saving")
        }
    }
    
    private func saveActors() {
        if let encoded = try? JSONEncoder().encode(actors) {
            UserDefaults.standard.set(encoded, forKey: actorsKey)
        }
    }
    
    private func saveWatchlist() {
        if let encoded = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(encoded, forKey: watchlistKey)
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadData() {
        print("Loading data from UserDefaults...")
        
        // Load movies
        if let savedMoviesData = UserDefaults.standard.data(forKey: moviesKey),
           let decodedMovies = try? JSONDecoder().decode([MovieModel].self, from: savedMoviesData) {
            movies = decodedMovies
            print("Loaded \(movies.count) movies from UserDefaults")
        } else {
            print("No saved movies found in UserDefaults")
        }
        
        // Load actors
        if let savedActorsData = UserDefaults.standard.data(forKey: actorsKey),
           let decodedActors = try? JSONDecoder().decode([ActorModel].self, from: savedActorsData) {
            actors = decodedActors
            print("Loaded \(actors.count) actors from UserDefaults")
        } else {
            print("No saved actors found in UserDefaults")
        }
        
        // Load watchlist
        if let savedWatchlistData = UserDefaults.standard.data(forKey: watchlistKey),
           let decodedWatchlist = try? JSONDecoder().decode([MovieModel].self, from: savedWatchlistData) {
            watchlist = decodedWatchlist
            print("Loaded \(watchlist.count) watchlist items from UserDefaults")
        } else {
            print("No saved watchlist found in UserDefaults")
        }
        
        // Load favorites
        if let savedFavoritesData = UserDefaults.standard.data(forKey: favoritesKey),
           let decodedFavorites = try? JSONDecoder().decode([MovieModel].self, from: savedFavoritesData) {
            favorites = decodedFavorites
            print("Loaded \(favorites.count) favorites from UserDefaults")
        } else {
            print("No saved favorites found in UserDefaults")
        }
    }
    
    // MARK: - Export/Import
    func exportData() -> Data? {
        let exportData = ExportData(
            movies: movies,
            actors: actors,
            watchlist: watchlist,
            favorites: favorites
        )
        return try? JSONEncoder().encode(exportData)
    }
    
    func importData(from data: Data) -> Bool {
        guard let exportData = try? JSONDecoder().decode(ExportData.self, from: data) else {
            return false
        }
        
        movies = exportData.movies
        actors = exportData.actors
        watchlist = exportData.watchlist
        favorites = exportData.favorites
        
        saveMovies()
        saveActors()
        saveWatchlist()
        saveFavorites()
        
        return true
    }
}

struct ExportData: Codable {
    let movies: [MovieModel]
    let actors: [ActorModel]
    let watchlist: [MovieModel]
    let favorites: [MovieModel]
}

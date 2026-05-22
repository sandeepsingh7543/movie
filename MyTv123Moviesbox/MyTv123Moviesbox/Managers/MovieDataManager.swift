//
//  MovieDataManager.swift
//  MyTv123Moviesbox
//
//  Enhanced Movie Data Manager
//

import Foundation
import SwiftUI

class MovieDataManager: ObservableObject {
    static let shared = MovieDataManager()
    
    @Published var movies: [MovieModel] = []
    @Published var favorites: [MovieModel] = []
    @Published var watchlist: [MovieModel] = []
    @Published var recentlyWatched: [MovieModel] = []
    @Published var trending: [MovieModel] = []
    @Published var searchResults: [MovieModel] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let moviesKey = "SavedMovies"
    private let favoritesKey = "SavedFavorites"
    private let watchlistKey = "SavedWatchlist"
    
    private init() {
        loadData()
        if movies.isEmpty {
            movies = MovieGenerator.generateSampleMovies()
            updateCollections()
            saveData()
        }
    }
    
    // MARK: - Data Management
    func addMovie(_ movie: MovieModel) {
        movies.append(movie)
        updateCollections()
        saveData()
    }
    
    func removeMovie(_ movie: MovieModel) {
        movies.removeAll { $0.id == movie.id }
        updateCollections()
        saveData()
    }
    
    func toggleFavorite(_ movie: MovieModel) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isFavorite.toggle()
            updateCollections()
            saveData()
        }
    }
    
    func addToWatchlist(_ movie: MovieModel) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            if !watchlist.contains(where: { $0.id == movie.id }) {
                watchlist.append(movies[index])
                saveData()
            }
        }
    }
    
    func removeFromWatchlist(_ movie: MovieModel) {
        watchlist.removeAll { $0.id == movie.id }
        saveData()
    }
    
    func markAsWatched(_ movie: MovieModel) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isWatched = true
            movies[index].watchedDate = Date()
            updateCollections()
            saveData()
        }
    }
    
    func updateWatchProgress(_ movie: MovieModel, progress: Double) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].watchProgress = progress
            updateCollections()
            saveData()
        }
    }
    
    // MARK: - Search & Filter
    func searchMovies(_ query: String) {
        if query.isEmpty {
            searchResults = []
        } else {
            searchResults = movies.filter { movie in
                movie.title.localizedCaseInsensitiveContains(query) ||
                movie.genre.localizedCaseInsensitiveContains(query) ||
                movie.director.localizedCaseInsensitiveContains(query) ||
                movie.cast.joined().localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    func filterMovies(by genre: String) -> [MovieModel] {
        return movies.filter { $0.genre.contains(genre) }
    }
    
    func filterMovies(by contentType: MovieModel.ContentType) -> [MovieModel] {
        return movies.filter { $0.contentType == contentType }
    }
    
    // MARK: - Collections Update
    private func updateCollections() {
        favorites = movies.filter { $0.isFavorite }
        recentlyWatched = movies.filter { $0.isWatched }
            .sorted { ($0.watchedDate ?? Date.distantPast) > ($1.watchedDate ?? Date.distantPast) }
            .prefix(10)
            .map { $0 }
        trending = movies.sorted { $0.trendingScore > $1.trendingScore }
            .prefix(20)
            .map { $0 }
    }
    
    // MARK: - Data Persistence
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(movies) {
            userDefaults.set(encoded, forKey: moviesKey)
        }
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
        if let encoded = try? JSONEncoder().encode(watchlist) {
            userDefaults.set(encoded, forKey: watchlistKey)
        }
    }
    
    private func loadData() {
        if let data = userDefaults.data(forKey: moviesKey),
           let decoded = try? JSONDecoder().decode([MovieModel].self, from: data) {
            movies = decoded
        }
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([MovieModel].self, from: data) {
            favorites = decoded
        }
        if let data = userDefaults.data(forKey: watchlistKey),
           let decoded = try? JSONDecoder().decode([MovieModel].self, from: data) {
            watchlist = decoded
        }
        updateCollections()
    }
}

//
//  MovieViewModel.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import Foundation
import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText = ""
    @Published var selectedGenre: MovieGenre?
    @Published var selectedStatus: WatchStatus?
    @Published var isDarkMode = true
    
    private let userDefaults = UserDefaults.standard
    private let moviesKey = "SavedMovies"
    private let darkModeKey = "DarkMode"
    
    init() {
        loadMovies()
        loadSettings()
        
        // Add demo data on first launch
        if movies.isEmpty {
            addDemoData()
        }
    }
    
    // MARK: - Movie Management
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveMovies()
    }
    
    func markAsViewed(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].lastViewed = Date()
            saveMovies()
        }
    }
    
    // MARK: - Smart Lists
    var watchTonightMovies: [Movie] {
        let planToWatch = movies.filter { $0.watchStatus == .planToWatch }
        return Array(planToWatch.shuffled().prefix(3))
    }
    
    var topRatedMovies: [Movie] {
        return movies.filter { $0.rating >= 8.0 }.sorted { $0.rating > $1.rating }
    }
    
    var recentlyAddedMovies: [Movie] {
        return movies.sorted { $0.dateAdded > $1.dateAdded }.prefix(5).map { $0 }
    }
    
    var forgottenMovies: [Movie] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return movies.filter { movie in
            if let lastViewed = movie.lastViewed {
                return lastViewed < thirtyDaysAgo
            } else {
                return movie.dateAdded < thirtyDaysAgo
            }
        }
    }
    
    // MARK: - Filtering
    var filteredMovies: [Movie] {
        var filtered = movies
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let genre = selectedGenre {
            filtered = filtered.filter { $0.genre == genre }
        }
        
        if let status = selectedStatus {
            filtered = filtered.filter { $0.watchStatus == status }
        }
        
        return filtered.sorted { $0.title < $1.title }
    }
    
    // MARK: - Statistics
    var totalMovies: Int {
        movies.count
    }
    
    var watchedCount: Int {
        movies.filter { $0.watchStatus == .completed }.count
    }
    
    var averageRating: Double {
        let completedMovies = movies.filter { $0.watchStatus == .completed }
        guard !completedMovies.isEmpty else { return 0.0 }
        let total = completedMovies.reduce(0.0) { $0 + $1.rating }
        return total / Double(completedMovies.count)
    }
    
    // MARK: - Mood Picker
    func getMoviesForMood(_ mood: Mood) -> [Movie] {
        switch mood {
        case .happy:
            return movies.filter { $0.genre == .comedy || $0.genre == .animation }
        case .sad:
            return movies.filter { $0.genre == .drama || $0.genre == .romance }
        case .action:
            return movies.filter { $0.genre == .action || $0.genre == .thriller || $0.genre == .adventure }
        case .chill:
            return movies.filter { $0.genre == .documentary || $0.genre == .fantasy }
        }
    }
    
    // MARK: - Data Persistence
    private func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            userDefaults.set(encoded, forKey: moviesKey)
        }
    }
    
    private func loadMovies() {
        if let data = userDefaults.data(forKey: moviesKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = decoded
        }
    }
    
    private func loadSettings() {
        // Default dark mode true if not set before
        if userDefaults.object(forKey: darkModeKey) == nil {
            isDarkMode = true
        } else {
            isDarkMode = userDefaults.bool(forKey: darkModeKey)
        }
    }
    
    func saveDarkMode() {
        userDefaults.set(isDarkMode, forKey: darkModeKey)
    }
    
    // MARK: - Backup & Restore
    func exportMovies() -> Data? {
        return try? JSONEncoder().encode(movies)
    }
    
    func importMovies(from data: Data) -> Bool {
        if let importedMovies = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = importedMovies
            saveMovies()
            return true
        }
        return false
    }
    
    func clearAllData() {
        movies.removeAll()
        saveMovies()
    }
    
    func restoreSampleData() {
        addDemoData()
    }
    
    // MARK: - Demo Data
    private func addDemoData() {
        let cal = Calendar.current
        func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
            cal.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
        }
        func daysAgo(_ days: Int) -> Date {
            cal.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        }
        
        var m1 = Movie(title: "The Dark Knight", genre: .action, rating: 9.5, watchStatus: .completed,
                       personalNotes: "Heath Ledger's Joker is unforgettable. Best superhero film ever made.",
                       releaseDate: date(2008, 7, 18))
        
        var m2 = Movie(title: "Inception", genre: .sciFi, rating: 9.0, watchStatus: .completed,
                       personalNotes: "Mind-bending story. The ending still makes me think.",
                       releaseDate: date(2010, 7, 16))
        
        var m3 = Movie(title: "The Shawshank Redemption", genre: .drama, rating: 9.8, watchStatus: .completed,
                       personalNotes: "A timeless story about hope and friendship.",
                       releaseDate: date(1994, 9, 23))
        m3.dateAdded = daysAgo(45)
        
        var m4 = Movie(title: "Parasite", genre: .thriller, rating: 8.8, watchStatus: .completed,
                       personalNotes: "Brilliant social commentary. Deserved every Oscar.",
                       releaseDate: date(2019, 5, 30))
        m4.dateAdded = daysAgo(60)
        
        var m5 = Movie(title: "Interstellar", genre: .sciFi, rating: 9.2, watchStatus: .completed,
                       personalNotes: "The docking scene and Hans Zimmer's score gave me chills.",
                       releaseDate: date(2014, 11, 7))
        
        var m6 = Movie(title: "Avengers: Endgame", genre: .action, rating: 8.5, watchStatus: .watching,
                       personalNotes: "Rewatching to catch all the callbacks to earlier films.",
                       releaseDate: date(2019, 4, 26))
        
        let m7 = Movie(title: "The Grand Budapest Hotel", genre: .comedy, rating: 8.3, watchStatus: .completed,
                       personalNotes: "Wes Anderson's visual style is unlike anything else.",
                       releaseDate: date(2014, 3, 28))
        
        let m8 = Movie(title: "Spirited Away", genre: .animation, rating: 9.1, watchStatus: .planToWatch,
                       personalNotes: "Everyone says this is a must-watch. Finally adding it.",
                       releaseDate: date(2001, 7, 20))
        
        let m9 = Movie(title: "Dune: Part Two", genre: .sciFi, rating: 8.7, watchStatus: .planToWatch,
                       personalNotes: "Loved Part One. Can't wait to see how the story continues.",
                       releaseDate: date(2024, 3, 1))
        
        let m10 = Movie(title: "Oppenheimer", genre: .drama, rating: 8.9, watchStatus: .completed,
                        personalNotes: "Cillian Murphy was phenomenal. The Trinity test scene was breathtaking.",
                        releaseDate: date(2023, 7, 21))
        
        movies = [m1, m2, m3, m4, m5, m6, m7, m8, m9, m10]
        saveMovies()
    }
}
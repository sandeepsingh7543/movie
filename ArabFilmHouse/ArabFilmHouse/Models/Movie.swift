import Foundation
import UIKit

struct CastMember: Identifiable, Codable {
    let id = UUID()
    let name: String
    let role: String
    let imageData: Data?
    
    init(name: String, role: String = "Actor", imageData: Data? = nil) {
        self.name = name
        self.role = role
        self.imageData = imageData
    }
}

struct Movie: Identifiable, Codable {
    let id = UUID()
    let title: String
    let year: String
    let genre: String
    let rating: Double
    let duration: String
    let description: String
    let posterImageData: Data?
    let cast: [CastMember]
    let director: String
    var isWatchlisted: Bool = false
    
    init(title: String, year: String, genre: String, rating: Double, duration: String, description: String, posterImageData: Data? = nil, cast: [CastMember], director: String) {
        self.title = title
        self.year = year
        self.genre = genre
        self.rating = rating
        self.duration = duration
        self.description = description
        self.posterImageData = posterImageData
        self.cast = cast
        self.director = director
        self.isWatchlisted = false
    }
}

class MovieStore: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var watchlist: [Movie] = []
    @Published var searchText = ""
    
    private let moviesKey = "SavedMovies"
    private let watchlistKey = "SavedWatchlist"
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        } else {
            return movies.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText) ||
                movie.genre.localizedCaseInsensitiveContains(searchText) ||
                movie.director.localizedCaseInsensitiveContains(searchText) ||
                movie.cast.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    func loadMovies() {
        if let data = UserDefaults.standard.data(forKey: moviesKey),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = decodedMovies
        }
        
        if let data = UserDefaults.standard.data(forKey: watchlistKey),
           let decodedWatchlist = try? JSONDecoder().decode([Movie].self, from: data) {
            watchlist = decodedWatchlist
        }
    }
    
    func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: moviesKey)
        }
        
        if let encoded = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(encoded, forKey: watchlistKey)
        }
    }
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMovies()
    }
    
    func toggleWatchlist(movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isWatchlisted.toggle()
            
            if movies[index].isWatchlisted {
                watchlist.append(movies[index])
            } else {
                watchlist.removeAll { $0.id == movie.id }
            }
            saveMovies()
        }
    }
}

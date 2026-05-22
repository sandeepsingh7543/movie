// LibraryViewModel.swift - User Movie Collection Manager

import SwiftUI
import Observation

@Observable
class LibraryViewModel {
    var movies: [Movie] = Movie.samples
    var searchText: String = ""
    var selectedFilter: WatchStatus? = nil
    
    var filteredMovies: [Movie] {
        var result = movies
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        if let filter = selectedFilter {
            result = result.filter { $0.watchStatus == filter }
        }
        return result
    }
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
    }
    
    func deleteMovie(at offsets: IndexSet) {
        movies.remove(atOffsets: offsets)
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
        }
    }
    
    var totalMovies: Int { movies.count }
    var watchedCount: Int { movies.filter { $0.watchStatus == .watched }.count }
    var averageRating: Double {
        let rated = movies.filter { $0.rating > 0 }
        guard !rated.isEmpty else { return 0 }
        return rated.reduce(0) { $0 + $1.rating } / Double(rated.count)
    }
}

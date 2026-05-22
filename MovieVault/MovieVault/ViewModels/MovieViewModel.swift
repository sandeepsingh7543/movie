import SwiftUI
import SwiftData

@Observable
final class MovieViewModel {
    var searchText = ""
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func filteredMovies() -> [Movie] {
        var descriptor = FetchDescriptor<Movie>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        if !searchText.isEmpty {
            descriptor.predicate = #Predicate { $0.title.localizedStandardContains(searchText) }
        }
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func watchlistMovies() -> [Movie] {
        let descriptor = FetchDescriptor<Movie>(
            predicate: #Predicate { $0.isInWatchlist },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func addMovie(title: String, desc: String, genre: String, releaseDate: Date, rating: Int, posterData: Data?) {
        let movie = Movie(title: title, desc: desc, genre: genre, releaseDate: releaseDate, rating: rating, posterData: posterData)
        modelContext.insert(movie)
        try? modelContext.save()
    }

    func toggleWatched(_ movie: Movie) {
        movie.isWatched.toggle()
        try? modelContext.save()
    }

    func toggleWatchlist(_ movie: Movie) {
        movie.isInWatchlist.toggle()
        try? modelContext.save()
    }

    func delete(_ movie: Movie) {
        modelContext.delete(movie)
        try? modelContext.save()
    }
}

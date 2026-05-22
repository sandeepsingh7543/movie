import SwiftUI
import CoreData

class MovieViewModel: ObservableObject {
    @Published var movies: [MovieEntity] = []

    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchMovies()
    }

    func fetchMovies() {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MovieEntity.dateAdded, ascending: false)]
        do {
            movies = try context.fetch(request)
        } catch {
            movies = []
        }
    }

    func addMovie(title: String, genre: String, duration: Int16, rating: Double, notes: String, watchProgress: Double, posterData: Data?, mood: String, isFavorite: Bool, collection: String) {
        let movie = MovieEntity(context: context)
        movie.id = UUID()
        movie.title = title
        movie.genre = genre
        movie.duration = duration
        movie.rating = rating
        movie.notes = notes
        movie.watchProgress = watchProgress
        movie.posterData = posterData
        movie.dateAdded = Date()
        movie.mood = mood
        movie.isFavorite = isFavorite
        movie.collection = collection
        save()
    }

    func updateMovie(_ entity: MovieEntity, title: String, genre: String, duration: Int16, rating: Double, notes: String, watchProgress: Double, posterData: Data?, mood: String, isFavorite: Bool, collection: String) {
        entity.title = title
        entity.genre = genre
        entity.duration = duration
        entity.rating = rating
        entity.notes = notes
        entity.watchProgress = watchProgress
        entity.posterData = posterData
        entity.mood = mood
        entity.isFavorite = isFavorite
        entity.collection = collection
        save()
    }

    func deleteMovie(_ entity: MovieEntity) {
        context.delete(entity)
        save()
    }

    func toggleFavorite(_ entity: MovieEntity) {
        entity.isFavorite.toggle()
        save()
    }

    func updateWatchProgress(_ entity: MovieEntity, progress: Double) {
        entity.watchProgress = progress
        entity.lastWatched = Date()
        save()
    }

    var favoriteMovies: [MovieEntity] {
        movies.filter { $0.isFavorite }
    }

    var recentlyAdded: [MovieEntity] {
        Array(movies.prefix(10))
    }

    var continueWatching: [MovieEntity] {
        movies.filter { $0.watchProgress > 0 && $0.watchProgress < 1.0 }
    }

    var topRated: [MovieEntity] {
        movies.filter { $0.rating >= 4.0 }
    }

    func moviesByMood(_ mood: String) -> [MovieEntity] {
        movies.filter { $0.mood == mood }
    }

    func moviesByCollection(_ collection: String) -> [MovieEntity] {
        movies.filter { $0.collection == collection }
    }

    func randomPick(mood: String? = nil) -> MovieEntity? {
        let pool = mood == nil ? movies : movies.filter { $0.mood == mood }
        return pool.randomElement()
    }

    private func save() {
        PersistenceController.shared.saveContext()
        fetchMovies()
    }
}

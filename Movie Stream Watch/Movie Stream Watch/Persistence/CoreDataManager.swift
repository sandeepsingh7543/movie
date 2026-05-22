import CoreData
import SwiftUI

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext { container.viewContext }

    @Published var movies: [Movie] = []

    private init() {
        container = NSPersistentContainer(name: "MovieModel")
        container.loadPersistentStores { _, error in
            if let error { fatalError("CoreData load failed: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        fetchAllMovies()
    }

    func save() {
        guard viewContext.hasChanges else { return }
        do { try viewContext.save() }
        catch { print("Save error: \(error)") }
    }

    // MARK: - CRUD

    func addMovie(title: String, genre: String, rating: Double, watchStatus: String = "Plan",
                  notes: String? = nil, externalLink: String? = nil, posterData: Data? = nil,
                  isFavorite: Bool = false, mood: String? = nil, watchTime: Int64 = 0,
                  contentType: String = "Movie", totalSeasons: Int16 = 0, totalEpisodes: Int16 = 0,
                  currentSeason: Int16 = 1, currentEpisode: Int16 = 0) {
        let movie = Movie(context: viewContext)
        movie.id = UUID()
        movie.title = title
        movie.genre = genre
        movie.rating = rating
        movie.watchStatus = watchStatus
        movie.notes = notes
        movie.externalLink = externalLink
        movie.posterData = posterData
        movie.dateAdded = Date()
        movie.isFavorite = isFavorite
        movie.watchProgress = 0.0
        movie.mood = mood
        movie.watchTime = watchTime
        movie.lastWatched = nil
        movie.contentType = contentType
        movie.totalSeasons = totalSeasons
        movie.totalEpisodes = totalEpisodes
        movie.currentSeason = currentSeason
        movie.currentEpisode = currentEpisode
        save()
        fetchAllMovies()
    }

    func updateMovie(_ movie: Movie) {
        save()
        fetchAllMovies()
    }

    func deleteMovie(_ movie: Movie) {
        viewContext.delete(movie)
        save()
        fetchAllMovies()
    }

    func fetchAllMovies() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.dateAdded, ascending: false)]
        do { movies = try viewContext.fetch(request) }
        catch { print("Fetch error: \(error)") }
    }

    // MARK: - Filtered Fetches

    func fetchMovies(by status: String) -> [Movie] {
        movies.filter { $0.watchStatus == status }
    }

    func fetchFavorites() -> [Movie] { movies.filter { $0.isFavorite } }
    func fetchByGenre(_ genre: String) -> [Movie] { movies.filter { $0.genre == genre } }
    func fetchByMood(_ mood: String) -> [Movie] { movies.filter { $0.mood == mood } }
    func randomMovie() -> Movie? { movies.randomElement() }

    // MARK: - Statistics

    var totalCount: Int { movies.count }
    var watchedCount: Int { movies.filter { $0.watchStatus == "Watched" || $0.watchStatus == "Completed" }.count }
    var movieCount: Int { movies.filter { ($0.contentType ?? "Movie") == "Movie" }.count }
    var seriesCount: Int { movies.filter { ($0.contentType ?? "Movie") == "Series" }.count }

    var totalEpisodesWatched: Int {
        movies.filter { ($0.contentType ?? "Movie") == "Series" }
            .reduce(0) { $0 + Int($1.currentEpisode) }
    }

    var favoriteGenre: String {
        Dictionary(grouping: movies, by: { $0.genre ?? "" })
            .max(by: { $0.value.count < $1.value.count })?.key ?? "N/A"
    }

    var totalWatchTime: Int64 { movies.reduce(0) { $0 + $1.watchTime } }
}

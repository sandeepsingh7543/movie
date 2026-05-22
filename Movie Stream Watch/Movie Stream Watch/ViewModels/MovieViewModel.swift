import SwiftUI
import CoreData

// MARK: - Enums

enum WatchStatus: String, CaseIterable {
    case all = "All"
    case plan = "Plan"
    case watching = "Watching"
    case watched = "Watched"
}

enum SortOption: String, CaseIterable {
    case dateAdded = "Date Added"
    case title = "Title"
    case rating = "Rating"
    case genre = "Genre"
}

enum ContentTypeFilter: String, CaseIterable {
    case all = "All"
    case movies = "Movies"
    case series = "Series"
}

// MARK: - ViewModel

class MovieViewModel: ObservableObject {
    private let manager = CoreDataManager.shared

    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var selectedFilter: WatchStatus = .all
    @Published var selectedSort: SortOption = .dateAdded
    @Published var selectedMood: String = ""
    @Published var selectedContentType: ContentTypeFilter = .all
    @Published var showingAddMovie: Bool = false
    @Published var featuredMovie: Movie? = nil

    init() {
        refreshMovies()
        pickFeaturedMovie()
    }

    // MARK: - Helpers

    private func isSeries(_ movie: Movie) -> Bool {
        (movie.contentType ?? "Movie") == "Series"
    }

    // MARK: - Computed: Filtered & Sorted

    var filteredMovies: [Movie] {
        var result = movies

        // Content type filter
        switch selectedContentType {
        case .movies: result = result.filter { !isSeries($0) }
        case .series: result = result.filter { isSeries($0) }
        case .all: break
        }

        // Watch status filter
        if selectedFilter != .all {
            let status = selectedFilter.rawValue
            result = result.filter { $0.watchStatus == status || ($0.watchStatus == "Completed" && status == "Watched") }
        }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                ($0.title ?? "").lowercased().contains(query) ||
                ($0.genre ?? "").lowercased().contains(query)
            }
        }

        if !selectedMood.isEmpty {
            result = result.filter { $0.mood == selectedMood }
        }

        switch selectedSort {
        case .dateAdded: result.sort { ($0.dateAdded ?? .distantPast) > ($1.dateAdded ?? .distantPast) }
        case .title: result.sort { ($0.title ?? "") < ($1.title ?? "") }
        case .rating: result.sort { $0.rating > $1.rating }
        case .genre: result.sort { ($0.genre ?? "") < ($1.genre ?? "") }
        }

        return result
    }

    var continueWatching: [Movie] {
        movies.filter { !isSeries($0) && $0.watchStatus == "Watching" && $0.watchProgress > 0 && $0.watchProgress < 1 }
    }

    var continueWatchingSeries: [Movie] {
        movies.filter { isSeries($0) && $0.watchStatus == "Watching" && $0.currentEpisode > 0 }
    }

    var recentlyAdded: [Movie] {
        Array(movies.sorted { ($0.dateAdded ?? .distantPast) > ($1.dateAdded ?? .distantPast) }.prefix(10))
    }

    var favorites: [Movie] { movies.filter { $0.isFavorite } }

    var trendingMovies: [Movie] {
        Array(movies.filter { $0.lastWatched != nil }
            .sorted { ($0.lastWatched ?? .distantPast) > ($1.lastWatched ?? .distantPast) }
            .prefix(10))
    }

    var watchedMovies: [Movie] {
        movies.filter { $0.watchStatus == "Watched" || $0.watchStatus == "Completed" }
    }

    var planToWatch: [Movie] { movies.filter { $0.watchStatus == "Plan" } }

    // MARK: - Stats

    var totalMovies: Int { movies.count }
    var movieCount: Int { manager.movieCount }
    var seriesCount: Int { manager.seriesCount }
    var watchedCount: Int { watchedMovies.count }
    var totalEpisodesWatched: Int { manager.totalEpisodesWatched }
    var favoriteGenre: String { manager.favoriteGenre }
    var totalWatchTimeHours: Int { Int(manager.totalWatchTime / 60) }

    var averageRating: Double {
        guard !movies.isEmpty else { return 0 }
        return movies.reduce(0) { $0 + $1.rating } / Double(movies.count)
    }

    var completionRate: Double {
        guard totalMovies > 0 else { return 0 }
        return Double(watchedCount) / Double(totalMovies) * 100
    }

    var achievements: [(icon: String, title: String, description: String, unlocked: Bool)] {
        [
            ("🎬", "First Watch", "Watch your first title", watchedCount >= 1),
            ("🔟", "Ten Down", "Watch 10 titles", watchedCount >= 10),
            ("⭐", "Critic", "Rate 5 titles", movies.filter { $0.rating > 0 }.count >= 5),
            ("❤️", "Collector", "Add 25 titles", totalMovies >= 25),
            ("🏆", "Binge Master", "Watch 50 titles", watchedCount >= 50),
            ("📺", "Series Fan", "Add 5 series", seriesCount >= 5),
            ("⏱️", "Marathon", "Log 24+ hours watch time", totalWatchTimeHours >= 24),
            ("🌟", "Favorite Fan", "Have 10 favorites", favorites.count >= 10),
            ("🎭", "Genre Explorer", "Add titles in 5+ genres", Set(movies.compactMap { $0.genre }).count >= 5),
            ("🔥", "Episode Hunter", "Watch 50+ episodes", totalEpisodesWatched >= 50)
        ]
    }

    // MARK: - Methods

    func refreshMovies() {
        manager.fetchAllMovies()
        movies = manager.movies
    }

    func addMovie(title: String, genre: String, rating: Double, watchStatus: String = "Plan",
                  notes: String? = nil, externalLink: String? = nil, posterImage: UIImage? = nil,
                  mood: String? = nil, watchTime: Int64 = 0,
                  contentType: String = "Movie", totalSeasons: Int16 = 0, totalEpisodes: Int16 = 0,
                  currentSeason: Int16 = 1, currentEpisode: Int16 = 0) {
        manager.addMovie(title: title, genre: genre, rating: rating, watchStatus: watchStatus,
                         notes: notes, externalLink: externalLink,
                         posterData: posterImage?.jpegData(compressionQuality: 0.8),
                         mood: mood, watchTime: watchTime,
                         contentType: contentType, totalSeasons: totalSeasons,
                         totalEpisodes: totalEpisodes, currentSeason: currentSeason,
                         currentEpisode: currentEpisode)
        refreshMovies()
    }

    func updateMovie(_ movie: Movie, title: String, genre: String, rating: Double,
                     watchStatus: String, notes: String? = nil, externalLink: String? = nil,
                     posterImage: UIImage? = nil, mood: String? = nil, watchTime: Int64 = 0,
                     contentType: String = "Movie", totalSeasons: Int16 = 0, totalEpisodes: Int16 = 0,
                     currentSeason: Int16 = 1, currentEpisode: Int16 = 0) {
        movie.title = title
        movie.genre = genre
        movie.rating = rating
        movie.watchStatus = watchStatus
        movie.notes = notes
        movie.externalLink = externalLink
        if let img = posterImage { movie.posterData = img.jpegData(compressionQuality: 0.8) }
        movie.mood = mood
        movie.watchTime = watchTime
        movie.contentType = contentType
        movie.totalSeasons = totalSeasons
        movie.totalEpisodes = totalEpisodes
        movie.currentSeason = currentSeason
        movie.currentEpisode = currentEpisode
        if watchStatus == "Watching" || watchStatus == "Watched" || watchStatus == "Completed" {
            movie.lastWatched = Date()
        }
        manager.updateMovie(movie)
        refreshMovies()
    }

    func deleteMovie(_ movie: Movie) {
        manager.deleteMovie(movie)
        refreshMovies()
    }

    func toggleFavorite(_ movie: Movie) {
        movie.isFavorite.toggle()
        manager.updateMovie(movie)
        refreshMovies()
    }

    func updateProgress(_ movie: Movie, progress: Double) {
        movie.watchProgress = progress
        movie.lastWatched = Date()
        if progress >= 1.0 { movie.watchStatus = "Watched" }
        manager.updateMovie(movie)
        refreshMovies()
    }

    func updateSeriesProgress(_ movie: Movie, season: Int16, episode: Int16) {
        movie.currentSeason = season
        movie.currentEpisode = episode
        movie.lastWatched = Date()
        if movie.totalSeasons > 0 && season >= movie.totalSeasons &&
           movie.totalEpisodes > 0 && episode >= movie.totalEpisodes {
            movie.watchStatus = "Completed"
        }
        manager.updateMovie(movie)
        refreshMovies()
    }

    func randomPick() -> Movie? { planToWatch.randomElement() }

    func moodSuggestions(mood: String) -> [Movie] {
        movies.filter { $0.mood == mood }
    }

    func pickFeaturedMovie() {
        let pool = favorites.isEmpty ? recentlyAdded : favorites
        featuredMovie = pool.randomElement()
    }
}

import Foundation

// MARK: - Home ViewModel
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var moviesByCategory: [String: [SavedMovie]] = [:]
    @Published var featuredMovies: [SavedMovie] = []

    private let persistence = PersistenceManager.shared

    func loadAll() {
        // Show ALL manually added movies on home
        let all = persistence.fetchManualMovies()
        var dict: [String: [SavedMovie]] = [:]
        for movie in all {
            let cat = movie.manualCategory ?? "My Movies"
            dict[cat, default: []].append(movie)
        }
        moviesByCategory = dict
        featuredMovies = Array(all.prefix(5))
    }
}

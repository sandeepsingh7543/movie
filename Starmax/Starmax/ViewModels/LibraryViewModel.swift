import SwiftUI

@MainActor
final class LibraryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var sortOption: MovieSortOption = .recent
    @Published var filterOption: MovieFilterOption = .all
    @Published var selectedCollectionName: String?

    func filteredMovies(from movies: [StarMovie]) -> [StarMovie] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        var results = movies.filter { movie in
            let matchesSearch = trimmedSearch.isEmpty || movie.title.localizedCaseInsensitiveContains(trimmedSearch) || movie.genre.localizedCaseInsensitiveContains(trimmedSearch) || movie.notes.localizedCaseInsensitiveContains(trimmedSearch) || movie.collectionNames.joined(separator: " ").localizedCaseInsensitiveContains(trimmedSearch)
            guard matchesSearch else { return false }

            switch filterOption {
            case .all:
                return true
            case .watched:
                return movie.status == .watched
            case .pending:
                return movie.status == .planToWatch
            case .favorites:
                return movie.isFavorite
            }
        }

        if let selectedCollectionName {
            results = results.filter { $0.collectionNames.contains(selectedCollectionName) }
        }

        switch sortOption {
        case .recent:
            results.sort { $0.updatedAt > $1.updatedAt }
        case .rating:
            results.sort {
                if $0.rating == $1.rating { return $0.updatedAt > $1.updatedAt }
                return $0.rating > $1.rating
            }
        case .title:
            results.sort { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        }

        return results
    }
}

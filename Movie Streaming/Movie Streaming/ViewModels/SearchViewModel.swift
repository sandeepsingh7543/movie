import Foundation

// MARK: - Search ViewModel (local SwiftData search)
@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [SavedMovie] = []
    @Published var hasSearched = false

    private let persistence = PersistenceManager.shared

    func onQueryChanged() {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            results = []
            hasSearched = false
            return
        }
        let all = persistence.fetchAllSaved()
        results = all.filter {
            $0.title.localizedCaseInsensitiveContains(trimmed) ||
            $0.overview.localizedCaseInsensitiveContains(trimmed) ||
            ($0.manualCategory ?? "").localizedCaseInsensitiveContains(trimmed)
        }
        hasSearched = true
    }
}

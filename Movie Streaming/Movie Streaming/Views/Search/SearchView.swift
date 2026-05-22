import SwiftUI

// MARK: - Search View (local only)
struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    searchBar
                    content
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Search")
                        .font(.appHeadline)
                        .foregroundColor(.white)
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundColor(.appSecondary)
            TextField("Search your movies...", text: $vm.query)
                .foregroundColor(.white)
                .tint(.appAccent)
                .focused($isFocused)
                .onChange(of: vm.query) { vm.onQueryChanged() }
                .submitLabel(.search)
            if !vm.query.isEmpty {
                Button {
                    vm.query = ""
                    vm.onQueryChanged()
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.appSecondary)
                }
            }
        }
        .padding(12)
        .background(Color.appSurface)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var content: some View {
        if vm.hasSearched && vm.results.isEmpty {
            EmptyStateView(
                icon: "film.slash",
                title: "No Results",
                subtitle: "No movies found for \"\(vm.query)\""
            )
            .frame(maxHeight: .infinity)
        } else if !vm.hasSearched {
            EmptyStateView(
                icon: "magnifyingglass",
                title: "Search Movies",
                subtitle: "Search by title, category, or description"
            )
            .frame(maxHeight: .infinity)
        } else {
            resultsGrid
        }
    }

    private var resultsGrid: some View {
        let columns = [GridItem(.adaptive(minimum: 110), spacing: 12)]
        return ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(vm.results) { saved in
                    NavigationLink(destination: MovieDetailView(movie: saved.toMovie())) {
                        SavedMovieCard(saved: saved)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
    }
}

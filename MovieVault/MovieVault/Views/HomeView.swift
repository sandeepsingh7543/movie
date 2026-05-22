import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var vm: MovieViewModel?
    @State private var searchText = ""
    @State private var showAdd = false
    @Query(sort: \Movie.createdAt, order: .reverse) private var allMovies: [Movie]

    let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    private var movies: [Movie] {
        guard !searchText.isEmpty else { return allMovies }
        return allMovies.filter { $0.title.localizedStandardContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Search
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.textSecondary)
                            TextField("Search movies...", text: $searchText)
                                .foregroundColor(Theme.textPrimary)
                                .tint(Theme.accent)
                        }
                        .padding(12)
                        .background(Theme.glass)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.glassBorder, lineWidth: 0.5))
                        .padding(.horizontal)

                        if movies.isEmpty {
                            EmptyStateView(
                                icon: "film.stack",
                                title: searchText.isEmpty ? "Your vault is empty" : "No results found",
                                subtitle: searchText.isEmpty ? "Tap + to add your first movie" : "Try a different search term"
                            )
                            .padding(.top, 60)
                        } else {
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(movies) { movie in
                                    if let vm {
                                        NavigationLink(destination: MovieDetailView(movie: movie, vm: vm)) {
                                            MovieCard(movie: movie)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("MovieVault")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Theme.accent)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddMovieView(vm: MovieViewModel(modelContext: modelContext))
            }
        }
        .task {
            if vm == nil { vm = MovieViewModel(modelContext: modelContext) }
        }
        .preferredColorScheme(.dark)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(Theme.textSecondary.opacity(0.5))
            Text(title)
                .font(.title3).fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

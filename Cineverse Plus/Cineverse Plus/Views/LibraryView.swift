import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var vm: MovieViewModel
    @State private var showAddMovie = false
    @State private var searchText = ""

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var filteredMovies: [MovieEntity] {
        searchText.isEmpty ? vm.movies : vm.movies.filter {
            ($0.title ?? "").localizedCaseInsensitiveContains(searchText) ||
            ($0.genre ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if vm.movies.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredMovies, id: \.objectID) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieCard(
                                    title: movie.title ?? "Untitled",
                                    posterData: movie.posterData,
                                    rating: movie.rating,
                                    progress: movie.watchProgress
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button { vm.toggleFavorite(movie) } label: {
                                    Label(movie.isFavorite ? "Unfavorite" : "Favorite",
                                          systemImage: movie.isFavorite ? "heart.slash" : "heart.fill")
                                }
                                Button(role: .destructive) { vm.deleteMovie(movie) } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(CineverseTheme.deepBlack)
            .navigationTitle("Library")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Search movies...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAddMovie = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(CineverseTheme.neonPurple)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAddMovie) {
                AddMovieView()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 100)
            Image(systemName: "popcorn")
                .font(.system(size: 60))
                .foregroundColor(CineverseTheme.neonPurple)
            Text("No Movies Yet")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text("Tap + to add your first movie")
                .foregroundColor(CineverseTheme.lightGray)
            Button { showAddMovie = true } label: {
                Text("Add Movie")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(CineverseTheme.purpleBlueGradient)
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

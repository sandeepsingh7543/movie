import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var viewModel: MovieViewModel
    @State private var editingMovie: Movie?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.appBackground.ignoresSafeArea()

            if viewModel.filteredMovies.isEmpty && viewModel.movies.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        searchBar
                        contentTypeChips
                        filterChips
                        sortPicker

                        if viewModel.filteredMovies.isEmpty {
                            Text("No results match your filters")
                                .foregroundColor(.textGray)
                                .padding(.top, 40)
                        } else {
                            movieGrid
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 80)
                }
            }

            addButton
        }
        .navigationTitle("Watchlist")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $viewModel.showingAddMovie) {
            AddMovieView()
        }
        .sheet(item: $editingMovie) { movie in
            AddMovieView(movie: movie)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textGray)
            TextField("Search movies & series...", text: $viewModel.searchText)
                .foregroundColor(.white)
        }
        .padding(12)
        .background(Color.surfaceColor)
        .cornerRadius(12)
    }

    // MARK: - Content Type Chips

    private var contentTypeChips: some View {
        HStack(spacing: 10) {
            ForEach(ContentTypeFilter.allCases, id: \.self) { type in
                Button {
                    viewModel.selectedContentType = type
                } label: {
                    Text(type.rawValue)
                        .font(.appCaption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.selectedContentType == type
                                ? AnyShapeStyle(Color.primaryGradient)
                                : AnyShapeStyle(Color.cardBackground)
                        )
                        .clipShape(Capsule())
                }
            }
            Spacer()
        }
    }

    // MARK: - Filter Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(WatchStatus.allCases, id: \.self) { status in
                    Button {
                        viewModel.selectedFilter = status
                    } label: {
                        Text(status.rawValue)
                            .font(.appCaption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedFilter == status
                                    ? AnyShapeStyle(Color.appSecondary)
                                    : AnyShapeStyle(Color.cardBackground)
                            )
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    // MARK: - Sort Picker

    private var sortPicker: some View {
        HStack {
            Text("Sort by")
                .font(.appCaption)
                .foregroundColor(.textGray)
            Picker("Sort", selection: $viewModel.selectedSort) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(.appPrimary)
            Spacer()
        }
    }

    // MARK: - Movie Grid

    private var movieGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.filteredMovies, id: \.objectID) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    gridItem(movie)
                }
                .contextMenu {
                    Button { editingMovie = movie } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button { viewModel.toggleFavorite(movie) } label: {
                        Label(movie.isFavorite ? "Unfavorite" : "Favorite",
                              systemImage: movie.isFavorite ? "heart.slash" : "heart")
                    }
                    Button(role: .destructive) { viewModel.deleteMovie(movie) } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }

    private func gridItem(_ movie: Movie) -> some View {
        let isSeries = (movie.contentType ?? "Movie") == "Series"
        return VStack(alignment: .leading, spacing: 6) {
            PosterImage(posterData: movie.posterData)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .topTrailing) {
                    if movie.rating > 0 {
                        Text(String(format: "%.1f", movie.rating))
                            .font(.appCaption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.appPrimary)
                            .cornerRadius(6)
                            .padding(6)
                    }
                }
                .overlay(alignment: .topLeading) {
                    if isSeries {
                        Text("SERIES")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color.appSecondary)
                            .cornerRadius(4)
                            .padding(6)
                    }
                }

            Text(movie.title ?? "")
                .font(.appCaption)
                .foregroundColor(.white)
                .lineLimit(1)

            HStack {
                GenrePill(genre: movie.genre ?? "")
                if isSeries && movie.currentEpisode > 0 {
                    Text("S\(movie.currentSeason) • E\(movie.currentEpisode)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.appSecondary)
                }
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.stack")
                .font(.system(size: 60))
                .foregroundColor(.textGray)
            Text("Your watchlist is empty")
                .font(.appSubtitle)
                .foregroundColor(.white)
            Text("Start tracking your favorite movies & series")
                .font(.appBody)
                .foregroundColor(.textGray)
            Button {
                viewModel.showingAddMovie = true
            } label: {
                Text("Add your first title")
                    .font(.appBody)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.primaryGradient)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            viewModel.showingAddMovie = true
        } label: {
            Image(systemName: "plus")
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.primaryGradient)
                .clipShape(Circle())
                .shadow(color: .appPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .padding(20)
    }
}

import SwiftUI
import SwiftData
import PhotosUI

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\StarMovie.updatedAt, order: .reverse)]) private var movies: [StarMovie]
    @Query(sort: [SortDescriptor(\MovieCollection.name, order: .forward)]) private var collections: [MovieCollection]
    @Environment(\.starmaxPalette) private var palette

    @StateObject private var viewModel = LibraryViewModel()
    @State private var showAddMovie = false
    @State private var editingMovie: StarMovie?
    @State private var detailMovie: StarMovie?
    @State private var showResetAlert = false

    private var filteredMovies: [StarMovie] {
        viewModel.filteredMovies(from: movies)
    }

    var body: some View {
        List {
            Section {
                header
                filterBar
                collectionBar
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            if filteredMovies.isEmpty {
                Section {
                    EmptyLibraryView(searchText: viewModel.searchText, filterOption: viewModel.filterOption)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            } else {
                Section {
                    ForEach(filteredMovies) { movie in
                        MovieCardRow(movie: movie)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                detailMovie = movie
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    delete(movie)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    editingMovie = movie
                                    showAddMovie = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 4)
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle("Starmax")
        .searchable(text: $viewModel.searchText, prompt: "Search movies, genres, notes")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editingMovie = nil
                    showAddMovie = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headline.weight(.semibold))
                }
            }
        }
        .sheet(isPresented: $showAddMovie, onDismiss: {
            editingMovie = nil
        }) {
            AddEditMovieView(movie: editingMovie, collections: collections) { draft, existingMovie in
                do {
                    _ = try DataManager.shared.upsertMovie(from: draft, editing: existingMovie, in: modelContext)
                } catch {
                    print("Failed to save movie: \(error)")
                }
            }
        }
        .sheet(item: $detailMovie) { movie in
            MovieDetailView(movie: movie, collections: collections)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your private film vault")
                        .font(.title.weight(.bold))
                        .foregroundStyle(palette.textPrimary)

                    Text("Offline-first, user-owned, and tailored to the way you actually watch movies.")
                        .font(.subheadline)
                        .foregroundStyle(palette.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button {
                    showAddMovie = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(palette.textPrimary)
                        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 8)
                }
            }

            HStack(spacing: 10) {
                statChip(title: "\(movies.count)", subtitle: "Movies")
                statChip(title: "\(movies.filter { $0.status == .watched }.count)", subtitle: "Watched")
                statChip(title: "\(collections.count)", subtitle: "Collections")
            }
        }
        .starmaxCard()
    }

    private func statChip(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(palette.textPrimary)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(palette.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(palette.chipFill, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var filterBar: some View {
        HStack(spacing: 10) {
            Menu {
                Picker("Sort", selection: $viewModel.sortOption) {
                    ForEach(MovieSortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                filterButtonLabel("Sort", systemImage: "arrow.up.arrow.down")
            }

            Menu {
                Picker("Filter", selection: $viewModel.filterOption) {
                    ForEach(MovieFilterOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                filterButtonLabel("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }

            if viewModel.selectedCollectionName != nil {
                Button("Clear collection") {
                    viewModel.selectedCollectionName = nil
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(palette.textPrimary)
            }
        }
    }

    private func filterButtonLabel(_ title: String, systemImage: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
            Text(title)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(palette.textPrimary)
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(palette.chipFill, in: Capsule(style: .continuous))
        .overlay(
            Capsule(style: .continuous)
                .strokeBorder(palette.surfaceStroke, lineWidth: 1)
        )
    }

    private var collectionBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                collectionPill(title: "All", isSelected: viewModel.selectedCollectionName == nil) {
                    viewModel.selectedCollectionName = nil
                }

                ForEach(collections) { collection in
                    collectionPill(
                        title: collection.name,
                        accentHex: collection.accentHex,
                        isSelected: viewModel.selectedCollectionName == collection.name
                    ) {
                        viewModel.selectedCollectionName = collection.name
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func collectionPill(
        title: String,
        accentHex: String? = nil,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color(hex: hexValue(from: accentHex)).opacity(isSelected ? 1 : 0.6))
                    .frame(width: 8, height: 8)
                Text(title)
                    .lineLimit(1)
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(palette.textPrimary)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? palette.textPrimary : palette.chipFill)
            )
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(palette.surfaceStroke.opacity(isSelected ? 0.18 : 1), lineWidth: 1)
            )
        }
    }

    private func hexValue(from accentHex: String?) -> UInt32 {
        guard let accentHex else { return 0x89C2FF }
        return UInt32(accentHex.replacingOccurrences(of: "#", with: ""), radix: 16) ?? 0x89C2FF
    }

    private func delete(_ movie: StarMovie) {
        do {
            try DataManager.shared.deleteMovie(movie, in: modelContext)
        } catch {
            print("Failed to delete movie: \(error)")
        }
    }
}

struct MovieCardRow: View {
    let movie: StarMovie
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        HStack(spacing: 14) {
            PosterView(posterPath: movie.posterPath, title: movie.title)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(movie.title)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(palette.textPrimary)
                            .lineLimit(2)

                        Text("\(movie.genre) • \(movie.releaseYear)")
                            .font(.subheadline)
                            .foregroundStyle(palette.textSecondary)
                    }

                    Spacer()

                    MovieStatusBadge(status: movie.status)
                }

                HStack(spacing: 10) {
                    RatingStarsView(rating: movie.rating)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(palette.textSecondary)
                }

                HStack(spacing: 8) {
                    MoodTagChip(mood: movie.moodTag)
                        .scaleEffect(0.88, anchor: .leading)

                    if movie.isFavorite {
                        Label("Favorite", systemImage: "star.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color(hex: 0xFFD166))
                    }
                }

                if !movie.collectionNames.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(movie.collectionNames, id: \.self) { name in
                                CollectionChip(name: name, accentHex: nil)
                            }
                        }
                    }
                    .frame(height: 24)
                }

                if !movie.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(movie.notes)
                        .font(.caption)
                        .foregroundStyle(palette.textSecondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(14)
        .starmaxCard()
        .padding(.vertical, 2)
    }
}

import SwiftUI

// MARK: - Watchlist View
struct WatchlistView: View {
    @StateObject private var vm = WatchlistViewModel()
    @State private var selectedTab = 0
    @State private var showAddMovie = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    segmentedControl
                    if selectedTab == 0 { categoryFilter }
                    tabContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Library").font(.appHeadline).foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { haptic(.medium); showAddMovie = true } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.appAccent)
                    }
                }
            }
            .sheet(isPresented: $showAddMovie) {
                AddMovieView { vm.refresh() }
            }
        }
        .onAppear { vm.refresh() }
    }

    // MARK: - Segmented Control
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(["Watchlist", "Favorites", "Recent"].indices, id: \.self) { i in
                Button {
                    haptic(.selection)
                    withAnimation(.spring(response: 0.3)) { selectedTab = i }
                } label: {
                    Text(["Watchlist", "Favorites", "Recent"][i])
                        .font(.system(size: 14, weight: selectedTab == i ? .semibold : .regular))
                        .foregroundColor(selectedTab == i ? .white : .appSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == i ? Color.appAccent : Color.clear)
                        .cornerRadius(8)
                }
            }
        }
        .padding(4)
        .background(Color.appSurface)
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Category Filter (Watchlist tab only)
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.allCategories, id: \.self) { cat in
                    Button {
                        haptic(.selection)
                        withAnimation(.spring(response: 0.3)) {
                            vm.selectedCategory = cat
                        }
                    } label: {
                        Text(cat)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(vm.selectedCategory == cat ? .white : .appSecondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(vm.selectedCategory == cat ? Color.appAccent : Color.appSurface)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }

    // MARK: - Tab Content
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case 0:
            savedMovieGrid(
                movies: vm.filteredWatchlist,
                emptyIcon: "bookmark.slash",
                emptyTitle: "Watchlist Empty",
                emptySub: "Tap + to add movies manually"
            )
        case 1:
            savedMovieGrid(
                movies: vm.favorites,
                emptyIcon: "heart.slash",
                emptyTitle: "No Favorites",
                emptySub: "Mark movies as favorites"
            )
        default:
            savedMovieGrid(
                movies: vm.recentlyViewed,
                emptyIcon: "clock.badge.xmark",
                emptyTitle: "Nothing Viewed",
                emptySub: "Movies you open will appear here"
            )
        }
    }

    // MARK: - Grid
    private func savedMovieGrid(movies: [SavedMovie], emptyIcon: String, emptyTitle: String, emptySub: String) -> some View {
        Group {
            if movies.isEmpty {
                EmptyStateView(icon: emptyIcon, title: emptyTitle, subtitle: emptySub)
                    .frame(maxHeight: .infinity)
            } else {
                let columns = [GridItem(.adaptive(minimum: 110), spacing: 12)]
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(movies) { saved in
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
    }
}

// MARK: - Saved Movie Card
struct SavedMovieCard: View {
    let saved: SavedMovie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                posterView

                if let cat = saved.manualCategory {
                    Text(cat)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5).padding(.vertical, 3)
                        .background(Color.appAccent).cornerRadius(5)
                        .padding(5)
                }
            }
            Text(saved.title)
                .font(.appCaption).foregroundColor(.white)
                .lineLimit(2).frame(width: 110, alignment: .leading)
        }
        .pressEffect()
    }

    @ViewBuilder
    private var posterView: some View {
        PosterImageView(url: saved.posterURL, width: 110, height: 165)
            .cornerRadius(10)
    }
}

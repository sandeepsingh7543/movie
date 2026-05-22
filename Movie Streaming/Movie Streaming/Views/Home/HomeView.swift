import SwiftUI

// MARK: - Home View
struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var showAddMovie = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                if vm.moviesByCategory.isEmpty {
                    emptyState
                } else {
                    content
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { logoToolbar }
            .sheet(isPresented: $showAddMovie, onDismiss: { vm.loadAll() }) {
                AddMovieView { vm.loadAll() }
            }
        }
        .onAppear { vm.loadAll() }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "film.stack")
                .font(.system(size: 64))
                .foregroundColor(.appAccent.opacity(0.6))
            Text("No Movies Yet").font(.appTitle).foregroundColor(.white)
            Text("Tap + to add your first movie").font(.appBody).foregroundColor(.appSecondary)
            Button { haptic(.medium); showAddMovie = true } label: {
                Label("Add Movie", systemImage: "plus.circle.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28).padding(.vertical, 13)
                    .background(Color.appAccent).cornerRadius(25)
            }
            .pressEffect()
        }
    }

    private var content: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 28) {
                if vm.featuredMovies.count > 1 {
                    LocalFeaturedBanner(movies: vm.featuredMovies)
                }
                ForEach(vm.moviesByCategory.keys.sorted(), id: \.self) { cat in
                    if let movies = vm.moviesByCategory[cat], !movies.isEmpty {
                        LocalMovieRow(title: cat, movies: movies)
                    }
                }
                Spacer(minLength: 20)
            }
        }
        .refreshable { vm.loadAll() }
    }

    @ToolbarContentBuilder
    private var logoToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("CINEMAX")
                .font(.system(size: 22, weight: .black))
                .foregroundColor(.appAccent).kerning(2)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { haptic(.medium); showAddMovie = true } label: {
                Image(systemName: "plus")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.appAccent)
            }
        }
    }
}

// MARK: - Local Movie Row
struct LocalMovieRow: View {
    let title: String
    let movies: [SavedMovie]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.appHeadline).foregroundColor(.white).padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies) { saved in
                        NavigationLink(destination: MovieDetailView(movie: saved.toMovie())) {
                            LocalMovieCard(saved: saved)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Local Movie Card
struct LocalMovieCard: View {
    let saved: SavedMovie
    var width: CGFloat = 120
    var height: CGFloat = 180

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .bottomLeading) {
                PosterImageView(url: saved.posterURL, width: width, height: height)
                    .cornerRadius(10)
                HStack(spacing: 3) {
                    Image(systemName: "star.fill").font(.system(size: 9)).foregroundColor(.appGold)
                    Text(String(format: "%.1f", saved.voteAverage))
                        .font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                }
                .padding(.horizontal, 6).padding(.vertical, 3)
                .background(.ultraThinMaterial).cornerRadius(6).padding(6)
            }
            Text(saved.title)
                .font(.appCaption).foregroundColor(.white)
                .lineLimit(2).frame(width: width, alignment: .leading)
        }
        .pressEffect()
    }
}

// MARK: - Local Featured Banner
struct LocalFeaturedBanner: View {
    let movies: [SavedMovie]
    @State private var currentIndex = 0
    @State private var timer: Timer?

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(movies.enumerated()), id: \.offset) { index, movie in
                LocalBannerSlide(movie: movie).tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 420)
        .overlay(alignment: .bottom) {
            HStack(spacing: 6) {
                ForEach(0..<movies.count, id: \.self) { i in
                    Capsule()
                        .fill(i == currentIndex ? Color.appAccent : Color.white.opacity(0.4))
                        .frame(width: i == currentIndex ? 20 : 6, height: 6)
                        .animation(.spring(response: 0.3), value: currentIndex)
                }
            }
            .padding(.bottom, 16)
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % movies.count
            }
        }
    }
    private func stopTimer() { timer?.invalidate(); timer = nil }
}

// MARK: - Local Banner Slide
struct LocalBannerSlide: View {
    let movie: SavedMovie

    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie.toMovie())) {
            ZStack(alignment: .bottom) {
                PosterImageView(url: movie.posterURL, width: UIScreen.main.bounds.width, height: 420)

                LinearGradient(
                    colors: [.clear, .appBackground.opacity(0.7), .appBackground],
                    startPoint: .top, endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title)
                        .font(.appTitle).foregroundColor(.white).lineLimit(2)
                    HStack(spacing: 12) {
                        Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                            .font(.appCaption).foregroundColor(.appGold)
                        Text(movie.releaseYear).font(.appCaption).foregroundColor(.appSecondary)
                        if let cat = movie.manualCategory {
                            Text(cat)
                                .font(.system(size: 11, weight: .medium)).foregroundColor(.white)
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(Color.appAccent).cornerRadius(5)
                        }
                    }
                    Label("More Info", systemImage: "info.circle")
                        .font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                        .padding(.horizontal, 20).padding(.vertical, 10)
                        .background(Color.white.opacity(0.2)).cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20).padding(.bottom, 40)
            }
        }
        .buttonStyle(.plain)
    }
}

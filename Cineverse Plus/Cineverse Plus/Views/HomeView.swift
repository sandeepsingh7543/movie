import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: MovieViewModel
    @State private var showCinematicMode = false
    @State private var cinematicMovie: MovieEntity?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Hero Banner
                    if let hero = vm.recentlyAdded.first {
                        HeroMovieCard(
                            title: hero.title ?? "Untitled",
                            posterData: hero.posterData,
                            genre: hero.genre ?? "",
                            rating: hero.rating
                        )
                        .onTapGesture {
                            cinematicMovie = hero
                            showCinematicMode = true
                        }
                        .padding(.horizontal)
                        .fadeIn(delay: 0.1)
                    } else {
                        // Empty state hero
                        ZStack {
                            CineverseTheme.purpleBlueGradient
                            VStack(spacing: 12) {
                                Image(systemName: "film.stack")
                                    .font(.system(size: 50))
                                Text("Your Cinema Awaits")
                                    .font(.title2.bold())
                                Text("Add movies to your library to get started")
                                    .font(.subheadline)
                                    .foregroundColor(CineverseTheme.lightGray)
                            }
                            .foregroundColor(.white)
                        }
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }

                    // Continue Watching
                    if !vm.continueWatching.isEmpty {
                        movieSection("Continue Watching", movies: vm.continueWatching)
                    }

                    // Recently Added
                    if !vm.recentlyAdded.isEmpty {
                        movieSection("Recently Added", movies: vm.recentlyAdded)
                    }

                    // Top Rated
                    if !vm.topRated.isEmpty {
                        movieSection("Top Rated", movies: vm.topRated)
                    }

                    // Favorites
                    if !vm.favoriteMovies.isEmpty {
                        movieSection("Favorites", movies: vm.favoriteMovies)
                    }

                    // Disclaimer
                    Text("This app does not stream movies. It helps you organize and manage your personal movie collection.")
                        .font(.caption2)
                        .foregroundColor(CineverseTheme.lightGray)
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
            }
            .background(CineverseTheme.deepBlack)
            .navigationTitle("Cineverse")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .fullScreenCover(isPresented: $showCinematicMode) {
                if let movie = cinematicMovie {
                    CinematicModeView(movie: movie)
                }
            }
        }
    }

    @ViewBuilder
    private func movieSection(_ title: String, movies: [MovieEntity]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies, id: \.objectID) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieCard(
                                title: movie.title ?? "Untitled",
                                posterData: movie.posterData,
                                rating: movie.rating,
                                progress: movie.watchProgress
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
        .fadeIn(delay: 0.2)
    }
}

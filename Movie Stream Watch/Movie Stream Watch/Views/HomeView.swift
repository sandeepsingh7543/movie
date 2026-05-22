import SwiftUI

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    let emoji: String

    var body: some View {
        Text("\(emoji) \(title)")
            .font(.appSubtitle)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
}

// MARK: - Home View

struct HomeView: View {
    @EnvironmentObject var viewModel: MovieViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                CinematicBanner(movie: viewModel.featuredMovie)
                    .ignoresSafeArea(edges: .top)

                if !viewModel.continueWatching.isEmpty {
                    movieSection(title: "Continue Watching", emoji: "🔥",
                                 movies: viewModel.continueWatching, size: .medium)
                }

                if !viewModel.continueWatchingSeries.isEmpty {
                    movieSection(title: "Continue Watching Series", emoji: "📺",
                                 movies: viewModel.continueWatchingSeries, size: .medium)
                }

                movieSection(title: "Recently Added", emoji: "✨",
                             movies: viewModel.recentlyAdded, size: .small)

                if !viewModel.favorites.isEmpty {
                    movieSection(title: "Your Favorites", emoji: "❤️",
                                 movies: viewModel.favorites, size: .medium)
                }

                if !viewModel.trendingMovies.isEmpty {
                    movieSection(title: "Trending For You", emoji: "🔥",
                                 movies: viewModel.trendingMovies, size: .small)
                }

                Text("This app does not host or stream movies or TV shows. It is designed to help users manage and track their personal watchlist.")
                    .font(.appCaption)
                    .foregroundColor(.textGray)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 24)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.refreshMovies()
            viewModel.pickFeaturedMovie()
        }
    }

    @ViewBuilder
    private func movieSection(title: String, emoji: String, movies: [Movie], size: MovieCard.CardSize) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title, emoji: emoji)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies, id: \.objectID) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieCard(movie: movie, size: size)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

import SwiftUI
import SwiftData

struct DiscoverView: View {
    @Query(sort: [SortDescriptor(\StarMovie.updatedAt, order: .reverse)]) private var movies: [StarMovie]
    @Query(sort: [SortDescriptor(\MovieCollection.name, order: .forward)]) private var collections: [MovieCollection]
    @Environment(\.starmaxPalette) private var palette

    @StateObject private var viewModel = DiscoverViewModel()
    @State private var selectedMovie: StarMovie?
    @State private var surpriseTrigger = false
    @State private var heroIndex = 0

    private var suggestionMovies: [StarMovie] {
        [
            viewModel.highestRatedMovie(from: movies),
            viewModel.leastWatchedGenreMovie(from: movies),
            viewModel.surprisePick(from: movies)
        ].compactMap { $0 }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header
                heroCard
                promptCard
                suggestionsSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, collections: collections)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What should I watch?")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(palette.textPrimary)

            Text("Starmax makes suggestions from your own local library, no external API required.")
                .font(.subheadline)
                .foregroundStyle(palette.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .starmaxCard()
    }

    private var heroCard: some View {
        Group {
            if let featured = suggestionMovies.indices.contains(heroIndex) ? suggestionMovies[heroIndex] : suggestionMovies.first {
                Button {
                    selectedMovie = featured
                } label: {
                    VStack(alignment: .leading, spacing: 16) {
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(palette.chipFill)
                                .frame(height: 320)
                                .overlay(
                                    ZStack {
                                        PosterView(posterPath: featured.posterPath, title: featured.title)
                                            .scaleEffect(2.35)
                                            .opacity(0.18)

                                        LinearGradient(colors: [.clear, Color.black.opacity(0.45)], startPoint: .top, endPoint: .bottom)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                            VStack(alignment: .leading, spacing: 10) {
                                MovieStatusBadge(status: featured.status)
                                Text(featured.title)
                                    .font(.title.weight(.bold))
                                    .foregroundStyle(palette.textPrimary)
                                    .lineLimit(2)
                                Text("\(featured.genre) • \(featured.releaseYear)")
                                    .foregroundStyle(palette.textSecondary)
                                RatingStarsView(rating: featured.rating, size: 14)
                            }
                            .padding(20)
                        }

                        HStack {
                            Label("Tap for details", systemImage: "play.circle.fill")
                                .font(.callout.weight(.semibold))
                            Spacer()
                            Text("Featured pick")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(palette.textSecondary)
                        }
                        .foregroundStyle(palette.textPrimary)
                    }
                    .starmaxCard()
                }
                .buttonStyle(.plain)
            } else {
                EmptyDiscoverView()
            }
        }
    }

    private var promptCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("Smart Prompt", subtitle: "Built only from your local library data.")
            Text(viewModel.randomWatchPrompt(from: movies))
                .foregroundStyle(palette.textPrimary)

            Button {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                    heroIndex = suggestionMovies.isEmpty ? 0 : Int.random(in: 0..<suggestionMovies.count)
                    surpriseTrigger.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Surprise Me")
                    Spacer()
                    Image(systemName: surpriseTrigger ? "arrow.clockwise" : "wand.and.stars")
                }
                .foregroundStyle(.black)
                .font(.headline.weight(.semibold))
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(Color.white, in: Capsule(style: .continuous))
            }
        }
        .starmaxCard()
    }

    private var suggestionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            PremiumSectionHeader("Suggestions", subtitle: "Highest rated, least watched genre, and random picks.")

            if suggestionMovies.isEmpty {
                Text("Add a few movies and Starmax will generate curated suggestions here.")
                    .foregroundStyle(palette.textSecondary)
                    .starmaxCard()
            } else {
                ForEach(suggestionMovies) { movie in
                    Button {
                        selectedMovie = movie
                    } label: {
                        HStack(spacing: 14) {
                            PosterView(posterPath: movie.posterPath, title: movie.title)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(movie.title)
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(palette.textPrimary)
                                Text(movie.genre)
                                    .foregroundStyle(palette.textSecondary)
                                HStack(spacing: 8) {
                                    RatingStarsView(rating: movie.rating, size: 11)
                                    Text(String(format: "%.1f", movie.rating))
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(palette.textSecondary)
                                }
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(palette.textMuted)
                        }
                        .padding(14)
                        .starmaxCard()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct EmptyDiscoverView: View {
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles.tv")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(palette.textPrimary)
            Text("Discover becomes useful once you add movies.")
                .font(.headline.weight(.semibold))
                .foregroundStyle(palette.textPrimary)
            Text("It will then surface smart picks based on ratings, genres, and watch history from your offline library.")
                .font(.subheadline)
                .foregroundStyle(palette.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 18)
        .starmaxCard()
    }
}

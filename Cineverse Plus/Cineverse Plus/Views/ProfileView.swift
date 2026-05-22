import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: MovieViewModel

    private var totalMovies: Int { vm.movies.count }
    private var watchedCount: Int { vm.movies.filter { $0.watchProgress >= 1.0 }.count }
    private var inProgressCount: Int { vm.continueWatching.count }
    private var totalWatchTime: Int { vm.movies.reduce(0) { $0 + Int($1.duration) } }

    private var topGenre: String {
        let genres = vm.movies.compactMap(\.genre).filter { !$0.isEmpty }
        let counts = Dictionary(grouping: genres, by: { $0 }).mapValues(\.count)
        return counts.max(by: { $0.value < $1.value })?.key ?? "—"
    }

    private var avgRating: Double {
        guard !vm.movies.isEmpty else { return 0 }
        return vm.movies.reduce(0) { $0 + $1.rating } / Double(vm.movies.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(CineverseTheme.purpleBlueGradient)
                                .frame(width: 80, height: 80)
                            Image(systemName: "person.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                        }
                        Text("Movie Enthusiast")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        Text("\(totalMovies) movies in collection")
                            .foregroundColor(CineverseTheme.lightGray)
                    }
                    .padding(.top, 8)

                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        statCard(icon: "film.stack", title: "Total", value: "\(totalMovies)")
                        statCard(icon: "checkmark.circle", title: "Watched", value: "\(watchedCount)")
                        statCard(icon: "play.circle", title: "In Progress", value: "\(inProgressCount)")
                        statCard(icon: "clock", title: "Total Time", value: Int16(min(totalWatchTime, Int(Int16.max))).durationFormatted)
                        statCard(icon: "star.fill", title: "Avg Rating", value: String(format: "%.1f", avgRating))
                        statCard(icon: "heart.fill", title: "Favorites", value: "\(vm.favoriteMovies.count)")
                    }
                    .padding(.horizontal)

                    // Top Genre
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                        Text("Top Genre:")
                            .foregroundColor(CineverseTheme.lightGray)
                        Text(topGenre)
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .glassMorphism()
                    .padding(.horizontal)

                    // Achievements
                    SectionHeader(title: "Achievements")
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        achievementRow("🎬", "First Movie", "Add your first movie", totalMovies >= 1)
                        achievementRow("🎞️", "Collector", "Add 10 movies", totalMovies >= 10)
                        achievementRow("⭐", "Critic", "Rate 5 movies", vm.movies.filter { $0.rating > 0 }.count >= 5)
                        achievementRow("❤️", "Fan", "Favorite 3 movies", vm.favoriteMovies.count >= 3)
                        achievementRow("👀", "Binge Watcher", "Watch 5 movies fully", watchedCount >= 5)
                        achievementRow("🏆", "Cinema Master", "Add 25 movies", totalMovies >= 25)
                    }
                    .padding(.horizontal)

                    // Genre Breakdown
                    if !vm.movies.isEmpty {
                        SectionHeader(title: "Genre Breakdown")
                            .padding(.horizontal)

                        let genreCounts = Dictionary(grouping: vm.movies.compactMap(\.genre), by: { $0 })
                            .mapValues(\.count)
                            .sorted { $0.value > $1.value }

                        VStack(spacing: 8) {
                            ForEach(genreCounts.prefix(5), id: \.key) { genre, count in
                                HStack {
                                    Text(genre)
                                        .foregroundColor(.white)
                                    Spacer()
                                    GeometryReader { geo in
                                        CineverseTheme.purpleBlueGradient
                                            .frame(width: geo.size.width * CGFloat(count) / CGFloat(totalMovies))
                                            .clipShape(Capsule())
                                    }
                                    .frame(width: 120, height: 8)
                                    Text("\(count)")
                                        .font(.caption)
                                        .foregroundColor(CineverseTheme.lightGray)
                                        .frame(width: 24, alignment: .trailing)
                                }
                            }
                        }
                        .padding()
                        .glassMorphism()
                        .padding(.horizontal)
                    }

                    // Disclaimer
                    Text("This app does not stream movies. It helps you organize and manage your personal movie collection.")
                        .font(.caption2)
                        .foregroundColor(CineverseTheme.lightGray)
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer(minLength: 40)
                }
            }
            .background(CineverseTheme.deepBlack)
            .navigationTitle("Profile")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private func statCard(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(CineverseTheme.neonPurple)
            Text(value)
                .font(.title2.bold())
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(CineverseTheme.lightGray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassMorphism()
    }

    private func achievementRow(_ emoji: String, _ title: String, _ desc: String, _ unlocked: Bool) -> some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.title2)
                .grayscale(unlocked ? 0 : 1)
                .opacity(unlocked ? 1 : 0.4)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(unlocked ? .white : CineverseTheme.lightGray)
                Text(desc)
                    .font(.caption)
                    .foregroundColor(CineverseTheme.lightGray)
            }
            Spacer()
            if unlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(CineverseTheme.neonPurple)
            }
        }
        .padding()
        .glassMorphism()
    }
}

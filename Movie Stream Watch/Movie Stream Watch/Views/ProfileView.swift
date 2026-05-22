import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: MovieViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                statsSection
                favoriteGenreSection
                achievementsSection
                settingsSection
                disclaimerSection
            }
            .padding()
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.appPrimary, .appSecondary],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 80, height: 80)
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            Text("Entertainment Enthusiast")
                .font(.appTitle)
                .foregroundColor(.white)
            Text("Member since April 2026")
                .font(.appCaption)
                .foregroundColor(.textGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: - Stats

    private var statsSection: some View {
        VStack(spacing: 12) {
            // Row 1: Movies & Series counts
            HStack(spacing: 12) {
                statCard(icon: "film", value: "\(viewModel.movieCount)", label: "Movies")
                statCard(icon: "tv", value: "\(viewModel.seriesCount)", label: "Series")
            }
            // Row 2: Watched & Episodes
            HStack(spacing: 12) {
                statCard(icon: "checkmark.circle", value: "\(viewModel.watchedCount)", label: "Completed")
                statCard(icon: "play.rectangle.on.rectangle", value: "\(viewModel.totalEpisodesWatched)", label: "Episodes")
            }
            // Row 3: Watch Time & Rating
            HStack(spacing: 12) {
                statCard(icon: "clock", value: "\(viewModel.totalWatchTimeHours)h", label: "Watch Time")
                statCard(icon: "star.fill", value: String(format: "%.1f", viewModel.averageRating), label: "Avg Rating")
            }
        }
    }

    private func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.appPrimary)
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.appCaption)
                .foregroundColor(.textGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            ZStack {
                Color.cardBackground
                LinearGradient(colors: [.appPrimary.opacity(0.08), .clear],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            }
        )
        .cornerRadius(16)
    }

    // MARK: - Favorite Genre

    private var favoriteGenreSection: some View {
        VStack(spacing: 12) {
            Text("Favorite Genre")
                .font(.appSubtitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                Text(viewModel.favoriteGenre.genreEmoji)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.favoriteGenre.isEmpty ? "No data yet" : viewModel.favoriteGenre)
                        .font(.appSubtitle).foregroundColor(.white)
                    Text("Most watched genre")
                        .font(.appCaption).foregroundColor(.textGray)
                }

                Spacer()

                ZStack {
                    Circle().stroke(Color.cardBackground, lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: viewModel.completionRate / 100)
                        .stroke(Color.appPrimary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(viewModel.completionRate))%")
                        .font(.appCaption).foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
            }
            .cardStyle()
        }
    }

    // MARK: - Achievements

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.appSubtitle)
                .foregroundColor(.white)

            let badges: [(icon: String, title: String, desc: String, unlocked: Bool)] = [
                ("🎬", "First Step", "Added first title", viewModel.totalMovies > 0),
                ("🎥", "Movie Buff", "Added 10 titles", viewModel.totalMovies >= 10),
                ("📺", "Series Fan", "Added 5 series", viewModel.seriesCount >= 5),
                ("⭐", "Critic", "Rated 10 titles", viewModel.totalMovies >= 10),
                ("🏆", "Collector", "Added 25 titles", viewModel.totalMovies >= 25),
                ("⏱️", "Marathon Runner", "50+ hours watch time", viewModel.totalWatchTimeHours >= 50),
                ("🔥", "Episode Hunter", "Watched 50+ episodes", viewModel.totalEpisodesWatched >= 50),
                ("📺", "Binge Watcher", "Completed 5 titles", viewModel.watchedCount >= 5),
                ("🎭", "Genre Explorer", "5+ genres", Set(viewModel.movies.compactMap { $0.genre }).count >= 5)
            ]

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(badges.indices, id: \.self) { i in
                    let badge = badges[i]
                    VStack(spacing: 6) {
                        Text(badge.icon)
                            .font(.system(size: 28))
                            .grayscale(badge.unlocked ? 0 : 1)
                        Text(badge.title)
                            .font(.appCaption)
                            .foregroundColor(badge.unlocked ? .white : .textGray)
                            .lineLimit(1)
                        Text(badge.desc)
                            .font(.system(size: 9))
                            .foregroundColor(.textGray)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 4)
                    .background(
                        ZStack {
                            Color.cardBackground
                            if badge.unlocked {
                                LinearGradient(colors: [.appPrimary.opacity(0.15), .appSecondary.opacity(0.1)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            }
                        }
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(badge.unlocked ? Color.appPrimary.opacity(0.4) : .clear, lineWidth: 1)
                    )
                    .shadow(color: badge.unlocked ? .appPrimary.opacity(0.3) : .clear, radius: 6)
                    .opacity(badge.unlocked ? 1 : 0.5)
                }
            }
        }
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(spacing: 12) {
            Text("Settings")
                .font(.appSubtitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 0) {
                settingsRow(icon: "star.circle", title: "App Name", trailing: "Movie Stream Watch")
                Divider().background(Color.textGray.opacity(0.3))
                settingsRow(icon: "info.circle", title: "App Version", trailing: "2.0.0")
            }
            .background(Color.cardBackground)
            .cornerRadius(16)
        }
    }

    private func settingsRow(icon: String, title: String, trailing: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.appPrimary)
            Text(title).font(.appBody).foregroundColor(.white)
            Spacer()
            Text(trailing).font(.appCaption).foregroundColor(.textGray)
        }
        .padding()
    }

    private func settingsButton(icon: String, title: String) -> some View {
        Button {} label: {
            HStack {
                Image(systemName: icon).foregroundColor(.appPrimary)
                Text(title).font(.appBody).foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.textGray)
            }
            .padding()
        }
    }

    // MARK: - Disclaimer

    private var disclaimerSection: some View {
        Text("This app does not host or stream movies or TV shows. It is designed to help users manage and track their personal watchlist.")
            .font(.appCaption)
            .foregroundColor(.textGray)
            .multilineTextAlignment(.center)
            .padding(.vertical, 8)
    }
}

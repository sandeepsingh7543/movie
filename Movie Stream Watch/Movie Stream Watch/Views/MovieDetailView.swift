import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var viewModel: MovieViewModel
    @ObservedObject var movie: Movie
    @Environment(\.dismiss) var dismiss

    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var progress: Double
    @State private var editSeason: Int16
    @State private var editEpisode: Int16

    private var isSeries: Bool { (movie.contentType ?? "Movie") == "Series" }

    init(movie: Movie) {
        self.movie = movie
        _progress = State(initialValue: movie.watchProgress)
        _editSeason = State(initialValue: movie.currentSeason)
        _editEpisode = State(initialValue: movie.currentEpisode)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                posterHeader
                contentSection
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showEditSheet) {
            AddMovieView(movie: movie)
        }
        .alert("Delete \(isSeries ? "Series" : "Movie")", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteMovie(movie)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete \"\(movie.title ?? "")\"?")
        }
    }

    // MARK: - Poster Header

    private var posterHeader: some View {
        ZStack(alignment: .bottom) {
            PosterImage(posterData: movie.posterData)
                .frame(height: 350)
                .frame(maxWidth: .infinity)
                .clipped()

            LinearGradient(colors: [.clear, Color.appBackground],
                           startPoint: .center, endPoint: .bottom)
                .frame(height: 180)
        }
        .frame(height: 350)
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title & badges
            HStack {
                Text(movie.title ?? "")
                    .font(.appTitle)
                    .foregroundColor(.white)
                if isSeries {
                    Text("SERIES")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.appSecondary)
                        .cornerRadius(4)
                }
            }

            HStack(spacing: 12) {
                GenrePill(genre: movie.genre ?? "")
                RatingView(rating: movie.rating, compact: true)
                statusBadge
            }

            // Series episode tracking
            if isSeries && movie.watchStatus == "Watching" {
                seriesProgressSection
            }

            // Movie progress
            if !isSeries && movie.watchStatus == "Watching" {
                movieProgressSection
            }

            actionButtons

            Divider().background(Color.textGray.opacity(0.3))

            infoSection

            if let notes = movie.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notes").font(.appSubtitle).foregroundColor(.white)
                    Text(notes).font(.appBody).foregroundColor(.textGray)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surfaceColor)
                .cornerRadius(12)
            }

            if let link = movie.externalLink, let url = URL(string: link), !link.isEmpty {
                Link(destination: url) {
                    Label("Open External Link", systemImage: "link")
                        .font(.appBody)
                        .foregroundColor(.appPrimary)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color.surfaceColor)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }

    // MARK: - Status Badge

    private var statusBadge: some View {
        Text(movie.watchStatus ?? "Plan")
            .font(.appCaption)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.appPrimary.opacity(0.7))
            .clipShape(Capsule())
    }

    // MARK: - Series Progress

    private var seriesProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📺 Episode Progress")
                    .font(.appSubtitle).foregroundColor(.white)
                Spacer()
                Text("S\(editSeason) • E\(editEpisode)")
                    .font(.appBody).fontWeight(.semibold)
                    .foregroundColor(.appSecondary)
            }

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Season").font(.appCaption).foregroundColor(.textGray)
                    Stepper("S\(editSeason)", value: $editSeason,
                            in: 1...max(movie.totalSeasons, 1))
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Episode").font(.appCaption).foregroundColor(.textGray)
                    Stepper("E\(editEpisode)", value: $editEpisode, in: 0...999)
                        .foregroundColor(.white)
                }
            }

            Button {
                viewModel.updateSeriesProgress(movie, season: editSeason, episode: editEpisode)
            } label: {
                Text("Update Progress")
                    .font(.appCaption).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.appSecondary)
                    .cornerRadius(10)
            }
        }
        .padding(12)
        .background(Color.surfaceColor)
        .cornerRadius(12)
    }

    // MARK: - Movie Progress

    private var movieProgressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress").font(.appCaption).foregroundColor(.textGray)
                Spacer()
                Text("\(Int(progress * 100))%").font(.appCaption).foregroundColor(.white)
            }
            ProgressView(value: progress).tint(.appPrimary)
            Slider(value: $progress, in: 0...1, step: 0.05) { editing in
                if !editing { viewModel.updateProgress(movie, progress: progress) }
            }
            .tint(.appPrimary)
        }
        .padding(12)
        .background(Color.surfaceColor)
        .cornerRadius(12)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 0) {
            actionButton(icon: movie.isFavorite ? "heart.fill" : "heart",
                         label: "Favorite",
                         color: movie.isFavorite ? .appPrimary : .textGray) {
                viewModel.toggleFavorite(movie)
            }
            actionButton(icon: "pencil", label: "Edit", color: .textGray) {
                showEditSheet = true
            }
            if let link = movie.externalLink, !link.isEmpty {
                ShareLink(item: link) {
                    VStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up").font(.title3)
                        Text("Share").font(.appCaption)
                    }
                    .foregroundColor(.textGray)
                    .frame(maxWidth: .infinity)
                }
            }
            actionButton(icon: "trash", label: "Delete", color: .red) {
                showDeleteAlert = true
            }
        }
        .padding(.vertical, 8)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }

    private func actionButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.title3)
                Text(label).font(.appCaption)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(spacing: 10) {
            infoRow(icon: "tag", label: "Type", value: isSeries ? "Web Series" : "Movie")
            if let date = movie.dateAdded {
                infoRow(icon: "calendar", label: "Added", value: date.formatted(date: .abbreviated, time: .omitted))
            }
            if let mood = movie.mood, !mood.isEmpty {
                infoRow(icon: "face.smiling", label: "Mood", value: mood)
            }
            if isSeries {
                infoRow(icon: "tv", label: "Seasons", value: "\(movie.totalSeasons)")
                if movie.totalEpisodes > 0 {
                    infoRow(icon: "list.number", label: "Total Episodes", value: "\(movie.totalEpisodes)")
                }
                infoRow(icon: "play.circle", label: "Progress", value: "S\(movie.currentSeason) • E\(movie.currentEpisode)")
            }
            if movie.watchTime > 0 {
                infoRow(icon: "clock", label: "Watch Time", value: "\(movie.watchTime) min")
            }
        }
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.appSecondary)
                .frame(width: 24)
            Text(label).font(.appCaption).foregroundColor(.textGray)
            Spacer()
            Text(value).font(.appBody).foregroundColor(.white)
        }
    }
}

import SwiftUI

struct AddMovieView: View {
    @EnvironmentObject var viewModel: MovieViewModel
    @Environment(\.dismiss) var dismiss

    var movie: Movie?

    @State private var contentType = "Movie"
    @State private var title = ""
    @State private var genre = "Action"
    @State private var rating: Double = 0
    @State private var watchStatus = "Plan"
    @State private var notes = ""
    @State private var externalLink = ""
    @State private var mood = "Chill"
    @State private var watchTime: Int = 90
    @State private var posterImage: UIImage?
    @State private var showImagePicker = false
    // Series fields
    @State private var totalSeasons: Int = 1
    @State private var totalEpisodes: Int = 0
    @State private var currentSeason: Int = 1
    @State private var currentEpisode: Int = 0

    private let genres = ["Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Thriller", "Animation", "Documentary", "Fantasy"]
    private let moods = ["Action", "Chill", "Romantic", "Focus"]

    private var isEditing: Bool { movie != nil }
    private var isSeries: Bool { contentType == "Series" }

    private var statuses: [String] {
        isSeries ? ["Plan", "Watching", "Completed"] : ["Plan", "Watching", "Watched"]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    contentTypePicker
                    posterSection
                    titleField
                    genrePicker
                    ratingSlider
                    statusPicker
                    if isSeries { seriesFields }
                    moodPicker
                    watchTimeStepper
                    linkField
                    notesField
                    saveButton
                }
                .padding()
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle(isEditing ? "Edit \(contentType)" : "Add \(contentType)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.appPrimary)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $posterImage)
            }
            .onAppear(perform: prefill)
        }
    }

    // MARK: - Content Type Picker

    private var contentTypePicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Content Type").font(.appCaption).foregroundColor(.textGray)
            Picker("Type", selection: $contentType) {
                Text("🎬 Movie").tag("Movie")
                Text("📺 Web Series").tag("Series")
            }
            .pickerStyle(.segmented)
            .onChange(of: contentType) { _ in
                // Reset status if switching type and current status is invalid
                if isSeries && watchStatus == "Watched" { watchStatus = "Completed" }
                if !isSeries && watchStatus == "Completed" { watchStatus = "Watched" }
            }
        }
    }

    // MARK: - Series Fields

    private var seriesFields: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Seasons").font(.appCaption).foregroundColor(.textGray)
                    Stepper("\(totalSeasons)", value: $totalSeasons, in: 1...50)
                        .padding(10)
                        .background(Color.surfaceColor)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Episodes").font(.appCaption).foregroundColor(.textGray)
                    Stepper("\(totalEpisodes)", value: $totalEpisodes, in: 0...999)
                        .padding(10)
                        .background(Color.surfaceColor)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }

            if watchStatus == "Watching" {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Current Season").font(.appCaption).foregroundColor(.textGray)
                        Stepper("S\(currentSeason)", value: $currentSeason, in: 1...max(totalSeasons, 1))
                            .padding(10)
                            .background(Color.surfaceColor)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Current Episode").font(.appCaption).foregroundColor(.textGray)
                        Stepper("E\(currentEpisode)", value: $currentEpisode, in: 0...999)
                            .padding(10)
                            .background(Color.surfaceColor)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(12)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }

    // MARK: - Poster

    private var posterSection: some View {
        Button { showImagePicker = true } label: {
            Group {
                if let img = posterImage {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    LinearGradient(colors: [.appPrimary.opacity(0.4), .appSecondary.opacity(0.4)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.largeTitle)
                            Text("Tap to add poster")
                                .font(.appCaption)
                        }
                        .foregroundColor(.white.opacity(0.6))
                    )
                }
            }
            .frame(width: 180, height: 270)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Fields

    private var titleField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Title").font(.appCaption).foregroundColor(.textGray)
            TextField(isSeries ? "Series title" : "Movie title", text: $title)
                .padding(12)
                .background(Color.surfaceColor)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }

    private var genrePicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Genre").font(.appCaption).foregroundColor(.textGray)
            Picker("Genre", selection: $genre) {
                ForEach(genres, id: \.self) { Text("\($0.genreEmoji) \($0)") }
            }
            .pickerStyle(.menu)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surfaceColor)
            .cornerRadius(10)
            .tint(.white)
        }
    }

    private var ratingSlider: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Rating").font(.appCaption).foregroundColor(.textGray)
            HStack {
                RatingView(rating: rating)
                Spacer()
                Text(String(format: "%.1f", rating))
                    .font(.appBody).foregroundColor(.white)
            }
            Slider(value: $rating, in: 0...5, step: 0.5)
                .tint(.appPrimary)
        }
        .padding(12)
        .background(Color.surfaceColor)
        .cornerRadius(10)
    }

    private var statusPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Watch Status").font(.appCaption).foregroundColor(.textGray)
            Picker("Status", selection: $watchStatus) {
                ForEach(statuses, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)
        }
    }

    private var moodPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Mood").font(.appCaption).foregroundColor(.textGray)
            Picker("Mood", selection: $mood) {
                ForEach(moods, id: \.self) { Text($0) }
            }
            .pickerStyle(.menu)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surfaceColor)
            .cornerRadius(10)
            .tint(.white)
        }
    }

    private var watchTimeStepper: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Estimated Watch Time").font(.appCaption).foregroundColor(.textGray)
            Stepper("\(watchTime) min", value: $watchTime, in: 0...6000, step: isSeries ? 30 : 15)
                .padding(12)
                .background(Color.surfaceColor)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }

    private var linkField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("External Link").font(.appCaption).foregroundColor(.textGray)
            TextField("https://...", text: $externalLink)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .padding(12)
                .background(Color.surfaceColor)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }

    private var notesField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Notes").font(.appCaption).foregroundColor(.textGray)
            TextEditor(text: $notes)
                .frame(minHeight: 80)
                .padding(8)
                .scrollContentBackground(.hidden)
                .background(Color.surfaceColor)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }

    // MARK: - Save

    private var saveButton: some View {
        Button { save() } label: {
            Text(isEditing ? "Update \(contentType)" : "Add \(contentType)")
                .font(.appSubtitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    title.isEmpty
                        ? AnyShapeStyle(Color.gray.opacity(0.4))
                        : AnyShapeStyle(Color.primaryGradient)
                )
                .clipShape(Capsule())
        }
        .disabled(title.isEmpty)
    }

    // MARK: - Helpers

    private func prefill() {
        guard let m = movie else { return }
        contentType = m.contentType ?? "Movie"
        title = m.title ?? ""
        genre = m.genre ?? "Action"
        rating = m.rating
        watchStatus = m.watchStatus ?? "Plan"
        notes = m.notes ?? ""
        externalLink = m.externalLink ?? ""
        mood = m.mood ?? "Chill"
        watchTime = Int(m.watchTime)
        totalSeasons = Int(m.totalSeasons)
        totalEpisodes = Int(m.totalEpisodes)
        currentSeason = Int(m.currentSeason)
        currentEpisode = Int(m.currentEpisode)
        if let data = m.posterData { posterImage = UIImage(data: data) }
    }

    private func save() {
        let timeMinutes = Int64(watchTime)
        if let m = movie {
            viewModel.updateMovie(m, title: title, genre: genre, rating: rating,
                                  watchStatus: watchStatus, notes: notes.isEmpty ? nil : notes,
                                  externalLink: externalLink.isEmpty ? nil : externalLink,
                                  posterImage: posterImage, mood: mood, watchTime: timeMinutes,
                                  contentType: contentType, totalSeasons: Int16(totalSeasons),
                                  totalEpisodes: Int16(totalEpisodes), currentSeason: Int16(currentSeason),
                                  currentEpisode: Int16(currentEpisode))
        } else {
            viewModel.addMovie(title: title, genre: genre, rating: rating,
                               watchStatus: watchStatus, notes: notes.isEmpty ? nil : notes,
                               externalLink: externalLink.isEmpty ? nil : externalLink,
                               posterImage: posterImage, mood: mood, watchTime: timeMinutes,
                               contentType: contentType, totalSeasons: Int16(totalSeasons),
                               totalEpisodes: Int16(totalEpisodes), currentSeason: Int16(currentSeason),
                               currentEpisode: Int16(currentEpisode))
        }
        dismiss()
    }
}

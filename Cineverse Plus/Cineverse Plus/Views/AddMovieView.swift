import SwiftUI

struct AddMovieView: View {
    @EnvironmentObject var vm: MovieViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var genre = "Action"
    @State private var durationHours = 1
    @State private var durationMinutes = 30
    @State private var rating = 3.0
    @State private var notes = ""
    @State private var watchProgress = 0.0
    @State private var mood = "Chill"
    @State private var collection = "Default"
    @State private var posterImage: UIImage?
    @State private var showImagePicker = false

    private let genres = ["Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Thriller", "Animation", "Documentary"]
    private let moods = ["Action", "Chill", "Romantic", "Focus", "Thrilling", "Scary", "Happy", "Sad"]

    var body: some View {
        NavigationStack {
            Form {
                // Poster
                Section {
                    Button { showImagePicker = true } label: {
                        if let img = posterImage {
                            Image(uiImage: img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("Add Poster")
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .foregroundColor(CineverseTheme.neonPurple)
                        }
                    }
                }
                .listRowBackground(CineverseTheme.cardBackground)

                // Details
                Section("Details") {
                    TextField("Movie Title", text: $title)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) { Text($0) }
                    }
                    HStack {
                        Stepper("Duration: \(durationHours)h \(durationMinutes)m", value: $durationMinutes, in: 0...59, step: 5)
                    }
                    Stepper("Hours: \(durationHours)", value: $durationHours, in: 0...6)
                }
                .listRowBackground(CineverseTheme.cardBackground)

                // Rating & Mood
                Section("Rating & Mood") {
                    VStack(alignment: .leading) {
                        Text("Rating: \(String(format: "%.1f", rating))")
                        Slider(value: $rating, in: 0...5, step: 0.5)
                            .tint(CineverseTheme.neonPurple)
                    }
                    Picker("Mood", selection: $mood) {
                        ForEach(moods, id: \.self) { Text($0) }
                    }
                }
                .listRowBackground(CineverseTheme.cardBackground)

                // Progress
                Section("Watch Progress") {
                    VStack(alignment: .leading) {
                        Text("\(Int(watchProgress * 100))% watched")
                        Slider(value: $watchProgress, in: 0...1, step: 0.05)
                            .tint(CineverseTheme.electricBlue)
                    }
                }
                .listRowBackground(CineverseTheme.cardBackground)

                // Notes & Collection
                Section("Notes") {
                    TextField("Your thoughts...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Collection", text: $collection)
                }
                .listRowBackground(CineverseTheme.cardBackground)
            }
            .scrollContentBackground(.hidden)
            .background(CineverseTheme.deepBlack)
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveMovie() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                        .foregroundColor(CineverseTheme.neonPurple)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $posterImage)
            }
        }
    }

    private func saveMovie() {
        let duration = Int16(durationHours * 60 + durationMinutes)
        let data = posterImage?.jpegData(compressionQuality: 0.7)
        vm.addMovie(
            title: title.trimmingCharacters(in: .whitespaces),
            genre: genre, duration: duration, rating: rating,
            notes: notes, watchProgress: watchProgress,
            posterData: data, mood: mood, isFavorite: false,
            collection: collection.isEmpty ? "Default" : collection
        )
        dismiss()
    }
}

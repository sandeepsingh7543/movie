import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct AddEditMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.starmaxPalette) private var palette
    @State private var draft: MovieDraft
    @State private var isSaving = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var newCollectionName = ""

    let movie: StarMovie?
    let collections: [MovieCollection]
    let onSave: (MovieDraft, StarMovie?) -> Void

    init(movie: StarMovie?, collections: [MovieCollection], onSave: @escaping (MovieDraft, StarMovie?) -> Void) {
        self.movie = movie
        self.collections = collections
        self.onSave = onSave
        _draft = State(initialValue: movie.map(MovieDraft.init(movie:)) ?? MovieDraft())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Poster") {
                    posterPicker
                }

                Section("Details") {
                    TextField("Title", text: $draft.title)
                    Picker("Genre", selection: $draft.genre) {
                        ForEach(MovieGenreCatalog.genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                    Picker("Watch Status", selection: $draft.status) {
                        ForEach(MovieStatus.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Rating")
                            Spacer()
                            Text(String(format: "%.1f", draft.rating))
                                .foregroundStyle(palette.textSecondary)
                        }
                        Slider(value: $draft.rating, in: 0...5, step: 0.5)
                    }

                    Picker("Mood", selection: $draft.moodTag) {
                        ForEach(MoodTag.allCases) { mood in
                            Label(mood.rawValue, systemImage: mood.symbol).tag(mood)
                        }
                    }

                    Toggle("Favorite movie", isOn: $draft.isFavorite)
                    Toggle("Rewatch reminder", isOn: $draft.rewatchReminderEnabled)

                    if draft.rewatchReminderEnabled {
                        DatePicker(
                            "Reminder date",
                            selection: Binding(
                                get: { draft.rewatchReminderDate ?? .now },
                                set: { draft.rewatchReminderDate = $0 }
                            ),
                            displayedComponents: [.date]
                        )
                    }

                    Stepper("Release Year: \(draft.releaseYear)", value: $draft.releaseYear, in: 1900...Calendar.current.component(.year, from: .now) + 1)
                    Stepper("Duration: \(draft.durationMinutes) min", value: $draft.durationMinutes, in: 20...480, step: 5)
                }

                Section("Notes") {
                    TextEditor(text: $draft.notes)
                        .frame(minHeight: 100)
                }

                Section("Collections") {
                    if collections.isEmpty {
                        Text("Create collections by assigning a name here. They will stay local to this device.")
                            .font(.footnote)
                            .foregroundStyle(palette.textSecondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(collections) { collection in
                                    Button {
                                        toggleCollection(collection.name)
                                    } label: {
                                        Text(collection.name)
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(draft.selectedCollectionNames.contains(collection.name) ? palette.inverseText : palette.textPrimary)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(
                                                Capsule(style: .continuous)
                                                    .fill(draft.selectedCollectionNames.contains(collection.name) ? palette.textPrimary : palette.chipFill)
                                            )
                                    }
                                }
                            }
                        }
                    }

                    HStack {
                        TextField("New collection", text: $newCollectionName)
                        Button("Add") {
                            addCollection()
                        }
                        .disabled(newCollectionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(StarmaxBackground())
            .navigationTitle(movie == nil ? "Add Movie" : "Edit Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isSaving ? "Saving..." : "Save") {
                        save()
                    }
                    .disabled(isSaving || draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private var posterPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(palette.chipFill)
                        .frame(width: 120, height: 170)

                    if let posterImage = draft.posterImage {
                        Image(uiImage: posterImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 170)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    } else if let posterPath = draft.posterPath, let image = ImageManager.shared.image(for: posterPath) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 170)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    } else {
                        VStack(spacing: 10) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title2.weight(.semibold))
                            Text("Poster")
                                .font(.caption.weight(.semibold))
                        }
                        .foregroundStyle(palette.textSecondary)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("Choose Poster", systemImage: "photo")
                            .font(.subheadline.weight(.semibold))
                    }

                    Button(role: .destructive) {
                        draft.posterImage = nil
                        draft.posterPath = nil
                        draft.posterWasCleared = true
                    } label: {
                        Label("Remove Poster", systemImage: "trash")
                            .font(.subheadline.weight(.semibold))
                    }
                }

                Spacer(minLength: 0)
            }

            Text("Use a poster that is already on your device. Starmax compresses and stores it locally for fast scrolling.")
                .font(.footnote)
                .foregroundStyle(palette.textSecondary)
        }
        .task(id: pickerItem) {
            guard let pickerItem else { return }
            if let data = try? await pickerItem.loadTransferable(type: Data.self),
               let image = ImageManager.shared.importedImage(from: data) {
                draft.posterImage = image
                draft.posterWasCleared = false
            }
        }
    }

    private func toggleCollection(_ name: String) {
        if draft.selectedCollectionNames.contains(name) {
            draft.selectedCollectionNames.remove(name)
        } else {
            draft.selectedCollectionNames.insert(name)
        }
    }

    private func addCollection() {
        let normalized = MovieCollection.normalizeName(newCollectionName)
        guard !normalized.isEmpty else { return }
        draft.selectedCollectionNames.insert(normalized)
        newCollectionName = ""
    }

    private func save() {
        isSaving = true
        onSave(draft, movie)
        isSaving = false
        dismiss()
    }
}

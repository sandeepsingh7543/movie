import SwiftUI
import PhotosUI

struct AddMovieView: View {
    let vm: MovieViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var desc = ""
    @State private var genre = Genre.action.rawValue
    @State private var releaseDate = Date()
    @State private var rating = 3
    @State private var posterItem: PhotosPickerItem?
    @State private var posterData: Data?
    @State private var showValidation = false

    var isValid: Bool { !title.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Poster Picker
                        PhotosPicker(selection: $posterItem, matching: .images) {
                            ZStack {
                                if let posterData, let uiImage = UIImage(data: posterData) {
                                    Image(uiImage: uiImage)
                                        .resizable().scaledToFill()
                                        .frame(height: 220)
                                        .clipped()
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 40))
                                            .foregroundColor(Theme.accent)
                                        Text("Add Poster")
                                            .font(.subheadline).fontWeight(.medium)
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    .frame(height: 220)
                                    .frame(maxWidth: .infinity)
                                    .background(Theme.card)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(
                                posterData == nil ? Theme.accent.opacity(0.4) : .clear, lineWidth: 1
                            ))
                        }
                        .onChange(of: posterItem) { _, item in
                            Task {
                                posterData = try? await item?.loadTransferable(type: Data.self)
                            }
                        }

                        // Form Fields
                        VStack(spacing: 14) {
                            FormField(label: "Title *", placeholder: "Movie title") { $title }
                                .overlay(
                                    showValidation && title.isEmpty ?
                                    RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.6), lineWidth: 1) : nil
                                )

                            FormTextEditor(label: "Description", placeholder: "Brief overview...", text: $desc)

                            // Genre Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Genre").font(.caption).foregroundColor(Theme.textSecondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(Genre.allCases, id: \.rawValue) { g in
                                            Button(g.rawValue) {
                                                genre = g.rawValue
                                            }
                                            .font(.subheadline).fontWeight(.medium)
                                            .padding(.horizontal, 14).padding(.vertical, 8)
                                            .background(genre == g.rawValue ? Theme.accent : Theme.glass)
                                            .foregroundColor(genre == g.rawValue ? .white : Theme.textSecondary)
                                            .clipShape(Capsule())
                                            .overlay(Capsule().stroke(
                                                genre == g.rawValue ? .clear : Theme.glassBorder, lineWidth: 0.5
                                            ))
                                        }
                                    }
                                }
                            }

                            // Release Date
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Release Date").font(.caption).foregroundColor(Theme.textSecondary)
                                DatePicker("", selection: $releaseDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .tint(Theme.accent)
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Theme.glass)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.glassBorder, lineWidth: 0.5))
                            }

                            // Rating
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Rating").font(.caption).foregroundColor(Theme.textSecondary)
                                HStack {
                                    StarRatingView(rating: rating, size: 28, interactive: true) { rating = $0 }
                                    Spacer()
                                    Text("\(rating)/5")
                                        .font(.subheadline).fontWeight(.semibold)
                                        .foregroundColor(Theme.accentGold)
                                }
                                .padding(12)
                                .background(Theme.glass)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.glassBorder, lineWidth: 0.5))
                            }
                        }

                        // Save Button
                        Button {
                            guard isValid else { showValidation = true; return }
                            vm.addMovie(title: title.trimmingCharacters(in: .whitespaces),
                                        desc: desc,
                                        genre: genre,
                                        releaseDate: releaseDate,
                                        rating: rating,
                                        posterData: posterData)
                            dismiss()
                        } label: {
                            Text("Save Movie")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isValid ? Theme.accent : Theme.card)
                                .foregroundColor(isValid ? .white : Theme.textSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .animation(.easeInOut, value: isValid)
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Helper Views

struct FormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    init(label: String, placeholder: String, binding: () -> Binding<String>) {
        self.label = label
        self.placeholder = placeholder
        self._text = binding()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.caption).foregroundColor(Theme.textSecondary)
            TextField(placeholder, text: $text)
                .foregroundColor(Theme.textPrimary)
                .tint(Theme.accent)
                .padding(12)
                .background(Theme.glass)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.glassBorder, lineWidth: 0.5))
        }
    }
}

struct FormTextEditor: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.caption).foregroundColor(Theme.textSecondary)
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Theme.textSecondary.opacity(0.6))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                TextEditor(text: $text)
                    .foregroundColor(Theme.textPrimary)
                    .tint(Theme.accent)
                    .frame(minHeight: 80)
                    .scrollContentBackground(.hidden)
            }
            .padding(12)
            .background(Theme.glass)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.glassBorder, lineWidth: 0.5))
        }
    }
}

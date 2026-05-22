import SwiftUI
import PhotosUI

// MARK: - Add Movie View
struct AddMovieView: View {
    @Environment(\.dismiss) private var dismiss
    var onAdded: (() -> Void)?

    @State private var title = ""
    @State private var overview = ""
    @State private var posterURLString = ""
    @State private var releaseYear = ""
    @State private var rating: Double = 5.0
    @State private var selectedCategory = MovieCategory.popular
    @State private var showSuccess = false
    @State private var titleError = false

    // Photo picker
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    private let persistence = PersistenceManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        posterSection
                        formFields
                        addButton
                    }
                    .padding(20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Movie")
                        .font(.appHeadline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.appSecondary)
                }
            }
        }
        .overlay(successToast)
        .onChange(of: pickerItem) { loadPickedImage() }
    }

    // MARK: - Poster Section (Photo Picker + URL)
    private var posterSection: some View {
        VStack(spacing: 12) {
            // Preview
            ZStack {
                if let img = selectedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 180)
                        .clipped()
                        .cornerRadius(12)
                } else if let url = URL(string: posterURLString), !posterURLString.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                                .frame(width: 120, height: 180)
                                .clipped()
                                .cornerRadius(12)
                        default:
                            posterPlaceholder
                        }
                    }
                } else {
                    posterPlaceholder
                }
            }
            .frame(width: 120, height: 180)
            .shadow(color: .black.opacity(0.5), radius: 10, y: 4)

            // Pick from library button
            PhotosPicker(selection: $pickerItem, matching: .images) {
                Label("Choose from Library", systemImage: "photo.on.rectangle")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.appAccent)
            }

            // OR divider
//            HStack {
//                Rectangle().fill(Color.appSurface).frame(height: 1)
//                Text("or enter URL").font(.system(size: 11)).foregroundColor(.appSecondary.opacity(0.6))
//                Rectangle().fill(Color.appSurface).frame(height: 1)
//            }

            // URL field
//            TextField("", text: $posterURLString)
//                .addMoviePlaceholder(when: posterURLString.isEmpty) {
//                    Text("https://...").foregroundColor(.appSecondary.opacity(0.5))
//                }
//                .addMovieStyledField()
//                .keyboardType(.URL)
//                .autocorrectionDisabled()
//                .textInputAutocapitalization(.never)
//                .onChange(of: posterURLString) { if !posterURLString.isEmpty { selectedImage = nil } }
        }
    }

    private var posterPlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.appSurface)
            .frame(width: 120, height: 180)
            .overlay(
                VStack(spacing: 6) {
                    Image(systemName: "photo")
                        .font(.system(size: 28))
                        .foregroundColor(.appSecondary.opacity(0.5))
                    Text("Poster Preview")
                        .font(.system(size: 10))
                        .foregroundColor(.appSecondary.opacity(0.4))
                }
            )
    }

    // MARK: - Form Fields
    private var formFields: some View {
        VStack(spacing: 14) {
            // Title
            VStack(alignment: .leading, spacing: 6) {
                fieldLabel("Movie Title *")
                TextField("", text: $title)
                    .addMoviePlaceholder(when: title.isEmpty) {
                        Text("e.g. Inception").foregroundColor(.appSecondary.opacity(0.5))
                    }
                    .addMovieStyledField()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(titleError ? Color.appAccent : Color.clear, lineWidth: 1)
                    )
                    .onChange(of: title) { titleError = false }
            }

            // Overview
            VStack(alignment: .leading, spacing: 6) {
                fieldLabel("Overview (optional)")
                ZStack(alignment: .topLeading) {
                    if overview.isEmpty {
                        Text("Short description...")
                            .foregroundColor(.appSecondary.opacity(0.5))
                            .font(.appBody)
                            .padding(.horizontal, 14)
                            .padding(.top, 12)
                    }
                    TextEditor(text: $overview)
                        .font(.appBody)
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .frame(height: 80)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                }
                .background(Color.appSurface)
                .cornerRadius(10)
            }

            // Release Year
            VStack(alignment: .leading, spacing: 6) {
                fieldLabel("Release Year (optional)")
                TextField("", text: $releaseYear)
                    .addMoviePlaceholder(when: releaseYear.isEmpty) {
                        Text("e.g. 2024").foregroundColor(.appSecondary.opacity(0.5))
                    }
                    .addMovieStyledField()
                    .keyboardType(.numberPad)
            }

            // Rating
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    fieldLabel("Rating")
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").font(.system(size: 12)).foregroundColor(.appGold)
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                    }
                }
                Slider(value: $rating, in: 0...10, step: 0.1).tint(.appAccent)
            }

            // Category
            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Category")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(MovieCategory.allCases) { cat in
                            Button {
                                haptic(.selection)
                                selectedCategory = cat
                            } label: {
                                Text(cat.rawValue)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(selectedCategory == cat ? .white : .appSecondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == cat ? Color.appAccent : Color.appSurface)
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Add Button
    private var addButton: some View {
        Button {
            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
                haptic(.error)
                withAnimation { titleError = true }
                return
            }
            haptic(.success)

            // Save picked image locally, use path; else use URL string
            var posterPath: String? = posterURLString.isEmpty ? nil : posterURLString
            if let img = selectedImage, let saved = saveImageLocally(img) {
                posterPath = saved
            }

            let relDate = releaseYear.isEmpty ? nil : "\(releaseYear)-01-01"
            persistence.addManualMovie(
                title: title.trimmingCharacters(in: .whitespaces),
                posterPath: posterPath,
                overview: overview,
                rating: rating,
                releaseDate: relDate,
                category: selectedCategory.rawValue
            )
            withAnimation { showSuccess = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onAdded?()
                dismiss()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                Text("Add to Library").font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.appAccent)
            .cornerRadius(14)
        }
        .pressEffect()
        .padding(.top, 4)
    }

    // MARK: - Success Toast
    private var successToast: some View {
        VStack {
            Spacer()
            if showSuccess {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    Text("Movie added to Library!")
                        .font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .cornerRadius(25)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4), value: showSuccess)
    }

    // MARK: - Helpers
    private func fieldLabel(_ text: String) -> some View {
        Text(text).font(.system(size: 12, weight: .medium)).foregroundColor(.appSecondary)
    }

    private func loadPickedImage() {
        guard let item = pickerItem else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let img = UIImage(data: data) {
                await MainActor.run {
                    selectedImage = img
                    posterURLString = ""
                }
            }
        }
    }

    /// Saves UIImage to Documents, returns just the filename (not full path)
    private func saveImageLocally(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = "poster_\(UUID().uuidString).jpg"
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = dir.appendingPathComponent(filename)
        try? data.write(to: fileURL)
        return filename   // store only filename, not full path
    }
}

// MARK: - Scoped View Helpers (fileprivate to avoid global conflicts)
fileprivate extension View {
    func addMovieStyledField() -> some View {
        self
            .font(.appBody)
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.appSurface)
            .cornerRadius(10)
    }

    func addMoviePlaceholder<C: View>(when show: Bool, @ViewBuilder placeholder: () -> C) -> some View {
        ZStack(alignment: .leading) {
            if show { placeholder() }
            self
        }
    }
}

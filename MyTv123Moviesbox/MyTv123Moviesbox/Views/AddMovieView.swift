//
//  AddMovieView.swift
//  MyTv123Moviesbox
//
//  Add new movies and shows with image picker
//

import SwiftUI
import PhotosUI

struct AddMovieView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    
    let defaultContentType: MovieModel.ContentType
    
    @State private var title = ""
    @State private var genre = ""
    @State private var description = ""
    @State private var duration = ""
    @State private var releaseYear = ""
    @State private var director = ""
    @State private var cast = ""
    @State private var rating = 5.0
    @State private var selectedType: MovieModel.ContentType
    @State private var selectedQuality = MovieModel.VideoQuality.hd
    @State private var language = "English"
    @State private var country = "USA"
    @State private var ageRating = "PG-13"
    
    // Image picker
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    init(defaultContentType: MovieModel.ContentType = .movie) {
        self.defaultContentType = defaultContentType
        self._selectedType = State(initialValue: defaultContentType)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Image Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Poster Image")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(themeManager.accentColor.opacity(0.2))
                                    .frame(height: 200)
                                
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(15)
                                } else {
                                    VStack(spacing: 10) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        Text("Tap to add poster")
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Basic Info
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Basic Information")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        CustomTextField(title: "Title", text: $title)
                        CustomTextField(title: "Genre", text: $genre, placeholder: "Action, Drama, Comedy")
                        CustomTextField(title: "Description", text: $description, isMultiline: true)
                        CustomTextField(title: "Duration", text: $duration, placeholder: "2h 30min")
                        CustomTextField(title: "Release Year", text: $releaseYear, placeholder: "2024")
                    }
                    
                    // Content Type & Quality
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Content Details")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Content Type")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Picker("Type", selection: $selectedType) {
                                ForEach(MovieModel.ContentType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Video Quality")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Picker("Quality", selection: $selectedQuality) {
                                ForEach(MovieModel.VideoQuality.allCases, id: \.self) { quality in
                                    Text(quality.rawValue).tag(quality)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    // Cast & Crew
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Cast & Crew")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        CustomTextField(title: "Director", text: $director)
                        CustomTextField(title: "Cast", text: $cast, placeholder: "Actor 1, Actor 2, Actor 3")
                    }
                    
                    // Rating & Details
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Additional Details")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating: \(String(format: "%.1f", rating))")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Slider(value: $rating, in: 1...10, step: 0.1)
                                .accentColor(themeManager.accentColor)
                        }
                        
                        CustomTextField(title: "Language", text: $language)
                        CustomTextField(title: "Country", text: $country)
                        CustomTextField(title: "Age Rating", text: $ageRating, placeholder: "PG, PG-13, R")
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(20)
            }
            .background(themeManager.currentTheme.primaryGradient.ignoresSafeArea())
            .navigationTitle(selectedType == .movie ? "Add Movie" : "Add TV Show")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMovie()
                    }
                    .foregroundColor(themeManager.accentColor)
                    .disabled(title.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func saveMovie() {
        // Convert image to base64 string for storage
        var imageString = ""
        if let selectedImage = selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            imageString = imageData.base64EncodedString()
        }
        
        let newMovie = MovieModel(
            title: title,
            genre: genre.isEmpty ? "General" : genre,
            description: description.isEmpty ? "No description available" : description,
            duration: duration.isEmpty ? "Unknown" : duration,
            posterURL: imageString, // Store base64 image string
            isFavorite: false,
            isWatched: false,
            watchProgress: 0.0,
            releaseYear: releaseYear.isEmpty ? "2024" : releaseYear,
            rating: rating,
            director: director.isEmpty ? "Unknown" : director,
            cast: cast.isEmpty ? [] : cast.components(separatedBy: ", "),
            language: language,
            subtitles: ["English"],
            categories: genre.components(separatedBy: ", "),
            quality: selectedQuality,
            personalNotes: "",
            tags: [],
            contentType: selectedType,
            ageRating: ageRating,
            country: country,
            popularity: Double.random(in: 6.0...9.5),
            trendingScore: Double.random(in: 7.0...9.8)
        )
        
        dataManager.addMovie(newMovie)
        
        // Show notification
        NotificationManager.shared.scheduleNotification(
            title: "\(selectedType.rawValue) Added!",
            body: "\(title) has been added to your collection"
        )
        
        dismiss()
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    var isMultiline: Bool = false
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            if isMultiline {
                TextEditor(text: $text)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(themeManager.currentTheme.cardBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                    )
            } else {
                TextField(placeholder.isEmpty ? title : placeholder, text: $text)
                    .padding(12)
                    .background(themeManager.currentTheme.cardBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    AddMovieView(defaultContentType: .movie)
}

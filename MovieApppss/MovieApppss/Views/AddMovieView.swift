//
//  AddMovieView.swift
//  MovieApppss
//
//  Enhanced Add Movie View
//

import SwiftUI
import PhotosUI

struct AddMovieView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    
    // Basic Info
    @State private var title = ""
    @State private var genre = ""
    @State private var description = ""
    @State private var duration = ""
    @State private var contentType: MovieModel.ContentType = .movie
    
    // Detailed Info
    @State private var releaseDate = ""
    @State private var rating = ""
    @State private var imdbRating = ""
    @State private var rottenTomatoesScore = ""
    @State private var director = ""
    @State private var cast = ""
    @State private var language = ""
    @State private var subtitlesAvailable = false
    @State private var trailerURL = ""
    @State private var price = ""
    @State private var categories = ""
    @State private var streamingPlatforms = ""
    @State private var ageRating = ""
    @State private var country = ""
    @State private var budget = ""
    @State private var boxOffice = ""
    @State private var seasons = ""
    @State private var episodes = ""
    @State private var personalNotes = ""
    @State private var tags = ""
    
    // Images
    @State private var selectedPosterImage: UIImage?
    @State private var selectedBackdropImage: UIImage?
    @State private var showingPosterPicker = false
    @State private var showingBackdropPicker = false
    
    // UI State
    @State private var currentSection = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Selector
                SectionSelector(currentSection: $currentSection)
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        switch currentSection {
                        case 0:
                            BasicInfoSection(
                                title: $title,
                                genre: $genre,
                                description: $description,
                                duration: $duration,
                                contentType: $contentType,
                                selectedPosterImage: $selectedPosterImage,
                                selectedBackdropImage: $selectedBackdropImage,
                                showingPosterPicker: $showingPosterPicker,
                                showingBackdropPicker: $showingBackdropPicker
                            )
                        case 1:
                            DetailedInfoSection(
                                releaseDate: $releaseDate,
                                rating: $rating,
                                imdbRating: $imdbRating,
                                rottenTomatoesScore: $rottenTomatoesScore,
                                director: $director,
                                cast: $cast,
                                language: $language,
                                subtitlesAvailable: $subtitlesAvailable,
                                trailerURL: $trailerURL,
                                price: $price,
                                ageRating: $ageRating,
                                country: $country,
                                budget: $budget,
                                boxOffice: $boxOffice
                            )
                        case 2:
                            AdditionalInfoSection(
                                categories: $categories,
                                streamingPlatforms: $streamingPlatforms,
                                seasons: $seasons,
                                episodes: $episodes,
                                personalNotes: $personalNotes,
                                tags: $tags,
                                contentType: contentType
                            )
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                // Save Button
                Button(action: saveMovie) {
                    Text("Save Movie")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.6 : 1.0)
            }
            .background(Color.black)
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showingPosterPicker) {
            ImagePicker(selectedImage: $selectedPosterImage)
        }
        .sheet(isPresented: $showingBackdropPicker) {
            ImagePicker(selectedImage: $selectedBackdropImage)
        }
    }
    
    private func saveMovie() {
        let posterImageData = selectedPosterImage?.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
        let backdropImageData = selectedBackdropImage?.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
        
        let newMovie = MovieModel(
            title: title,
            genre: genre,
            description: description,
            duration: duration,
            posterImageData: posterImageData,
            backdropImageData: backdropImageData,
            isPurchased: false,
            isFavorite: false,
            isWatched: false,
            watchProgress: 0.0,
            releaseDate: releaseDate,
            rating: Double(rating) ?? 0.0,
            imdbRating: Double(imdbRating),
            rottenTomatoesScore: Int(rottenTomatoesScore),
            director: director,
            cast: cast.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            language: language,
            subtitlesAvailable: subtitlesAvailable,
            trailerURL: trailerURL.isEmpty ? nil : trailerURL,
            price: Double(price),
            reviews: [],
            categories: categories.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            streamingPlatforms: streamingPlatforms.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            personalNotes: personalNotes,
            tags: tags.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            seasons: Int(seasons),
            episodes: Int(episodes),
            contentType: contentType,
            ageRating: ageRating,
            country: country,
            budget: budget.isEmpty ? nil : budget,
            boxOffice: boxOffice.isEmpty ? nil : boxOffice
        )
        
        dataManager.addMovie(newMovie)
        presentationMode.wrappedValue.dismiss()
    }
}

struct SectionSelector: View {
    @Binding var currentSection: Int
    
    private let sections = ["Basic Info", "Details", "Additional"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<sections.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        currentSection = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(sections[index])
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(currentSection == index ? .white : .gray)
                        
                        Rectangle()
                            .fill(currentSection == index ? Color.purple : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .background(Color.black.opacity(0.3))
    }
}

struct BasicInfoSection: View {
    @Binding var title: String
    @Binding var genre: String
    @Binding var description: String
    @Binding var duration: String
    @Binding var contentType: MovieModel.ContentType
    @Binding var selectedPosterImage: UIImage?
    @Binding var selectedBackdropImage: UIImage?
    @Binding var showingPosterPicker: Bool
    @Binding var showingBackdropPicker: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Images Section
            VStack(spacing: 16) {
                Text("Images")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    // Poster Image
                    VStack(spacing: 8) {
                        Text("Poster")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Button(action: { showingPosterPicker = true }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 120, height: 180)
                                
                                if let image = selectedPosterImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 180)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    VStack {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 30))
                                            .foregroundColor(.gray)
                                        Text("Add Poster")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Backdrop Image
                    VStack(spacing: 8) {
                        Text("Backdrop")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Button(action: { showingBackdropPicker = true }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 160, height: 90)
                                
                                if let image = selectedBackdropImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 160, height: 90)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    VStack {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 24))
                                            .foregroundColor(.gray)
                                        Text("Add Backdrop")
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            
            // Basic Fields
            VStack(spacing: 16) {
                CustomTextField(
                    title: "Title *",
                    text: $title,
                    placeholder: "Enter movie title"
                )
                
                CustomTextField(
                    title: "Genre",
                    text: $genre,
                    placeholder: "Action, Drama, Comedy"
                )
                
                CustomTextField(
                    title: "Duration",
                    text: $duration,
                    placeholder: "2h 30min"
                )
                
                // Content Type Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Content Type")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Picker("Content Type", selection: $contentType) {
                        ForEach(MovieModel.ContentType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                CustomTextField(
                    title: "Description",
                    text: $description,
                    placeholder: "Enter movie description",
                    isMultiline: true
                )
            }
        }
    }
}

struct DetailedInfoSection: View {
    @Binding var releaseDate: String
    @Binding var rating: String
    @Binding var imdbRating: String
    @Binding var rottenTomatoesScore: String
    @Binding var director: String
    @Binding var cast: String
    @Binding var language: String
    @Binding var subtitlesAvailable: Bool
    @Binding var trailerURL: String
    @Binding var price: String
    @Binding var ageRating: String
    @Binding var country: String
    @Binding var budget: String
    @Binding var boxOffice: String
    
    var body: some View {
        VStack(spacing: 16) {
            CustomTextField(title: "Release Date", text: $releaseDate, placeholder: "January 1, 2024")
            CustomTextField(title: "Rating (1-10)", text: $rating, placeholder: "8.5", keyboardType: .decimalPad)
            CustomTextField(title: "IMDb Rating", text: $imdbRating, placeholder: "8.5", keyboardType: .decimalPad)
            CustomTextField(title: "Rotten Tomatoes Score", text: $rottenTomatoesScore, placeholder: "85", keyboardType: .numberPad)
            CustomTextField(title: "Director", text: $director, placeholder: "Director name")
            CustomTextField(title: "Cast", text: $cast, placeholder: "Actor 1, Actor 2, Actor 3")
            CustomTextField(title: "Language", text: $language, placeholder: "English")
            CustomTextField(title: "Age Rating", text: $ageRating, placeholder: "PG-13")
            CustomTextField(title: "Country", text: $country, placeholder: "USA")
            CustomTextField(title: "Budget", text: $budget, placeholder: "$100 million")
            CustomTextField(title: "Box Office", text: $boxOffice, placeholder: "$500 million")
            CustomTextField(title: "Trailer URL", text: $trailerURL, placeholder: "https://youtube.com/...")
            CustomTextField(title: "Price", text: $price, placeholder: "12.99", keyboardType: .decimalPad)
            
            // Subtitles Toggle
            HStack {
                Text("Subtitles Available")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Toggle("", isOn: $subtitlesAvailable)
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
            }
            .padding(.vertical, 8)
        }
    }
}

struct AdditionalInfoSection: View {
    @Binding var categories: String
    @Binding var streamingPlatforms: String
    @Binding var seasons: String
    @Binding var episodes: String
    @Binding var personalNotes: String
    @Binding var tags: String
    let contentType: MovieModel.ContentType
    
    var body: some View {
        VStack(spacing: 16) {
            CustomTextField(title: "Categories", text: $categories, placeholder: "Action, Superhero, Thriller")
            CustomTextField(title: "Streaming Platforms", text: $streamingPlatforms, placeholder: "Netflix, HBO Max, Disney+")
            
            if contentType == .tvShow || contentType == .webSeries {
                CustomTextField(title: "Seasons", text: $seasons, placeholder: "3", keyboardType: .numberPad)
                CustomTextField(title: "Episodes", text: $episodes, placeholder: "24", keyboardType: .numberPad)
            }
            
            CustomTextField(title: "Tags", text: $tags, placeholder: "must-watch, award-winner")
            CustomTextField(
                title: "Personal Notes",
                text: $personalNotes,
                placeholder: "Your thoughts about this movie...",
                isMultiline: true
            )
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            if isMultiline {
                TextEditor(text: $text)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    AddMovieView()
}

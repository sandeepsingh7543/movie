import SwiftUI
import PhotosUI

struct AddMovieView: View {
    @EnvironmentObject var movieStore: MovieStore
    @State private var title = ""
    @State private var description = ""
    @State private var genre = "Action"
    @State private var releaseDate = Date()
    @State private var selectedImage: PhotosPickerItem?
    @State private var posterImage: UIImage?
    @State private var showingSaveAlert = false
    
    let genres = ["Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Thriller", "Animation", "Documentary"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Add New Movie")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Poster Picker
                        VStack(spacing: 12) {
                            if let posterImage = posterImage {
                                Image(uiImage: posterImage)
                                    .resizable()
                                    .aspectRatio(2/3, contentMode: .fit)
                                    .frame(maxHeight: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            } else {
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 200)
                                    .overlay(
                                        VStack {
                                            Image(systemName: "photo")
                                                .font(.system(size: 40))
                                                .foregroundColor(.gold)
                                            Text("Select Poster")
                                                .foregroundColor(.gold)
                                        }
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            
                            PhotosPicker(selection: $selectedImage, matching: .images) {
                                Text("Choose Poster")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(Capsule().fill(Color.gold))
                            }
                        }
                        
                        // Form Fields
                        VStack(spacing: 16) {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Movie Title")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gold)
                                
                                TextField("Enter movie title", text: $title)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gold.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gold)
                                
                                TextEditor(text: $description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .frame(minHeight: 80)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gold.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            // Genre
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Genre")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gold)
                                
                                Picker("Genre", selection: $genre) {
                                    ForEach(genres, id: \.self) { genre in
                                        Text(genre).tag(genre)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gold.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            }
                            
                            // Date
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Release Date")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gold)
                                
                                DatePicker("", selection: $releaseDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gold.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                            }
                            
                            // Save Button
                            Button(action: saveMovie) {
                                Text("Save Movie")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(title.isEmpty ? Color.gray : Color.gold)
                                    )
                            }
                            .disabled(title.isEmpty)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .onChange(of: selectedImage) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    posterImage = image
                }
            }
        }
        .alert("Movie Saved!", isPresented: $showingSaveAlert) {
            Button("OK") {
                clearForm()
            }
        } message: {
            Text("Your movie has been added successfully!")
        }
    }
    
    private func saveMovie() {
        let posterData = posterImage?.jpegData(compressionQuality: 0.8)
        let movie = UserMovie(
            title: title,
            description: description,
            genre: genre,
            releaseDate: releaseDate,
            posterData: posterData
        )
        movieStore.addMovie(movie)
        showingSaveAlert = true
    }
    
    private func clearForm() {
        title = ""
        description = ""
        genre = "Action"
        releaseDate = Date()
        posterImage = nil
        selectedImage = nil
    }
}

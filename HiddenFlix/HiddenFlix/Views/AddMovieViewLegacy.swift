import SwiftUI
import CoreData

struct AddMovieViewLegacy: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var releaseYear = Calendar.current.component(.year, from: Date())
    @State private var rating = 5.0
    @State private var genre = "Action"
    @State private var cast = ""
    @State private var trailerURL = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    let genres = ["Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Thriller", "Animation", "Documentary", "Fantasy"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        posterSection
                        
                        VStack(spacing: 16) {
                            CustomTextField(title: "Movie Title", text: $title)
                            
                            CustomTextEditor(title: "Description", text: $description)
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Release Year")
                                        .font(.custom("Inter", size: 14).weight(.medium))
                                        .foregroundColor(.gray)
                                    
                                    TextField("Year", value: $releaseYear, format: .number)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Rating")
                                        .font(.custom("Inter", size: 14).weight(.medium))
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Text(String(format: "%.1f", rating))
                                            .font(.custom("Inter", size: 16).weight(.medium))
                                            .foregroundColor(.white)
                                            .frame(width: 40)
                                        
                                        Slider(value: $rating, in: 0...10, step: 0.1)
                                            .accentColor(.purple)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Genre")
                                    .font(.custom("Inter", size: 14).weight(.medium))
                                    .foregroundColor(.gray)
                                
                                Picker("Genre", selection: $genre) {
                                    ForEach(genres, id: \.self) { genre in
                                        Text(genre).tag(genre)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                            
                            CustomTextField(title: "Cast", text: $cast)
                            
                            CustomTextField(title: "Trailer URL (Optional)", text: $trailerURL)
                        }
                        
                        Button(action: saveMovie) {
                            Text("Add Movie")
                                .font(.custom("Inter", size: 18).weight(.semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(.purple)
                                .cornerRadius(28)
                        }
                        .disabled(title.isEmpty || description.isEmpty)
                        .opacity(title.isEmpty || description.isEmpty ? 0.5 : 1.0)
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private var posterSection: some View {
        VStack(spacing: 16) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 180)
                    .clipped()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(width: 120, height: 180)
                    .overlay {
                        VStack {
                            Image(systemName: "photo")
                                .font(.title)
                                .foregroundColor(.gray)
                            Text("Add Poster")
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.gray)
                        }
                    }
            }
            
            Button(action: { showingImagePicker = true }) {
                Text("Choose Poster")
                    .font(.custom("Inter", size: 14).weight(.medium))
                    .foregroundColor(.purple)
            }
        }
    }
    
    private func saveMovie() {
        let movie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: viewContext) as! Movie
        movie.id = UUID()
        movie.title = title
        movie.movieDescription = description
        movie.releaseYear = Int16(releaseYear)
        movie.rating = rating
        movie.genre = genre
        movie.cast = cast.isEmpty ? nil : cast
        movie.trailerURL = trailerURL.isEmpty ? nil : trailerURL
        movie.posterImageData = selectedImage?.jpegData(compressionQuality: 0.8)
        movie.isFavorite = false
        movie.isInWatchlist = false
        movie.dateAdded = Date()
        movie.isAIGenerated = false
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving movie: \(error)")
        }
    }
}

#Preview {
    AddMovieViewLegacy()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

import SwiftUI
import CoreData

struct AIMovieGeneratorView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedGenre = "Sci-Fi"
    @State private var selectedMood = "Exciting"
    @State private var isGenerating = false
    @State private var generatedMovie: GeneratedMovie?
    
    let genres = ["Sci-Fi", "Action", "Drama", "Comedy", "Horror", "Romance", "Thriller", "Fantasy"]
    let moods = ["Exciting", "Mysterious", "Heartwarming", "Dark", "Uplifting", "Intense", "Whimsical"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        if let movie = generatedMovie {
                            generatedMovieSection(movie: movie)
                        } else {
                            generatorSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("AI Movie Generator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.purple)
            
            Text("AI Movie Generator")
                .font(.custom("Inter", size: 24).weight(.bold))
                .foregroundColor(.white)
            
            Text("Let AI create unique movie ideas for you")
                .font(.custom("Inter", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
    
    private var generatorSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Select Genre")
                    .font(.custom("Inter", size: 18).weight(.semibold))
                    .foregroundColor(.white)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(genres, id: \.self) { genre in
                        Button(action: { selectedGenre = genre }) {
                            Text(genre)
                                .font(.custom("Inter", size: 14).weight(.medium))
                                .foregroundColor(selectedGenre == genre ? .black : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedGenre == genre ? .white : .gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Select Mood")
                    .font(.custom("Inter", size: 18).weight(.semibold))
                    .foregroundColor(.white)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(moods, id: \.self) { mood in
                        Button(action: { selectedMood = mood }) {
                            Text(mood)
                                .font(.custom("Inter", size: 14).weight(.medium))
                                .foregroundColor(selectedMood == mood ? .black : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedMood == mood ? .white : .gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            Button(action: generateMovie) {
                HStack {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "sparkles")
                    }
                    
                    Text(isGenerating ? "Generating..." : "Generate Movie")
                }
                .font(.custom("Inter", size: 18).weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.purple)
                .cornerRadius(28)
            }
            .disabled(isGenerating)
        }
    }
    
    private func generatedMovieSection(movie: GeneratedMovie) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text(movie.title)
                    .font(.custom("Inter", size: 24).weight(.bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    Text(movie.genre)
                        .font(.custom("Inter", size: 14).weight(.medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.purple.opacity(0.3))
                        .cornerRadius(12)
                    
                    Text("\(movie.year)")
                        .font(.custom("Inter", size: 14).weight(.medium))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", movie.rating))
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(.white)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Synopsis")
                    .font(.custom("Inter", size: 18).weight(.semibold))
                    .foregroundColor(.white)
                
                Text(movie.description)
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !movie.cast.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cast")
                        .font(.custom("Inter", size: 18).weight(.semibold))
                        .foregroundColor(.white)
                    
                    Text(movie.cast)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 12) {
                Button(action: { generatedMovie = nil }) {
                    Text("Generate Another")
                        .font(.custom("Inter", size: 16).weight(.medium))
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(.purple.opacity(0.1))
                        .cornerRadius(24)
                }
                
                Button(action: { saveGeneratedMovie(movie) }) {
                    Text("Add to Collection")
                        .font(.custom("Inter", size: 16).weight(.medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(.purple)
                        .cornerRadius(24)
                }
            }
        }
    }
    
    private func generateMovie() {
        isGenerating = true
        
        // Simulate AI generation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            generatedMovie = createAIMovie(genre: selectedGenre, mood: selectedMood)
            isGenerating = false
        }
    }
    
    private func createAIMovie(genre: String, mood: String) -> GeneratedMovie {
        let movieTemplates = getMovieTemplates(for: genre, mood: mood)
        let template = movieTemplates.randomElement()!
        
        return GeneratedMovie(
            title: template.title,
            description: template.description,
            genre: genre,
            year: Int.random(in: 2020...2025),
            rating: Double.random(in: 7.0...9.5),
            cast: template.cast
        )
    }
    
    private func getMovieTemplates(for genre: String, mood: String) -> [MovieTemplate] {
        switch (genre, mood) {
        case ("Sci-Fi", "Exciting"):
            return [
                MovieTemplate(title: "Quantum Horizon", description: "When a team of scientists discovers a way to manipulate quantum reality, they must race against time to prevent a catastrophic collapse of multiple dimensions.", cast: "Dr. Sarah Chen, Marcus Rodriguez, Elena Vasquez"),
                MovieTemplate(title: "Neural Storm", description: "In a future where minds can be digitized, a hacker discovers a conspiracy that threatens to erase human consciousness forever.", cast: "Alex Turner, Maya Patel, Dr. James Wright")
            ]
        case ("Action", "Intense"):
            return [
                MovieTemplate(title: "Shadow Protocol", description: "A former special ops agent must infiltrate a high-tech fortress to rescue hostages and uncover a global conspiracy.", cast: "Jake Morrison, Lisa Kane, Viktor Petrov"),
                MovieTemplate(title: "Velocity", description: "When a city's transportation system is hacked, a transit cop and a tech expert must stop the chaos before millions die.", cast: "Officer Maria Santos, David Kim, Rachel Foster")
            ]
        default:
            return [
                MovieTemplate(title: "The Last Echo", description: "A mysterious story that unfolds across time and space, challenging everything we know about reality.", cast: "Emma Thompson, Michael Chen, Sarah Williams"),
                MovieTemplate(title: "Beyond Tomorrow", description: "An epic journey that explores the boundaries of human potential and the power of hope.", cast: "Ryan Davis, Anna Rodriguez, Dr. Lisa Park")
            ]
        }
    }
    
    private func saveGeneratedMovie(_ movie: GeneratedMovie) {
        let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: viewContext) as! Movie
        newMovie.id = UUID()
        newMovie.title = movie.title
        newMovie.movieDescription = movie.description
        newMovie.releaseYear = Int16(movie.year)
        newMovie.rating = movie.rating
        newMovie.genre = movie.genre
        newMovie.cast = movie.cast
        newMovie.isFavorite = false
        newMovie.isInWatchlist = false
        newMovie.dateAdded = Date()
        newMovie.isAIGenerated = true
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving generated movie: \(error)")
        }
    }
}

struct GeneratedMovie {
    let title: String
    let description: String
    let genre: String
    let year: Int
    let rating: Double
    let cast: String
}

struct MovieTemplate {
    let title: String
    let description: String
    let cast: String
}

#Preview {
    AIMovieGeneratorView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

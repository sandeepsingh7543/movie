import SwiftUI

struct HomeView: View {
    @EnvironmentObject var movieStore: MovieStore
    @State private var showingAddMovie = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.8),
                        Color.purple.opacity(0.6),
                        Color.pink.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Welcome to")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Arab Film House")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            
                            Button(action: {
                                showingAddMovie = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Add Movie Button (Prominent)
                        Button(action: {
                            showingAddMovie = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Add Your Movie")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        
                        if movieStore.movies.isEmpty {
                            // Empty state
                            VStack(spacing: 20) {
                                Image(systemName: "film.stack")
                                    .font(.system(size: 80))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text("Start Your Collection")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Tap the '+' button above to manually add movies to your personal collection. You can track films you own or want to watch.")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .padding(.vertical, 60)
                        } else {
                            // Featured Movie
                            if let featuredMovie = movieStore.movies.first {
                                FeaturedMovieCard(movie: featuredMovie)
                                    .environmentObject(movieStore)
                            }
                            
                            // All Movies Section
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Your Movies")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(movieStore.movies.count) movies")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(movieStore.movies.prefix(10)) { movie in
                                            NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(movieStore)) {
                                                MoviePosterCard(movie: movie)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Categories
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Browse by Genre")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                    GenreCard(title: "Action", icon: "bolt.fill", color: .red)
                                        .environmentObject(movieStore)
                                    GenreCard(title: "Drama", icon: "theatermasks.fill", color: .blue)
                                        .environmentObject(movieStore)
                                    GenreCard(title: "Comedy", icon: "face.smiling.fill", color: .yellow)
                                        .environmentObject(movieStore)
                                    GenreCard(title: "Romance", icon: "heart.fill", color: .pink)
                                        .environmentObject(movieStore)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddMovie) {
                AddMovieView()
                    .environmentObject(movieStore)
            }
        }
    }
}

struct FeaturedMovieCard: View {
    let movie: Movie
    @EnvironmentObject var movieStore: MovieStore
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 300)
                
//                if let imageData = movie.posterImageData,
//                   let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 300)
//                        .clipped()
//                        .cornerRadius(20)
//                        .overlay(
//                            LinearGradient(
//                                colors: [Color.black.opacity(0.6), Color.clear],
//                                startPoint: .bottom,
//                                endPoint: .top
//                            )
//                            .cornerRadius(20)
//                        )
                if let imageData = movie.posterImageData,
                   let uiImage = UIImage(data: imageData) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 16)
                        .frame(height: 300)
                        .clipped()
                        .cornerRadius(20)
                        .overlay(
                            LinearGradient(
                                colors: [Color.black.opacity(0.6), Color.clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .cornerRadius(20)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color.black.opacity(0.3), Color.clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(movie.genre)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", movie.rating))
                                    .foregroundColor(.white)
                                Text("• \(movie.duration)")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .font(.caption)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            
            HStack(spacing: 15) {
                NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(movieStore)) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Details")
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(25)
                }
                
                Button(action: {
                    movieStore.toggleWatchlist(movie: movie)
                }) {
                    HStack {
                        Image(systemName: movie.isWatchlisted ? "bookmark.fill" : "bookmark")
                        Text("Watchlist")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(25)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

struct MoviePosterCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 180)
                
                if let imageData = movie.posterImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 180)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    VStack {
                        Image(systemName: "film.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                        Text(movie.title)
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(movie.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .frame(width: 120)
    }
}

struct GenreCard: View {
    let title: String
    let icon: String
    let color: Color
    @EnvironmentObject var movieStore: MovieStore
    
    var body: some View {
        NavigationLink(destination: GenreMoviesView(genre: title).environmentObject(movieStore)) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
        }
    }
}

struct GenreMoviesView: View {
    let genre: String
    @EnvironmentObject var movieStore: MovieStore
    @Environment(\.presentationMode) var presentationMode
    
    var filteredMovies: [Movie] {
        movieStore.movies.filter { movie in
            movie.genre.localizedCaseInsensitiveContains(genre)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.8),
                    Color.blue.opacity(0.6),
                    Color.teal.opacity(0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Text("\(genre) Movies")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                
                if filteredMovies.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "film.stack")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("No \(genre) Movies")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Add movies with \(genre) genre to see them here")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                            ForEach(filteredMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(movieStore)) {
                                    GenreMovieCard(movie: movie)
                                        .environmentObject(movieStore)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct GenreMovieCard: View {
    let movie: Movie
    @EnvironmentObject var movieStore: MovieStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Movie poster
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 220)
                
                if let imageData = movie.posterImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 220)
                        .clipped()
                        .cornerRadius(15)
                } else {
                    VStack {
                        Image(systemName: "film.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(movie.title)
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 8)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(movie.genre)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", movie.rating))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        movieStore.toggleWatchlist(movie: movie)
                    }) {
                        Image(systemName: movie.isWatchlisted ? "bookmark.fill" : "bookmark")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}

#Preview {
    HomeView()
        .environmentObject(MovieStore())
}

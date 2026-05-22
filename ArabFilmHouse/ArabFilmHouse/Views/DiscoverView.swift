import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var movieStore: MovieStore
    @State private var selectedGenre = "All"
    
    let genres = ["All", "Action", "Drama", "Comedy", "Romance", "Adventure", "Historical", "Biography", "Family"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
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
                
                VStack(spacing: 0) {
                    // Header with search
                    VStack(spacing: 15) {
                        HStack {
                            Text("Discover")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.6))
                            
                            TextField("Search movies...", text: $movieStore.searchText)
                                .foregroundColor(.white)
                                .accentColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Genre filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(genres, id: \.self) { genre in
                                    Button(action: {
                                        selectedGenre = genre
                                    }) {
                                        Text(genre)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(selectedGenre == genre ? .black : .white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                selectedGenre == genre ? 
                                                Color.white : Color.white.opacity(0.2)
                                            )
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    
                    // Movies grid or empty state
                    ScrollView {
                        if filteredMovies.isEmpty {
                            VStack(spacing: 20) {
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text("No Movies Yet")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Go to the Home tab and tap the '+' button to manually add movies to your collection")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Spacer()
                            }
                            .frame(minHeight: 400)
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                ForEach(filteredMovies) { movie in
                                    NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(movieStore)) {
                                        DiscoverMovieCard(movie: movie)
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
    
    var filteredMovies: [Movie] {
        let searchFiltered = movieStore.filteredMovies
        
        if selectedGenre == "All" {
            return searchFiltered
        } else {
            return searchFiltered.filter { movie in
                movie.genre.localizedCaseInsensitiveContains(selectedGenre)
            }
        }
    }
}

//struct DiscoverMovieCard: View {
//    let movie: Movie
//    @EnvironmentObject var movieStore: MovieStore
//    let itemWidth = (UIScreen.main.bounds.width - 70) / 2
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            // Movie poster
//            ZStack {
//                RoundedRectangle(cornerRadius: 15)
//                    .fill(Color.white.opacity(0.1))
//                    .frame(height: 220)
//                
//                if let imageData = movie.posterImageData,
//                   let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: itemWidth)
//                        .frame(height: 220)
//                        .clipped()
//                        .cornerRadius(15)
//                } else {
//                    VStack {
//                        Image(systemName: "film.fill")
//                            .font(.system(size: 30))
//                            .foregroundColor(.white.opacity(0.6))
//                        
//                        Text(movie.title)
//                            .font(.caption)
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                            .lineLimit(2)
//                            .padding(.horizontal, 8)
//                    }
//                }
//            }
//            
//            VStack(alignment: .leading, spacing: 5) {
//                Text(movie.title)
//                    .font(.headline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .lineLimit(1)
//                
//                Text(movie.genre)
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.7))
//                    .lineLimit(1)
//                
//                HStack {
//                    HStack(spacing: 2) {
//                        Image(systemName: "star.fill")
//                            .foregroundColor(.yellow)
//                            .font(.caption)
//                        Text(String(format: "%.1f", movie.rating))
//                            .font(.caption)
//                            .foregroundColor(.white)
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        movieStore.toggleWatchlist(movie: movie)
//                    }) {
//                        Image(systemName: movie.isWatchlisted ? "bookmark.fill" : "bookmark")
//                            .foregroundColor(.white)
//                            .font(.caption)
//                    }
//                }
//            }
//        }
//        .padding(8)
//        .background(Color.white.opacity(0.05))
//        .cornerRadius(20)
//    }
//}
struct DiscoverMovieCard: View {
    let movie: Movie
    @EnvironmentObject var movieStore: MovieStore

    var body: some View {
        GeometryReader { geo in
            let itemWidth = (geo.size.width - 16)

            VStack(alignment: .leading, spacing: 10) {

                // Movie poster
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.1))

                    if let imageData = movie.posterImageData,
                       let uiImage = UIImage(data: imageData) {

                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: itemWidth, height: 300)
                            .clipped()
                            .cornerRadius(15)

                    } else {
                        VStack(spacing: 6) {
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

                        Button {
                            movieStore.toggleWatchlist(movie: movie)
                        } label: {
                            Image(systemName: movie.isWatchlisted ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(8)
            .background(Color.white.opacity(0.05))
            .cornerRadius(20)
        }
        .frame(height: 330) // 👈 important for GeometryReader
    }
}

#Preview {
    DiscoverView()
        .environmentObject(MovieStore())
}

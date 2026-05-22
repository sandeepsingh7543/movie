import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var movieStore: MovieStore
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [
                        Color.indigo.opacity(0.8),
                        Color.purple.opacity(0.6),
                        Color.pink.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        Text("My Watchlist")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        if !movieStore.watchlist.isEmpty {
                            Text("\(movieStore.watchlist.count) movies")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding()
                    
                    if movieStore.watchlist.isEmpty {
                        // Empty state
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "bookmark.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Your watchlist is empty")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("Add movies to your watchlist to watch them later")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                    } else {
                        // Watchlist content
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(movieStore.watchlist) { movie in
                                    NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(movieStore)) {
                                        WatchlistMovieCard(movie: movie)
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
}

struct WatchlistMovieCard: View {
    let movie: Movie
    @EnvironmentObject var movieStore: MovieStore
    
    var body: some View {
        HStack(spacing: 15) {
            // Movie poster
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 80, height: 120)
                
                if let imageData = movie.posterImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 120)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    VStack {
                        Image(systemName: "film.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(movie.title)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 4)
                    }
                }
            }
            
            // Movie info
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(movie.genre)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Text("• \(movie.duration)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text(movie.year)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Remove button
            Button(action: {
                movieStore.toggleWatchlist(movie: movie)
            }) {
                Image(systemName: "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
    }
}

#Preview {
    WatchlistView()
        .environmentObject(MovieStore())
}

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject var movieStore: MovieStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color.black.opacity(0.9),
                    Color.purple.opacity(0.6),
                    Color.blue.opacity(0.4)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header with back button
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Button(action: {
                            movieStore.toggleWatchlist(movie: movie)
                        }) {
                            Image(systemName: movie.isWatchlisted ? "bookmark.fill" : "bookmark")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    // Movie poster and basic info
                    VStack(spacing: 15) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 200, height: 300)
                            
                            if let imageData = movie.posterImageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 300)
                                    .clipped()
                                    .cornerRadius(20)
                            } else {
                                VStack {
                                    Image(systemName: "film.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Text(movie.title)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("\(movie.year) • \(movie.duration)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(movie.rating / 2) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                                Text(String(format: "%.1f", movie.rating))
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    // Action buttons
                    HStack(spacing: 15) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("Movie Info")
                            }
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                        }
                        
                        Button(action: {
                            movieStore.toggleWatchlist(movie: movie)
                        }) {
                            HStack {
                                Image(systemName: movie.isWatchlisted ? "bookmark.fill" : "bookmark")
                                Text(movie.isWatchlisted ? "In Watchlist" : "Add to Watchlist")
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Movie details
                    VStack(alignment: .leading, spacing: 20) {
                        // Description
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Synopsis")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(movie.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                        
                        // Details grid
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Details")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            VStack(spacing: 10) {
                                DetailRow(title: "Genre", value: movie.genre)
                                DetailRow(title: "Director", value: movie.director)
                                DetailRow(title: "Duration", value: movie.duration)
                                DetailRow(title: "Release Year", value: movie.year)
                                DetailRow(title: "Rating", value: String(format: "%.1f/10", movie.rating))
                            }
                        }
                        
                        // Cast
                        if !movie.cast.isEmpty && movie.cast.first?.name != "Unknown" {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Cast & Crew")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(movie.cast) { member in
                                            VStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.white.opacity(0.1))
                                                        .frame(width: 60, height: 60)
                                                    
                                                    if let imageData = member.imageData,
                                                       let uiImage = UIImage(data: imageData) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 60, height: 60)
                                                            .clipShape(Circle())
                                                    } else {
                                                        Image(systemName: "person.fill")
                                                            .foregroundColor(.white.opacity(0.6))
                                                            .font(.title2)
                                                    }
                                                }
                                                
                                                Text(member.name)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(2)
                                                
                                                Text(member.role)
                                                    .font(.caption2)
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 80)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie(
        title: "Sample Movie",
        year: "2024",
        genre: "Drama",
        rating: 8.5,
        duration: "2h 15m",
        description: "A sample movie description",
        cast: [
            CastMember(name: "Actor 1", role: "Actor"),
            CastMember(name: "Actor 2", role: "Actress")
        ],
        director: "Sample Director"
    ))
    .environmentObject(MovieStore())
}

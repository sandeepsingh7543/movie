import SwiftUI
import CoreData

struct RecommendationsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var movies: FetchedResults<Movie>
    
    @State private var recommendations: [Movie] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !recommendations.isEmpty {
                Text("Recommended for You")
                    .font(.custom("Inter", size: 20).weight(.semibold))
                    .foregroundColor(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(recommendations) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                RecommendationCardView(movie: movie)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            loadRecommendations()
        }
        .onChange(of: movies.count) { _ in
            loadRecommendations()
        }
    }
    
    private func loadRecommendations() {
        let movieArray = Array(movies)
        let userPreferences = UserPreferences(
            favoriteGenres: [],
            preferredRatingRange: 7.0...10.0,
            likesAIGenerated: true
        )
        
        recommendations = RecommendationService.shared.getRecommendations(
            for: userPreferences,
            from: movieArray
        )
    }
}

struct RecommendationCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [.purple.opacity(0.3), .blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(width: 120)
                
                if let imageData = movie.posterImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                        .frame(width: 120)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    VStack(spacing: 6) {
                        Image(systemName: "film.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(movie.title)
                            .font(.custom("Inter", size: 10).weight(.medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(8)
                    .frame(width: 120)
                    .frame(maxHeight: .infinity)
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.yellow)
                            
                            Text(String(format: "%.1f", movie.rating))
                                .font(.custom("Inter", size: 9).weight(.medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.black.opacity(0.6))
                        .cornerRadius(6)
                        
                        Spacer()
                    }
                }
                .padding(6)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(movie.title)
                    .font(.custom("Inter", size: 12).weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(movie.genre)
                    .font(.custom("Inter", size: 10))
                    .foregroundColor(.gray)
            }
            .frame(height: 32) // Fixed height for text section
        }
        .frame(width: 120)
    }
}

#Preview {
    RecommendationsView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .background(.black)
}

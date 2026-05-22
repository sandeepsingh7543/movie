import SwiftUI
import WebKit

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingTrailer = false
    @State private var showWatchlistMessage = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    
                    VStack(spacing: 24) {
                        movieInfo
                        
                        if let cast = movie.cast, !cast.isEmpty {
                            castSection(cast: cast)
                        }
                        
                        descriptionSection
                        
                        if movie.trailerURL != nil {
                            trailerSection
                        }
                        
                        actionButtons
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingTrailer) {
            if let urlString = movie.trailerURL, let url = URL(string: urlString) {
                TrailerView(url: url)
            }
        }
        .overlay(
            Group {
                if showWatchlistMessage {
                    Text(movie.isInWatchlist ? "Added to Watchlist" : "Removed from Watchlist")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                }
            }
            , alignment: .top)
    }
    
    private var headerSection: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                if let imageData = movie.posterImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill) // Center se fill
                        .frame(width: UIScreen.main.bounds.width, height: 400) // Full screen width, desired height
                        .clipped() // Overflow crop
                } else {
                    LinearGradient(colors: [.purple.opacity(0.6), .blue.opacity(0.4)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .frame(width: UIScreen.main.bounds.width, height: 400)
                        .overlay {
                            Image(systemName: "film.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.6))
                        }
                }
            }

            // Bottom gradient overlay
            LinearGradient(colors: [.clear, .black.opacity(0.8), .black],
                           startPoint: .top,
                           endPoint: .bottom)
                .frame(height: 200)
                .frame(maxHeight: .infinity, alignment: .bottom)

            // Top buttons
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.black.opacity(0.3))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Button(action: toggleFavorite) {
                        Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(movie.isFavorite ? .red : .white)
                            .padding(12)
                            .background(.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding()

                Spacer()
            }
        }
        .frame(height: 400)
    }
    
    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.custom("Inter", size: 28).weight(.bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        Text("\(movie.releaseYear)")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.gray)
                        
                        Text(movie.genre)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.purple)
                        
                        if movie.isAIGenerated {
                            HStack(spacing: 4) {
                                Image(systemName: "brain.head.profile")
                                Text("AI Generated")
                            }
                            .font(.custom("Inter", size: 12).weight(.medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.purple.opacity(0.3))
                            .cornerRadius(8)
                        }
                    }
                }
                
                Spacer()
            }
            
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.yellow)
                
                Text(String(format: "%.1f", movie.rating))
                    .font(.custom("Inter", size: 18).weight(.semibold))
                    .foregroundColor(.white)
                
                Text("/ 10")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func castSection(cast: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cast")
                .font(.custom("Inter", size: 18).weight(.semibold))
                .foregroundColor(.white)
            
            Text(cast)
                .font(.custom("Inter", size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Synopsis")
                .font(.custom("Inter", size: 18).weight(.semibold))
                .foregroundColor(.white)
            
            Text(movie.movieDescription)
                .font(.custom("Inter", size: 16))
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var trailerSection: some View {
        Button(action: { showingTrailer = true }) {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Watch Trailer")
                    .font(.custom("Inter", size: 16).weight(.medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(.purple.opacity(0.2))
            .cornerRadius(12)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button(action: toggleWatchlist) {
                HStack {
                    Image(systemName: movie.isInWatchlist ? "bookmark.fill" : "bookmark")
                    Text(movie.isInWatchlist ? "In Watchlist" : "Add to Watchlist")
                }
                .font(.custom("Inter", size: 16).weight(.medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(movie.isInWatchlist ? .purple : .gray.opacity(0.3))
                .cornerRadius(24)
            }
        }
    }
    
    private func toggleFavorite() {
        withAnimation(.spring()) {
            movie.isFavorite.toggle()
            try? viewContext.save()
        }
    }
    
    private func toggleWatchlist() {
        withAnimation(.spring()) {
            movie.isInWatchlist.toggle()
            try? viewContext.save()
        }
        // Show message
        showWatchlistMessage = true
        
        // Auto hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showWatchlistMessage = false
            }
        }
        dismiss()
    }
}

struct TrailerView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            WebView(url: url)
                .navigationTitle("Trailer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let movie = Movie(context: context)
    movie.title = "Sample Movie"
    movie.movieDescription = "This is a sample movie description that tells the story of an amazing adventure."
    movie.genre = "Action"
    movie.releaseYear = 2024
    movie.rating = 8.5
    movie.cast = "John Doe, Jane Smith"
    movie.isAIGenerated = true
    
    return MovieDetailView(movie: movie)
}

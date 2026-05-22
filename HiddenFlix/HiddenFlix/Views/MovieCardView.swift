import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isPressed = false
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                // Background with consistent aspect ratio
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.4),
                                Color.blue.opacity(0.3),
                                Color.indigo.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .aspectRatio(2/3, contentMode: .fit)
                    .shadow(color: .purple.opacity(0.2), radius: 6, x: 0, y: 3)
                
                if let imageData = movie.posterImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                        .clipped()
                        .cornerRadius(16)
                        .overlay(
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.3)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .cornerRadius(16)
                        )
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "film.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(movie.title)
                            .font(.custom("Inter", size: 12).weight(.medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Overlay content
                VStack {
                    HStack {
                        if movie.isAIGenerated {
                            HStack(spacing: 4) {
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 8))
                                Text("AI")
                                    .font(.custom("Inter", size: 8).weight(.bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.purple.opacity(0.6), lineWidth: 0.5)
                                    )
                            )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                toggleFavorite()
                            }
                        }) {
                            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 12))
                                .foregroundColor(movie.isFavorite ? .red : .white)
                                .scaleEffect(movie.isFavorite ? 1.1 : 1.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                    
                    HStack {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.yellow)
                            
                            Text(String(format: "%.1f", movie.rating))
                                .font(.custom("Inter", size: 10).weight(.bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                        
                        Spacer()
                    }
                }
                .padding(8)
            }
            
            // Movie info with fixed height
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.custom("Inter", size: 14).weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(movie.genre)
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.purple.opacity(0.9))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(.purple.opacity(0.15))
                        )
                    
                    Text("\(movie.releaseYear)")
                        .font(.custom("Inter", size: 10))
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 40) // Fixed height for consistency
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                    isPressed = false
                }
                showingDetails = true
            }
        }
        .sheet(isPresented: $showingDetails) {
            MovieDetailView(movie: movie)
        }
    }
    
    private func toggleFavorite() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        movie.isFavorite.toggle()
        try? viewContext.save()
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let movie = Movie(context: context)
    movie.title = "Quantum Dreams"
    movie.genre = "Sci-Fi"
    movie.releaseYear = 2024
    movie.rating = 8.5
    movie.isAIGenerated = true
    
    return MovieCardView(movie: movie)
        .frame(width: 160)
        .background(.black)
        .padding()
}

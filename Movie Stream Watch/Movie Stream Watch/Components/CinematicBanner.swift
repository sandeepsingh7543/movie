import SwiftUI

struct CinematicBanner: View {
    let movie: Movie?
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let movie = movie {
                // Blurred background
                PosterImage(posterData: movie.posterData)
                    .blur(radius: 1)
                    .overlay(
                        LinearGradient(
                            colors: [.clear, Color.appBackground],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                // Content
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title ?? "")
                        .font(.appTitle)
                        .foregroundColor(.white)

                    HStack(spacing: 10) {
                        if let genre = movie.genre, !genre.isEmpty {
                            GenrePill(genre: genre)
                        }
                        RatingView(rating: movie.rating, compact: true)
                    }
                    
//                    Button {
//                        // Watch action
//                    } label: {
//                        Text("Watch Now")
//                            .font(.appBody)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 24)
//                            .padding(.vertical, 10)
//                            .background(Color.primaryGradient)
//                            .cornerRadius(20)
//                    }
                }
                .padding(40)
            } else {
                // Branding placeholder
                LinearGradient(
                    colors: [.appPrimary.opacity(0.4), .appSecondary.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 48))
                        Text("Movie Stream Watch")
                            .font(.appTitle)
                    }
                    .foregroundColor(.white.opacity(0.7))
                )
            }
        }
        .frame(height: 400)
        .clipped()
        .fadeIn(appeared)
        .onAppear { appeared = true }
    }
}

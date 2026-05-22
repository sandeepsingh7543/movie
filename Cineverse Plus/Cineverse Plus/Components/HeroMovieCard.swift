import SwiftUI

struct HeroMovieCard: View {
    let title: String
    let posterData: Data?
    let genre: String
    let rating: Double

    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background
            if let data = posterData, let uiImage = UIImage(data: data) {
                GeometryReader { geo in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: 400)
                        .clipped()
                }
            } else {
                CineverseTheme.purpleBlueGradient
                    .overlay(
                        Image(systemName: "film")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                    )
            }

            // Shimmer
            GeometryReader { geo in
                LinearGradient(
                    colors: [.clear, .white.opacity(0.08), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: geo.size.width * 0.4)
                .offset(x: shimmerOffset * geo.size.width)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                        shimmerOffset = 1.4
                    }
                }
            }

            // Gradient overlay + info
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text(title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                Text(genre)
                    .font(.subheadline)
                    .foregroundColor(CineverseTheme.lightGray)
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: Double(i) <= rating ? "star.fill" : (Double(i) - 0.5 <= rating ? "star.leadinghalf.filled" : "star"))
                            .font(.caption)
                            .foregroundColor(CineverseTheme.neonPurple)
                    }
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundColor(CineverseTheme.lightGray)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(CineverseTheme.heroGradient)
        }
        .frame(height: 400)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

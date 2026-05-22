import SwiftUI

struct MovieCard: View {
    let title: String
    let posterData: Data?
    let rating: Double
    let progress: Double

    var body: some View {
        ZStack(alignment: .bottom) {
            // Poster or placeholder
            if let data = posterData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 240)
                    .clipped()
            } else {
                CineverseTheme.purpleBlueGradient
                    .overlay(
                        Image(systemName: "film")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.5))
                    )
            }

            // Rating badge
            VStack {
                HStack {
                    Spacer()
                    Text(String(format: "%.1f", rating))
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(CineverseTheme.neonPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(8)
                }
                Spacer()
            }

            // Title overlay
            VStack(spacing: 0) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(.ultraThinMaterial)

                if progress > 0 {
                    GeometryReader { geo in
                        CineverseTheme.purpleBlueGradient
                            .frame(width: geo.size.width * progress)
                    }
                    .frame(height: 3)
                    .background(Color.white.opacity(0.2))
                }
            }
        }
        .frame(width: 160, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

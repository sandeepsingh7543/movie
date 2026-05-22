import SwiftUI

struct PosterView: View {
    let posterPath: String?
    let title: String
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        ZStack {
            if let image = ImageManager.shared.swiftUIImage(for: posterPath) {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(colors: [palette.chipFill, palette.subtleFill], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack(spacing: 10) {
                    Image(systemName: "film")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(palette.textSecondary)
                    Text(title.prefix(2).uppercased())
                        .font(.headline.weight(.bold))
                        .foregroundStyle(palette.textSecondary)
                }
            }
        }
        .frame(width: 92, height: 138)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(palette.surfaceStroke, lineWidth: 1)
        )
    }
}

import SwiftUI

struct PosterImage: View {
    let posterData: Data?

    var body: some View {
        if let data = posterData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            LinearGradient(
                colors: [.appPrimary.opacity(0.6), .appSecondary.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                Image(systemName: "film")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.5))
            )
        }
    }
}

import SwiftUI

// MARK: - Poster Image View
struct PosterImageView: View {
    let url: URL?
    var width: CGFloat
    var height: CGFloat

    @State private var localImage: UIImage? = nil

    var body: some View {
        ZStack {
            Color.appSurface // always-visible base — no black screen

            if let img = localImage {
                Image(uiImage: img).resizable().scaledToFill()
            } else if let url, !url.isFileURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default: filmIcon
                    }
                }
            } else if url == nil {
                filmIcon
            }
            // while file loading: just shows appSurface background
        }
        .frame(width: width, height: height)
        .clipped()
        .task(id: url?.absoluteString) {
            // Reset on url change
            localImage = nil
            guard let url, url.isFileURL else { return }
            let img = await Task.detached(priority: .userInitiated) {
                (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
            }.value
            localImage = img
        }
    }

    private var filmIcon: some View {
        Image(systemName: "film")
            .font(.system(size: 30))
            .foregroundColor(.appSecondary.opacity(0.4))
    }
}

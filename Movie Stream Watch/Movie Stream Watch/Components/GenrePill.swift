import SwiftUI

struct GenrePill: View {
    let genre: String

    var body: some View {
        Text("\(genre.genreEmoji) \(genre)")
            .font(.appCaption)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.appSecondary.opacity(0.3))
            .clipShape(Capsule())
    }
}

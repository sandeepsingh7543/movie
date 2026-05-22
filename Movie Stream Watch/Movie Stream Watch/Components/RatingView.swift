import SwiftUI

struct RatingView: View {
    let rating: Double
    var compact: Bool = false

    private var starSize: CGFloat { compact ? 12 : 16 }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: starIcon(for: index))
                    .font(.system(size: starSize))
                    .foregroundColor(.yellow)
            }
        }
    }

    private func starIcon(for index: Int) -> String {
        let value = rating
        if Double(index) <= value { return "star.fill" }
        if Double(index) - 0.5 <= value { return "star.leadinghalf.filled" }
        return "star"
    }
}

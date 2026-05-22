import SwiftUI

struct RatingStarsView: View {
    let rating: Double
    let maxStars: Int
    let size: CGFloat

    init(rating: Double, maxStars: Int = 5, size: CGFloat = 13) {
        self.rating = rating
        self.maxStars = maxStars
        self.size = size
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxStars, id: \.self) { index in
                let starValue = Double(index + 1)
                Image(systemName: rating >= starValue ? "star.fill" : (rating >= starValue - 0.5 ? "star.leadinghalf.filled" : "star"))
                    .font(.system(size: size, weight: .semibold))
                    .foregroundStyle(rating >= starValue ? Color(hex: 0xFFD166) : Color.white.opacity(0.35))
            }
        }
    }
}


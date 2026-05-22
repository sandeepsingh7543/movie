import SwiftUI

struct SectionHeader: View {
    let title: String
    var onSeeAll: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            if let onSeeAll {
                Button("See All", action: onSeeAll)
                    .font(.subheadline)
                    .foregroundColor(CineverseTheme.neonPurple)
            }
        }
    }
}

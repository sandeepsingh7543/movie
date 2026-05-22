import SwiftUI

struct PremiumSectionHeader: View {
    let title: String
    let subtitle: String?
    @Environment(\.starmaxPalette) private var palette

    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(palette.textPrimary)

            if let subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(palette.textSecondary)
            }
        }
    }
}

import SwiftUI

struct EmptyLibraryView: View {
    let searchText: String
    let filterOption: MovieFilterOption
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(palette.chipFill)
                    .frame(width: 96, height: 96)
                Image(systemName: "film.stack.fill")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(palette.textPrimary)
            }

            VStack(spacing: 8) {
                Text(searchText.isEmpty ? "No movies yet" : "No results")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(palette.textPrimary)

                Text(searchText.isEmpty
                     ? "Add the first movie in your personal library. Starmax stays fully offline and stores everything on-device."
                     : "Try a different search, sort, or filter to surface your private library.")
                    .font(.subheadline)
                    .foregroundStyle(palette.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 14)
            }

            if filterOption != .all || !searchText.isEmpty {
                Label("Filters are active", systemImage: "slider.horizontal.3")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(palette.textPrimary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(palette.chipFill, in: Capsule())
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .starmaxCard()
    }
}

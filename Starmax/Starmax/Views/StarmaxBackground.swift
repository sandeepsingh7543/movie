import SwiftUI

struct StarmaxBackground: View {
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        ZStack {
            LinearGradient(colors: palette.backgroundGradients, startPoint: .topLeading, endPoint: .bottomTrailing)

            RadialGradient(
                colors: [palette.accentColor.opacity(palette.isDark ? 0.28 : 0.18), .clear],
                center: .topTrailing,
                startRadius: 10,
                endRadius: 420
            )

            RadialGradient(
                colors: [palette.isDark ? Color.white.opacity(0.06) : Color.black.opacity(0.04), .clear],
                center: .bottomLeading,
                startRadius: 20,
                endRadius: 460
            )

            LinearGradient(
                colors: [palette.isDark ? Color.black.opacity(0.15) : Color.white.opacity(0.35), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

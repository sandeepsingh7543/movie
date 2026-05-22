import SwiftUI

struct MovieStatusBadge: View {
    let status: MovieStatus
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        Text(status.rawValue)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(status == .watched ? Color(hex: 0x8EF7C9) : Color(hex: 0xFFD166))
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 999, style: .continuous)
                    .fill((status == .watched ? Color(hex: 0x8EF7C9) : Color(hex: 0xFFD166)).opacity(palette.isDark ? 0.12 : 0.16))
            )
    }
}

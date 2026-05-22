import SwiftUI

struct CollectionChip: View {
    let name: String
    let accentHex: String?
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        Text(name)
            .font(.caption.weight(.semibold))
            .foregroundStyle(palette.textPrimary)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                Capsule(style: .continuous)
                    .fill(Color(hex: hexValue).opacity(palette.isDark ? 0.18 : 0.12))
            )
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(Color(hex: hexValue).opacity(palette.isDark ? 0.35 : 0.22), lineWidth: 1)
            )
    }

    private var hexValue: UInt32 {
        guard let accentHex else { return 0x89C2FF }
        return UInt32(accentHex.replacingOccurrences(of: "#", with: ""), radix: 16) ?? 0x89C2FF
    }
}

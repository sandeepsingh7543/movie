import SwiftUI

struct MoodTagChip: View {
    let mood: MoodTag
    var selected: Bool = false
    @Environment(\.starmaxPalette) private var palette

    var body: some View {
        Label(mood.rawValue, systemImage: mood.symbol)
            .font(.caption.weight(.semibold))
            .foregroundStyle(selected ? palette.inverseText : palette.textPrimary)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                Capsule(style: .continuous)
                    .fill(selected ? palette.textPrimary : palette.chipFill)
            )
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(palette.surfaceStroke.opacity(selected ? 0.0 : 1.0), lineWidth: 1)
            )
    }
}

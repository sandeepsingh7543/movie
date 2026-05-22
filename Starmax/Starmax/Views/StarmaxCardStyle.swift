import SwiftUI

struct StarmaxCardStyle: ViewModifier {
    @Environment(\.starmaxPalette) private var palette

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(palette.surfaceFill, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(palette.surfaceStroke, lineWidth: 1)
            )
            .shadow(color: palette.surfaceShadow, radius: 18, x: 0, y: 10)
    }
}

extension View {
    func starmaxCard() -> some View {
        modifier(StarmaxCardStyle())
    }
}

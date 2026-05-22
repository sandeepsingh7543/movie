import SwiftUI

// MARK: - Haptic Feedback
enum HapticStyle {
    case light, medium, heavy, success, warning, error, selection
}

func haptic(_ style: HapticStyle) {
    switch style {
    case .light:     UIImpactFeedbackGenerator(style: .light).impactOccurred()
    case .medium:    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    case .heavy:     UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    case .success:   UINotificationFeedbackGenerator().notificationOccurred(.success)
    case .warning:   UINotificationFeedbackGenerator().notificationOccurred(.warning)
    case .error:     UINotificationFeedbackGenerator().notificationOccurred(.error)
    case .selection: UISelectionFeedbackGenerator().selectionChanged()
    }
}

// MARK: - View Modifiers
struct PressEffect: ViewModifier {
    @State private var pressed = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(pressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: pressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in pressed = true }
                    .onEnded { _ in pressed = false }
            )
    }
}

extension View {
    func pressEffect() -> some View { modifier(PressEffect()) }
}

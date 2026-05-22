import SwiftUI

extension Double {
    var starRating: String {
        String(repeating: "⭐", count: min(max(Int(rounded()), 0), 5))
    }
}

extension Int16 {
    var durationFormatted: String {
        let h = self / 60
        let m = self % 60
        return h > 0 ? (m > 0 ? "\(h)h \(m)m" : "\(h)h") : "\(m)m"
    }
}

extension Date {
    var timeAgo: String {
        let seconds = Int(Date().timeIntervalSince(self))
        if seconds < 60 { return "Just now" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes) minute\(minutes == 1 ? "" : "s") ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours) hour\(hours == 1 ? "" : "s") ago" }
        let days = hours / 24
        if days < 30 { return "\(days) day\(days == 1 ? "" : "s") ago" }
        let months = days / 30
        if months < 12 { return "\(months) month\(months == 1 ? "" : "s") ago" }
        let years = months / 12
        return "\(years) year\(years == 1 ? "" : "s") ago"
    }
}

extension View {
    func fadeIn(delay: Double) -> some View {
        modifier(FadeInModifier(delay: delay))
    }
}

private struct FadeInModifier: ViewModifier {
    let delay: Double
    @State private var opacity: Double = 0

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn.delay(delay)) { opacity = 1 }
            }
    }
}

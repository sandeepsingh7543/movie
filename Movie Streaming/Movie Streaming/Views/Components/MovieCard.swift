import SwiftUI

// MARK: - Skeleton Loader
struct SkeletonView: View {
    @State private var shimmer = false

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.appSurface, Color.appSurface.opacity(0.5), Color.appSurface],
                    startPoint: shimmer ? .leading : .trailing,
                    endPoint: shimmer ? .trailing : .leading
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    shimmer = true
                }
            }
    }
}

// MARK: - Skeleton Card
struct SkeletonCard: View {
    var width: CGFloat = 120
    var height: CGFloat = 180

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            SkeletonView()
                .frame(width: width, height: height)
                .cornerRadius(10)
            SkeletonView()
                .frame(width: width * 0.7, height: 10)
                .cornerRadius(4)
        }
    }
}

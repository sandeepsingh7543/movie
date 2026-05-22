import SwiftUI

struct CinematicModeView: View {
    let movie: MovieEntity
    @Environment(\.dismiss) private var dismiss
    @State private var showInfo = false
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            // Poster
            if let data = movie.posterData, let img = UIImage(data: data) {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                    .offset(y: offset * 0.3) // parallax
            } else {
                CineverseTheme.purpleBlueGradient
                    .ignoresSafeArea()
                    .overlay(
                        Image(systemName: "film")
                            .font(.system(size: 100))
                            .foregroundColor(.white.opacity(0.2))
                    )
            }

            // Info overlay
            if showInfo {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text(movie.title ?? "Untitled")
                            .font(.largeTitle.bold())
                        HStack(spacing: 16) {
                            Label(movie.genre ?? "", systemImage: "film")
                            Label(movie.duration.durationFormatted, systemImage: "clock")
                            Text(movie.rating.starRating)
                        }
                        .foregroundColor(CineverseTheme.lightGray)

                        if let notes = movie.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.subheadline)
                                .foregroundColor(CineverseTheme.lightGray)
                                .lineLimit(3)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(colors: [.clear, .black.opacity(0.9)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { offset = $0.translation.height }
                .onEnded { value in
                    if value.translation.height > 100 {
                        dismiss()
                    } else {
                        withAnimation { offset = 0 }
                    }
                }
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.4)) { showInfo.toggle() }
        }
        .statusBarHidden()
    }
}

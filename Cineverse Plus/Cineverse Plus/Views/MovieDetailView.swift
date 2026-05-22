import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var vm: MovieViewModel
    @ObservedObject var movie: MovieEntity
    @State private var showCinematicMode = false
    @State private var editProgress: Double?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Poster Header
                ZStack(alignment: .bottomLeading) {
                    if let data = movie.posterData, let img = UIImage(data: data) {
                        GeometryReader { geo in
                            Image(uiImage: img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: 450)
                                .clipped()
                        }
                        .frame(height: 450)
                    } else {
                        CineverseTheme.purpleBlueGradient
                            .frame(height: 450)
                            .overlay(
                                Image(systemName: "film")
                                    .font(.system(size: 80))
                                    .foregroundColor(.white.opacity(0.3))
                            )
                    }

                    // Gradient overlay
                    VStack(alignment: .leading, spacing: 8) {
                        Spacer()
                        Text(movie.title ?? "Untitled")
                            .font(.largeTitle.bold())
                        HStack(spacing: 12) {
                            Label(movie.genre ?? "", systemImage: "film")
                            Label(movie.duration.durationFormatted, systemImage: "clock")
                        }
                        .font(.subheadline)
                        .foregroundColor(CineverseTheme.lightGray)
                    }
                    .foregroundColor(.white)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(colors: [.clear, .clear, CineverseTheme.deepBlack],
                                       startPoint: .top, endPoint: .bottom)
                    )
                }

                VStack(spacing: 20) {
                    // Actions
                    HStack(spacing: 16) {
                        actionButton(icon: movie.isFavorite ? "heart.fill" : "heart",
                                     label: "Favorite",
                                     color: movie.isFavorite ? .red : CineverseTheme.lightGray) {
                            vm.toggleFavorite(movie)
                        }
                        actionButton(icon: "rectangle.expand.vertical", label: "Cinematic",
                                     color: CineverseTheme.neonPurple) {
                            showCinematicMode = true
                        }
                    }
                    .padding(.horizontal)

                    // Rating
                    HStack {
                        Text("Rating")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: Double(i) <= movie.rating ? "star.fill" : "star")
                                    .foregroundColor(CineverseTheme.neonPurple)
                            }
                            Text(String(format: "%.1f", movie.rating))
                                .foregroundColor(CineverseTheme.lightGray)
                        }
                    }
                    .padding(.horizontal)

                    // Watch Progress
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Watch Progress")
                                .font(.headline)
                            Spacer()
                            Text("\(Int((editProgress ?? movie.watchProgress) * 100))%")
                                .foregroundColor(CineverseTheme.electricBlue)
                        }
                        Slider(value: Binding(
                            get: { editProgress ?? movie.watchProgress },
                            set: { editProgress = $0 }
                        ), in: 0...1, step: 0.05) { editing in
                            if !editing, let p = editProgress {
                                vm.updateWatchProgress(movie, progress: p)
                                editProgress = nil
                            }
                        }
                        .tint(CineverseTheme.electricBlue)

                        // Progress bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.white.opacity(0.1))
                                Capsule()
                                    .fill(CineverseTheme.purpleBlueGradient)
                                    .frame(width: geo.size.width * (editProgress ?? movie.watchProgress))
                                    .animation(.easeInOut, value: editProgress ?? movie.watchProgress)
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(.horizontal)

                    // Info Cards
                    HStack(spacing: 12) {
                        infoCard(icon: "theatermasks", title: "Mood", value: movie.mood ?? "—")
                        infoCard(icon: "folder", title: "Collection", value: movie.collection ?? "Default")
                    }
                    .padding(.horizontal)

                    if let date = movie.dateAdded {
                        HStack {
                            Text("Added")
                                .foregroundColor(CineverseTheme.lightGray)
                            Spacer()
                            Text(date.timeAgo)
                                .foregroundColor(CineverseTheme.lightGray)
                        }
                        .font(.caption)
                        .padding(.horizontal)
                    }

                    // Notes
                    if let notes = movie.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                            Text(notes)
                                .foregroundColor(CineverseTheme.lightGray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .glassMorphism()
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 16)
            }
        }
        .background(CineverseTheme.deepBlack)
        .ignoresSafeArea(edges: .top)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .fullScreenCover(isPresented: $showCinematicMode) {
            CinematicModeView(movie: movie)
        }
    }

    private func actionButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .glassMorphism()
        }
    }

    private func infoCard(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(CineverseTheme.neonPurple)
            Text(title)
                .font(.caption)
                .foregroundColor(CineverseTheme.lightGray)
            Text(value)
                .font(.subheadline.bold())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassMorphism()
    }
}

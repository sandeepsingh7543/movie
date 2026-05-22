import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var vm: MovieViewModel
    @State private var selectedMood: String?
    @State private var pickedMovie: MovieEntity?
    @State private var showPick = false
    @State private var isAnimating = false

    private let moods: [(name: String, icon: String)] = [
        ("Action", "flame.fill"),
        ("Chill", "leaf.fill"),
        ("Romantic", "heart.fill"),
        ("Focus", "brain.head.profile"),
        ("Thrilling", "bolt.fill"),
        ("Scary", "eye.fill"),
        ("Happy", "face.smiling.fill"),
        ("Sad", "cloud.rain.fill")
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Pick For Me
                    pickForMeSection

                    // Mood Picker
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "Pick by Mood")
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(moods, id: \.name) { mood in
                                MoodCard(mood: mood.name, icon: mood.icon)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedMood == mood.name ? CineverseTheme.neonPurple : .clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedMood = selectedMood == mood.name ? nil : mood.name
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Mood Results
                    if let mood = selectedMood {
                        let moodMovies = vm.moviesByMood(mood)
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "\(mood) Movies")
                                .padding(.horizontal)

                            if moodMovies.isEmpty {
                                Text("No \(mood.lowercased()) movies yet. Add some!")
                                    .foregroundColor(CineverseTheme.lightGray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 12) {
                                        ForEach(moodMovies, id: \.objectID) { movie in
                                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                                MovieCard(
                                                    title: movie.title ?? "Untitled",
                                                    posterData: movie.posterData,
                                                    rating: movie.rating,
                                                    progress: movie.watchProgress
                                                )
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
            }
            .background(CineverseTheme.deepBlack)
            .navigationTitle("Discover")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showPick) {
                if let movie = pickedMovie {
                    pickResultSheet(movie)
                }
            }
        }
    }

    private var pickForMeSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 40))
                .foregroundColor(CineverseTheme.neonPurple)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))

            Text("Can't decide what to watch?")
                .font(.title3.bold())
                .foregroundColor(.white)

            Button {
                withAnimation(.spring(response: 0.5)) { isAnimating = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isAnimating = false
                    pickedMovie = vm.randomPick(mood: selectedMood)
                    showPick = pickedMovie != nil
                }
            } label: {
                Text("Pick For Me")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(CineverseTheme.purpleBlueGradient)
                    .clipShape(Capsule())
                    .shadow(color: CineverseTheme.neonPurple.opacity(0.4), radius: 12)
            }
            .disabled(vm.movies.isEmpty)

            if vm.movies.isEmpty {
                Text("Add movies to your library first")
                    .font(.caption)
                    .foregroundColor(CineverseTheme.lightGray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .glassMorphism()
        .padding(.horizontal)
    }

    private func pickResultSheet(_ movie: MovieEntity) -> some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let data = movie.posterData, let img = UIImage(data: data) {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(CineverseTheme.purpleBlueGradient)
                        .frame(height: 250)
                        .overlay(
                            Image(systemName: "film")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.4))
                        )
                }

                Text(movie.title ?? "Untitled")
                    .font(.title.bold())
                    .foregroundColor(.white)

                HStack(spacing: 16) {
                    Label(movie.genre ?? "", systemImage: "film")
                    Label(movie.duration.durationFormatted, systemImage: "clock")
                    Text(movie.rating.starRating)
                }
                .foregroundColor(CineverseTheme.lightGray)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(CineverseTheme.deepBlack)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { showPick = false }
                }
            }
        }
    }
}

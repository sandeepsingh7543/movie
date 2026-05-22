import SwiftUI

struct DiscoverView: View {
    
    @Environment(\.openURL) var openURL
    
    @EnvironmentObject var viewModel: MovieViewModel
    @State private var selectedMood: String = ""
    @State private var randomResult: Movie?
    @State private var showResult = false
    @State private var isFlipped = false
    @State private var moodResults: [Movie] = []
    @State private var showMoodResults = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                randomPickerSection
                moodSection
            }
            .padding()
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    // MARK: - Header

    private var headerSection: some View {
        Text("What should I watch?")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }

    // MARK: - Random Picker

    private var randomPickerSection: some View {
        VStack(spacing: 16) {
            if showResult, let movie = randomResult {
                randomResultCard(movie)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.5).combined(with: .opacity),
                        removal: .opacity
                    ))
            } else {
                pickButton
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showResult)
    }

    private var pickButton: some View {
        Button { pickRandom() } label: {
            HStack(spacing: 12) {
                Image(systemName: "dice.fill").font(.title2)
                Text("Pick Random Title").font(.appSubtitle)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                LinearGradient(colors: [.appPrimary, .appSecondary],
                               startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(16)
            .shadow(color: .appPrimary.opacity(0.4), radius: 10, y: 4)
        }
    }

    private func randomResultCard(_ movie: Movie) -> some View {
        let isSeries = (movie.contentType ?? "Movie") == "Series"
        return VStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                PosterImage(posterData: movie.posterData)
                    .frame(height: 250)
                    .cornerRadius(16)
                    .clipped()
                    .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))

                if isSeries {
                    Text("SERIES")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.appSecondary)
                        .cornerRadius(4)
                        .padding(8)
                }
            }

            Text(movie.title ?? "Untitled")
                .font(.appTitle)
                .foregroundColor(.white)

            HStack(spacing: 12) {
                GenrePill(genre: movie.genre ?? "Unknown")
                RatingView(rating: movie.rating, compact: true)
                if isSeries {
                    Text("S\(movie.totalSeasons)")
                        .font(.appCaption)
                        .foregroundColor(.appSecondary)
                }
            }

//            HStack(spacing: 12) {
//                Button {
//                    if let link = movie.externalLink,
//                       let url = URL(string: link),
//                       UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url)
//                    }
//                } label: {
//                    Text("Watch This!")
//                        .font(.appSubtitle)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(Color.appPrimary)
//                        .cornerRadius(12)
//                }
//                Button { pickRandom() } label: {
//                    Text("Pick Again")
//                        .font(.appSubtitle)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical, 12)
//                        .background(Color.cardBackground)
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.appSecondary.opacity(0.5), lineWidth: 1)
//                        )
//                }
//            }
            HStack(spacing: 12) {

                if let link = movie.externalLink,
                   !link.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

                    Button {
                        if let url = URL(string: link) {
                            openURL(url)
                        }
                    } label: {
                        Text("Watch This!")
                            .font(.appSubtitle)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.appPrimary)
                            .cornerRadius(12)
                    }
                }

                Button { pickRandom() } label: {
                    Text("Pick Again")
                        .font(.appSubtitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.appSecondary.opacity(0.5), lineWidth: 1)
                        )
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Mood Section

    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pick a Mood")
                .font(.appSubtitle)
                .foregroundColor(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(["Action", "Chill", "Romantic", "Focus"], id: \.self) { mood in
                    MoodCard(mood: mood) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedMood = mood
                            moodResults = viewModel.moodSuggestions(mood: mood)
                            showMoodResults = true
                        }
                    }
                    .opacity(selectedMood.isEmpty || selectedMood == mood ? 1 : 0.5)
                }
            }

            if showMoodResults {
                if moodResults.isEmpty {
                    Text("No \(selectedMood) titles yet. Add some!")
                        .font(.appBody)
                        .foregroundColor(.textGray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .transition(.opacity)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(moodResults, id: \.objectID) { movie in
                                MovieCard(movie: movie, size: .medium)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Button {
                    withAnimation {
                        selectedMood = ""
                        showMoodResults = false
                        moodResults = []
                    }
                } label: {
                    Text("Clear Mood")
                        .font(.appCaption)
                        .foregroundColor(.textGray)
                }
            }
        }
    }

    // MARK: - Helpers

    private func pickRandom() {
        if let movie = viewModel.randomPick() {
            isFlipped = false
            showResult = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                randomResult = movie
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showResult = true
                }
                withAnimation(.easeInOut(duration: 0.5).delay(0.1)) {
                    isFlipped = true
                }
            }
        } else {
            randomResult = nil
            showResult = false
        }
    }
}

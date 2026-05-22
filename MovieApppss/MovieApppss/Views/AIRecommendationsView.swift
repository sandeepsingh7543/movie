//
//  AIRecommendationsView.swift
//  MovieApppss
//
//  AI-Powered Recommendations with Mood Selection
//

import SwiftUI

struct AIRecommendationsView: View {
    @StateObject private var recommendationEngine = RecommendationEngine.shared
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedMood = "Happy"
    @State private var isAnalyzing = false
    
    let moods = [
        ("Happy", "😊", Color.yellow),
        ("Sad", "😢", Color.blue),
        ("Excited", "🤩", Color.orange),
        ("Relaxed", "😌", Color.green),
        ("Adventurous", "🏃‍♂️", Color.red),
        ("Romantic", "💕", Color.pink)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("AI Recommendations")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Personalized suggestions just for you")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                // Mood Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("What's your mood?")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(moods, id: \.0) { mood, emoji, color in
                            MoodCard(
                                mood: mood,
                                emoji: emoji,
                                color: color,
                                isSelected: selectedMood == mood
                            ) {
                                selectedMood = mood
                                generateMoodRecommendations()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // AI Analysis Button
                Button(action: {
                    analyzePreferences()
                }) {
                    HStack {
                        if isAnalyzing {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "brain.head.profile")
                        }
                        Text(isAnalyzing ? "Analyzing..." : "Analyze My Preferences")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                .disabled(isAnalyzing)
                .padding(.horizontal)
                
                // Personalized Recommendations
                if !recommendationEngine.personalizedRecommendations.isEmpty {
                    RecommendationSection(
                        title: "For You",
                        subtitle: "Based on your viewing history",
                        movies: recommendationEngine.personalizedRecommendations
                    )
                }
                
                // Mood-based Recommendations
                if let moodMovies = recommendationEngine.moodBasedRecommendations[selectedMood],
                   !moodMovies.isEmpty {
                    RecommendationSection(
                        title: "\(selectedMood) Movies",
                        subtitle: "Perfect for your current mood",
                        movies: moodMovies
                    )
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            generateMoodRecommendations()
        }
    }
    
    private func analyzePreferences() {
        isAnalyzing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            recommendationEngine.generatePersonalizedRecommendations(for: dataManager.movies)
            isAnalyzing = false
        }
    }
    
    private func generateMoodRecommendations() {
        recommendationEngine.generateMoodBasedRecommendations()
    }
}

struct MoodCard: View {
    let mood: String
    let emoji: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.title)
                
                Text(mood)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color.opacity(0.3) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

struct RecommendationSection: View {
    let title: String
    let subtitle: String
    let movies: [MovieModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies) { movie in
                        RecommendationCard(movie: movie)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RecommendationCard: View {
    let movie: MovieModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 120, height: 180)
                .overlay(
                    VStack {
                        Image(systemName: "film")
                            .font(.title)
                            .foregroundColor(.gray)
                        Text("Poster")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    
                    Text(movie.formattedRating)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 120)
    }
}

#Preview {
    AIRecommendationsView()
}

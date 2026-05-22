//
//  HomeView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMood: Mood?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Stats
                    statsSection
                    
                    // Mood Picker
                    moodPickerSection
                    
                    // Smart Lists
                    if !viewModel.watchTonightMovies.isEmpty {
                        movieSection(title: "Watch Tonight", movies: viewModel.watchTonightMovies, icon: "moon.stars.fill")
                    }
                    
                    if !viewModel.topRatedMovies.isEmpty {
                        movieSection(title: "Top Rated by You", movies: viewModel.topRatedMovies, icon: "star.fill")
                    }
                    
                    if !viewModel.recentlyAddedMovies.isEmpty {
                        movieSection(title: "Recently Added", movies: viewModel.recentlyAddedMovies, icon: "clock.fill")
                    }
                    
                    if !viewModel.forgottenMovies.isEmpty {
                        movieSection(title: "Forgotten Movies", movies: viewModel.forgottenMovies, icon: "questionmark.circle.fill")
                    }
                }
                .padding()
            }
            .navigationTitle("CineTrack Pro")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCard(title: "Total Movies", value: "\(viewModel.totalMovies)", icon: "film.fill", color: .yellow)
            StatCard(title: "Watched", value: "\(viewModel.watchedCount)", icon: "checkmark.circle.fill", color: .green)
            StatCard(title: "Avg Rating", value: String(format: "%.1f", viewModel.averageRating), icon: "star.fill", color: .orange)
        }
    }
    
    // MARK: - Mood Picker Section
    private var moodPickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
                Text("What's your mood?")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        MoodCard(mood: mood) {
                            selectedMood = mood
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $selectedMood) { mood in
            MoodMoviesView(mood: mood, movies: viewModel.getMoviesForMood(mood))
        }
    }
    
    // MARK: - Movie Section
    private func movieSection(title: String, movies: [Movie], icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.yellow)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                            MovieCard(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Mood Card
struct MoodCard: View {
    let mood: Mood
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.title2)
                    .foregroundColor(mood.color)
                
                Text(mood.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(mood.color.opacity(0.5), lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Movie Card
struct MovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 120, height: 180)
                .overlay(
                    Group {
                        if let imageData = movie.posterImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } else {
                            VStack {
                                Image(systemName: "film.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text(movie.title)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                                    .lineLimit(3)
                            }
                            .padding(8)
                        }
                    }
                )
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: 120)
    }
}

#Preview {
    HomeView(viewModel: MovieViewModel())
        .preferredColorScheme(.dark)
}
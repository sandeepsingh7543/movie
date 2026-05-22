//
//  MoodMoviesView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI

struct MoodMoviesView: View {
    let mood: Mood
    let movies: [Movie]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: mood.icon)
                        .font(.system(size: 50))
                        .foregroundColor(mood.color)
                    
                    Text("Perfect for \(mood.rawValue) mood")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Here are some movies from your library")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Movies List
                if movies.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "film.stack")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No movies found")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Add some \(mood.rawValue.lowercased()) movies to your library to see suggestions here")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(movies) { movie in
                                MoodMovieRow(movie: movie)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(mood.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                }
            }
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Mood Movie Row
struct MoodMovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            // Poster
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 90)
                .overlay(
                    Group {
                        if let imageData = movie.posterImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } else {
                            Image(systemName: "film.fill")
                                .foregroundColor(.gray)
                        }
                    }
                )
                .cornerRadius(8)
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: movie.genre.icon)
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(movie.genre.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: movie.watchStatus.icon)
                        .font(.caption)
                        .foregroundColor(movie.watchStatus.color)
                    Text(movie.watchStatus.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    MoodMoviesView(
        mood: .happy,
        movies: [
            Movie(title: "The Grand Budapest Hotel", genre: .comedy, rating: 8.5, watchStatus: .completed, releaseDate: Date()),
            Movie(title: "Toy Story", genre: .animation, rating: 9.0, watchStatus: .planToWatch, releaseDate: Date())
        ]
    )
    .preferredColorScheme(.dark)
}
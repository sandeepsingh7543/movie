//
//  MovieDetailView.swift
//  MyTv123Moviesbox
//
//  Full movie details view
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with poster
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [themeManager.accentColor.opacity(0.3), themeManager.accentColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 300)
                    
                    VStack(spacing: 15) {
                        if !movie.posterURL.isEmpty, let imageData = Data(base64Encoded: movie.posterURL), let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 240)
                                .clipped()
                                .cornerRadius(15)
                        } else {
                            Image(systemName: movie.contentType == .movie ? "film.fill" : "tv.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(movie.formattedRating)
                                    .foregroundColor(.white)
                            }
                            
                            Text(movie.releaseYear)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(movie.duration)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .font(.subheadline)
                    }
                }
                
                // Action buttons
                HStack(spacing: 20) {
                    Button(action: {
                        dataManager.toggleFavorite(movie)
                    }) {
                        HStack {
                            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                            Text(movie.isFavorite ? "Favorited" : "Add to Favorites")
                        }
                        .foregroundColor(movie.isFavorite ? .red : .white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(movie.isFavorite ? Color.red.opacity(0.2) : Color.white.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                
                // Details
                VStack(alignment: .leading, spacing: 15) {
                    DetailSection(title: "Description", content: movie.description)
                    DetailSection(title: "Genre", content: movie.genre)
                    DetailSection(title: "Director", content: movie.director)
                    DetailSection(title: "Cast", content: movie.cast.joined(separator: ", "))
                    DetailSection(title: "Language", content: movie.language)
                    DetailSection(title: "Country", content: movie.country)
                    DetailSection(title: "Age Rating", content: movie.ageRating)
                    
                    if let seasons = movie.seasons {
                        DetailSection(title: "Seasons", content: "\(seasons)")
                    }
                    
                    if let episodes = movie.episodes {
                        DetailSection(title: "Episodes", content: "\(episodes)")
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
        }
        .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(content)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
    MovieDetailView(movie: MovieGenerator.generateSampleMovies().first!)
}

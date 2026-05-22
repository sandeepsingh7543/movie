//
//  WatchlistView.swift
//  MovieApppss
//
//  Watchlist View for movies to watch
//

import SwiftUI

struct WatchlistView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedMovie: MovieModel?
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            if dataManager.watchlist.isEmpty {
                EmptyStateView(
                    icon: "bookmark.fill",
                    title: "Your Watchlist is Empty",
                    subtitle: "Add movies from your collection to create your watchlist"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(dataManager.watchlist) { movie in
                            WatchlistCard(movie: movie)
                                .onTapGesture {
                                    selectedMovie = movie
                                    appEnvironment.isTabViewVisible = false
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color.clear)
        .fullScreenCover(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie) {
                selectedMovie = nil
                appEnvironment.isTabViewVisible = true
            }
        }
    }
}

struct WatchlistCard: View {
    let movie: MovieModel
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            // Poster
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.3),
                                Color.blue.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 120)
                
                if let imageData = Data(base64Encoded: movie.posterImageData),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 120)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Image(systemName: "film.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Text(movie.genre)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        dataManager.removeFromWatchlist(movie)
                    }) {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.purple)
                    }
                }
                
                Text(movie.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                HStack {
                    // Rating
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text(movie.formattedRating)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(movie.duration)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Quick action buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            dataManager.toggleFavorite(movie)
                        }) {
                            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 16))
                                .foregroundColor(movie.isFavorite ? .red : .gray)
                        }
                        
                        Button(action: {
                            var updatedMovie = movie
                            updatedMovie.isWatched = true
                            updatedMovie.watchProgress = 1.0
                            updatedMovie.watchedDate = Date()
                            dataManager.updateMovie(updatedMovie)
                            dataManager.removeFromWatchlist(movie)
                        }) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 16))
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    WatchlistView()
}

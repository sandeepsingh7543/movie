//
//  FavoritesView.swift
//  MyTv123Moviesbox
//
//  Favorites collection with enhanced organization
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedView = "Grid"
    @State private var selectedFilter = "All"
    
    let viewTypes = ["Grid", "List"]
    let filters = ["All", "Movies", "TV Shows", "Recently Added"]
    
    var filteredFavorites: [MovieModel] {
        var favorites = dataManager.favorites
        
        switch selectedFilter {
        case "Movies":
            favorites = favorites.filter { $0.contentType == .movie }
        case "TV Shows":
            favorites = favorites.filter { $0.contentType == .tvShow || $0.contentType == .webSeries }
        case "Recently Added":
            favorites = favorites.sorted { ($0.watchedDate ?? Date.distantPast) > ($1.watchedDate ?? Date.distantPast) }
        default:
            break
        }
        
        return favorites
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if dataManager.favorites.isEmpty {
                EmptyFavoritesView()
            } else {
                // Controls
                ControlsBar(
                    selectedView: $selectedView,
                    selectedFilter: $selectedFilter,
                    viewTypes: viewTypes,
                    filters: filters
                )
                
                // Content
                if selectedView == "Grid" {
                    FavoritesGridView(favorites: filteredFavorites)
                } else {
                    FavoritesListView(favorites: filteredFavorites)
                }
            }
        }
    }
}

struct EmptyFavoritesView: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(themeManager.accentColor.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(themeManager.accentColor)
            }
            
            VStack(spacing: 15) {
                Text("No Favorites Yet")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.textPrimary)
                
                Text("Start adding movies and shows to your favorites by tapping the heart icon")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {}) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Browse Content")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(themeManager.accentColor)
                .cornerRadius(25)
            }
            
            Spacer()
        }
    }
}

struct ControlsBar: View {
    @Binding var selectedView: String
    @Binding var selectedFilter: String
    let viewTypes: [String]
    let filters: [String]
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack {
            // Filter selector
            Menu {
                ForEach(filters, id: \.self) { filter in
                    Button(filter) {
                        selectedFilter = filter
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Text(selectedFilter)
                        .font(.system(size: 14, weight: .medium))
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                }
                .foregroundColor(themeManager.currentTheme.textPrimary)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(themeManager.currentTheme.cardBackground)
                .cornerRadius(20)
            }
            
            Spacer()
            
            // View type selector
            HStack(spacing: 5) {
                ForEach(viewTypes, id: \.self) { viewType in
                    Button(action: {
                        selectedView = viewType
                    }) {
                        Image(systemName: viewType == "Grid" ? "grid" : "list.bullet")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedView == viewType ? .white : themeManager.currentTheme.textSecondary)
                            .padding(10)
                            .background(selectedView == viewType ? themeManager.accentColor : Color.clear)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(5)
            .background(themeManager.currentTheme.cardBackground)
            .cornerRadius(15)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
}

struct FavoritesGridView: View {
    let favorites: [MovieModel]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20) {
                ForEach(favorites) { movie in
                    FavoriteGridCard(movie: movie)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 100)
        }
    }
}

struct FavoritesListView: View {
    let favorites: [MovieModel]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15) {
                ForEach(favorites) { movie in
                    FavoriteListCard(movie: movie)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 100)
        }
    }
}

struct FavoriteGridCard: View {
    let movie: MovieModel
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                // Poster
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(
                        colors: [themeManager.accentColor.opacity(0.3), themeManager.accentColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 220)
                
                // Favorite indicator
                VStack {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                .padding(12)
                
                // Play button
                Button(action: {}) {
                    Circle()
                        .fill(Color.black.opacity(0.7))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "play.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.currentTheme.textPrimary)
                    .lineLimit(2)
                
                HStack {
                    Text(movie.releaseYear)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(themeManager.currentTheme.textSecondary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        
                        Text(movie.formattedRating)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.textSecondary)
                    }
                }
            }
        }
        .padding(15)
        .background(themeManager.currentTheme.cardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        .contextMenu {
            Button(action: {
                dataManager.toggleFavorite(movie)
            }) {
                Label("Remove from Favorites", systemImage: "heart.slash")
            }
            
            Button(action: {
                dataManager.addToWatchlist(movie)
            }) {
                Label("Add to Watchlist", systemImage: "plus")
            }
        }
    }
}

struct FavoriteListCard: View {
    let movie: MovieModel
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    
    var body: some View {
        HStack(spacing: 15) {
            // Poster
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [themeManager.accentColor.opacity(0.3), themeManager.accentColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 70, height: 100)
                
                Image(systemName: movie.contentType == .movie ? "film.fill" : "tv.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.currentTheme.textPrimary)
                    .lineLimit(2)
                
                Text(movie.genre)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.textSecondary)
                    .lineLimit(1)
                
                HStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        
                        Text(movie.formattedRating)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.textSecondary)
                    }
                    
                    Text(movie.releaseYear)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(themeManager.currentTheme.textSecondary)
                    
                    Text(movie.duration)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(themeManager.currentTheme.textSecondary)
                }
                
                Spacer()
            }
            
            Spacer()
            
            // Actions
            VStack(spacing: 15) {
                Button(action: {
                    dataManager.toggleFavorite(movie)
                }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(15)
        .background(themeManager.currentTheme.cardBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    FavoritesView()
        .background(Color.black)
}

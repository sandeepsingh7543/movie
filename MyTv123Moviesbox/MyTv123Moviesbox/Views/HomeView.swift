//
//  HomeView.swift
//  MyTv123Moviesbox
//
//  Enhanced Home View with trending and featured content
//

import SwiftUI

struct HomeView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedFeatured = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 25) {
                // Featured Content Carousel
                if !dataManager.trending.isEmpty {
                    FeaturedCarouselView(
                        movies: Array(dataManager.trending.prefix(5)),
                        selectedIndex: $selectedFeatured
                    )
                }
                
                // Continue Watching
                if !dataManager.recentlyWatched.isEmpty {
                    ContentSectionView(
                        title: "Continue Watching",
                        subtitle: "Pick up where you left off",
                        movies: dataManager.recentlyWatched,
                        showProgress: true
                    )
                }
                
                // Trending Now
                ContentSectionView(
                    title: "Trending Now",
                    subtitle: "What everyone's watching",
                    movies: dataManager.trending
                )
                
                // Your Favorites
                if !dataManager.favorites.isEmpty {
                    ContentSectionView(
                        title: "Your Favorites",
                        subtitle: "Content you love",
                        movies: dataManager.favorites
                    )
                }
                
                // Recently Added
                ContentSectionView(
                    title: "Recently Added",
                    subtitle: "Fresh content for you",
                    movies: Array(dataManager.movies.suffix(10).reversed())
                )
                
                // Categories
                CategoriesGridView()
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
}

struct FeaturedCarouselView: View {
    let movies: [MovieModel]
    @Binding var selectedIndex: Int
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 15) {
            TabView(selection: $selectedIndex) {
                ForEach(0..<movies.count, id: \.self) { index in
                    FeaturedMovieCard(movie: movies[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 280)
            
            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<movies.count, id: \.self) { index in
                    Circle()
                        .fill(selectedIndex == index ? themeManager.accentColor : Color.white.opacity(0.3))
                        .frame(width: selectedIndex == index ? 10 : 6, height: selectedIndex == index ? 10 : 6)
                        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                }
            }
        }
    }
}

struct FeaturedMovieCard: View {
    let movie: MovieModel
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 20)
                .fill(themeManager.currentTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 15) {
                // Movie poster placeholder
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(
                        colors: [themeManager.accentColor.opacity(0.3), themeManager.accentColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 160)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.textPrimary)
                        .lineLimit(1)
                    
                    HStack {
                        Text(movie.genre)
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
                    
                    Text(movie.duration)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(themeManager.currentTheme.textSecondary)
                }
            }
            .padding(15)
        }
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct ContentSectionView: View {
    let title: String
    let subtitle: String
    let movies: [MovieModel]
    var showProgress: Bool = false
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section header
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Horizontal scroll
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(movies.prefix(10)) { movie in
                        MovieCardView(movie: movie, showProgress: showProgress)
                            .frame(width: 140)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }
}

struct MovieCardView: View {
    let movie: MovieModel
    var showProgress: Bool = false
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                // Poster placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [themeManager.accentColor.opacity(0.3), themeManager.accentColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 200)
                
                // Play button overlay
                Circle()
                    .fill(Color.black.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    )
                
                // Favorite button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            dataManager.toggleFavorite(movie)
                        }) {
                            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(movie.isFavorite ? .red : .white)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                    }
                    Spacer()
                }
                .padding(8)
                
                // Progress bar
                if showProgress && movie.watchProgress > 0 {
                    VStack {
                        Spacer()
                        ProgressView(value: movie.watchProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: themeManager.accentColor))
                            .scaleEffect(y: 2)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    Text(movie.releaseYear)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.yellow)
                        
                        Text(movie.formattedRating)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
    }
}

struct CategoriesGridView: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    let categories = [
        ("Action", "flame.fill", Color.red),
        ("Comedy", "face.smiling.fill", Color.yellow),
        ("Drama", "theatermasks.fill", Color.blue),
        ("Horror", "moon.fill", Color.purple),
        ("Sci-Fi", "sparkles", Color.cyan),
        ("Romance", "heart.fill", Color.pink)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Browse by Genre")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                ForEach(categories, id: \.0) { category in
                    CategoryCard(
                        title: category.0,
                        icon: category.1,
                        color: category.2
                    )
                }
            }
        }
    }
}

struct CategoryCard: View {
    let title: String
    let icon: String
    let color: Color
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(15)
            .background(themeManager.currentTheme.cardBackground)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
        .background(Color.black)
}

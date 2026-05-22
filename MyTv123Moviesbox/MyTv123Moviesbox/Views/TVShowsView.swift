//
//  TVShowsView.swift
//  MyTv123Moviesbox
//
//  TV Shows and Series collection view
//

import SwiftUI

struct TVShowsView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedCategory = "All Shows"
    
    let categories = ["All Shows", "Trending", "New Episodes", "Completed", "Ongoing"]
    
    var filteredShows: [MovieModel] {
        let shows = dataManager.movies.filter { $0.contentType == .tvShow || $0.contentType == .webSeries }
        
        switch selectedCategory {
        case "Trending":
            return shows.sorted { $0.trendingScore > $1.trendingScore }
        case "New Episodes":
            return shows.filter { $0.watchProgress > 0 && $0.watchProgress < 1.0 }
        case "Completed":
            return shows.filter { $0.isWatched }
        case "Ongoing":
            return shows.filter { !$0.isWatched && $0.watchProgress > 0 }
        default:
            return shows
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Category Selector
            CategorySelectorView(
                categories: categories,
                selectedCategory: $selectedCategory
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    // Featured Show
                    if let featuredShow = filteredShows.first {
                        FeaturedShowCard(show: featuredShow)
                            .padding(.horizontal, 20)
                    }
                    
                    // Shows List
                    ForEach(filteredShows.dropFirst()) { show in
                        TVShowRowCard(show: show)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }
        }
    }
}

struct CategorySelectorView: View {
    let categories: [String]
    @Binding var selectedCategory: String
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        title: category,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 15)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : themeManager.currentTheme.textSecondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? themeManager.accentColor : themeManager.currentTheme.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FeaturedShowCard: View {
    let show: MovieModel
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Background image placeholder
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [themeManager.accentColor.opacity(0.4), themeManager.accentColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 200)
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(height: 200)
                
                // Content
                VStack {
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(show.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(2)
                            
                            HStack(spacing: 15) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.yellow)
                                    
                                    Text(show.formattedRating)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                if let seasons = show.seasons {
                                    Text("\(seasons) Season\(seasons > 1 ? "s" : "")")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Text(show.releaseYear)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        // Action buttons
                        VStack(spacing: 10) {
                            Button(action: {}) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                dataManager.toggleFavorite(show)
                            }) {
                                Image(systemName: show.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(show.isFavorite ? .red : .white)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            
            // Progress bar if watching
            if show.watchProgress > 0 {
                VStack(spacing: 8) {
                    HStack {
                        Text("Continue Watching")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.textSecondary)
                        
                        Spacer()
                        
                        Text("\(show.watchProgressPercentage)% Complete")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.textSecondary)
                    }
                    
                    ProgressView(value: show.watchProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: themeManager.accentColor))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(themeManager.currentTheme.cardBackground)
                .cornerRadius(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
            }
        }
        .background(themeManager.currentTheme.cardBackground)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct TVShowRowCard: View {
    let show: MovieModel
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
        HStack(spacing: 15) {
            if !show.posterURL.isEmpty, let imageData = Data(base64Encoded: show.posterURL), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                    .clipped()
                    .cornerRadius(15)
            } else {
                // Poster
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            colors: [themeManager.accentColor.opacity(0.3), themeManager.accentColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 80, height: 120)
                    Image(systemName: "tv.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(show.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.currentTheme.textPrimary)
                    .lineLimit(2)
                
                Text(show.genre)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.textSecondary)
                    .lineLimit(1)
                
                HStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        
                        Text(show.formattedRating)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.textSecondary)
                    }
                    
                    if let seasons = show.seasons {
                        Text("\(seasons)S")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.textSecondary)
                    }
                    
                    Text(show.releaseYear)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(themeManager.currentTheme.textSecondary)
                }
                
                // Progress if watching
                if show.watchProgress > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(show.watchProgressPercentage)% watched")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(themeManager.accentColor)
                        
                        ProgressView(value: show.watchProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: themeManager.accentColor))
                            .scaleEffect(y: 1.5)
                    }
                }
                
                Spacer()
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 15) {
                Button(action: {
                    dataManager.toggleFavorite(show)
                }) {
                    Image(systemName: show.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(show.isFavorite ? .red : themeManager.currentTheme.textSecondary)
                }
            }
        }
        .padding(15)
        .background(themeManager.currentTheme.cardBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(themeManager.accentColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                MovieDetailView(movie: show)
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func cornerRadius(topLeadingRadius: CGFloat = 0, topTrailingRadius: CGFloat = 0, bottomLeadingRadius: CGFloat = 0, bottomTrailingRadius: CGFloat = 0) -> some View {
        clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: topLeadingRadius,
                bottomLeadingRadius: bottomLeadingRadius,
                bottomTrailingRadius: bottomTrailingRadius,
                topTrailingRadius: topTrailingRadius
            )
        )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    TVShowsView()
        .background(Color.black)
}

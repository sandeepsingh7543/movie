//
//  StatisticsView.swift
//  MovieApppss
//
//  Movie Statistics Dashboard
//

import SwiftUI

struct StatisticsView: View {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Your Movie Stats")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Insights about your movie journey")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                // Quick Stats Cards
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    StatCard(
                        title: "Total Movies",
                        value: "\(dataManager.movies.count)",
                        icon: "film.fill",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "Watched",
                        value: "\(watchedMoviesCount)",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    
                    StatCard(
                        title: "Favorites",
                        value: "\(favoriteMoviesCount)",
                        icon: "heart.fill",
                        color: .red
                    )
                    
                    StatCard(
                        title: "Watchlist",
                        value: "\(watchlistCount)",
                        icon: "bookmark.fill",
                        color: .orange
                    )
                }
                .padding(.horizontal)
                
                // Detailed Statistics
                VStack(spacing: 16) {
                    // Genre Distribution
                    StatisticSection(title: "Top Genres") {
                        VStack(spacing: 8) {
                            ForEach(topGenres, id: \.0) { genre, count in
                                GenreBar(genre: genre, count: count, total: dataManager.movies.count)
                            }
                        }
                    }
                    
                    // Viewing Progress
                    StatisticSection(title: "Viewing Progress") {
                        VStack(spacing: 12) {
                            ProgressRing(
                                progress: Double(watchedMoviesCount) / Double(max(dataManager.movies.count, 1)),
                                title: "Movies Watched",
                                subtitle: "\(watchedMoviesCount) of \(dataManager.movies.count)"
                            )
                        }
                    }
                    
                    // Rating Distribution
                    StatisticSection(title: "Your Ratings") {
                        VStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { rating in
                                RatingBar(
                                    rating: rating,
                                    count: ratingCounts[rating] ?? 0,
                                    total: totalRatedMovies
                                )
                            }
                        }
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    // Computed Properties
    private var watchedMoviesCount: Int {
        dataManager.movies.filter { $0.isWatched }.count
    }
    
    private var favoriteMoviesCount: Int {
        dataManager.movies.filter { $0.isFavorite }.count
    }
    
    private var watchlistCount: Int {
        dataManager.movies.filter { !$0.isWatched }.count
    }
    
    private var topGenres: [(String, Int)] {
        var genreCount: [String: Int] = [:]
        
        for movie in dataManager.movies {
            let genres = movie.genre.components(separatedBy: ", ")
            for genre in genres {
                genreCount[genre, default: 0] += 1
            }
        }
        
        return genreCount.sorted { $0.value > $1.value }.prefix(5).map { ($0.key, $0.value) }
    }
    
    private var ratingCounts: [Int: Int] {
        var counts: [Int: Int] = [:]
        
        for movie in dataManager.movies {
            if let rating = movie.personalRating {
                let roundedRating = Int(rating.rounded())
                counts[roundedRating, default: 0] += 1
            }
        }
        
        return counts
    }
    
    private var totalRatedMovies: Int {
        dataManager.movies.filter { $0.personalRating != nil }.count
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct StatisticSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            content
                .padding(.horizontal)
        }
    }
}

struct GenreBar: View {
    let genre: String
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(genre)
                    .font(.caption)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(count)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
    }
}

struct ProgressRing: View {
    let progress: Double
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct RatingBar: View {
    let rating: Int
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 2) {
                ForEach(1...rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
            .frame(width: 60, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
            
            Text("\(count)")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

#Preview {
    StatisticsView()
}

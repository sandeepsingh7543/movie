//
//  MoviesView.swift
//  MyTv123Moviesbox
//
//  Movies collection view with filtering and sorting
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedFilter = "All"
    @State private var selectedSort = "Latest"
    @State private var showingFilters = false
    
    let filters = ["All", "Action", "Comedy", "Drama", "Horror", "Sci-Fi", "Romance"]
    let sortOptions = ["Latest", "Rating", "Title", "Duration"]
    
    var filteredMovies: [MovieModel] {
        var movies = dataManager.filterMovies(by: .movie)
        
        if selectedFilter != "All" {
            movies = movies.filter { $0.genre.contains(selectedFilter) }
        }
        
        switch selectedSort {
        case "Rating":
            movies = movies.sorted { $0.rating > $1.rating }
        case "Title":
            movies = movies.sorted { $0.title < $1.title }
        case "Duration":
            movies = movies.sorted { $0.duration < $1.duration }
        default:
            movies = movies.sorted { $0.releaseYear > $1.releaseYear }
        }
        
        return movies
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter and Sort Bar
            FilterSortBar(
                selectedFilter: $selectedFilter,
                selectedSort: $selectedSort,
                filters: filters,
                sortOptions: sortOptions,
                showingFilters: $showingFilters
            )
            
            // Movies Grid
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 20) {
                    ForEach(filteredMovies) { movie in
                        MovieGridCard(movie: movie)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterSheet(
                selectedFilter: $selectedFilter,
                selectedSort: $selectedSort,
                filters: filters,
                sortOptions: sortOptions
            )
        }
    }
}

struct FilterSortBar: View {
    @Binding var selectedFilter: String
    @Binding var selectedSort: String
    let filters: [String]
    let sortOptions: [String]
    @Binding var showingFilters: Bool
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 15) {
            // Filter button
            Button(action: { showingFilters = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(selectedFilter)
                        .font(.system(size: 14, weight: .medium))
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(themeManager.currentTheme.textPrimary)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(themeManager.currentTheme.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                )
            }
            
            Spacer()
            
            // Sort button
            Button(action: { showingFilters = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(selectedSort)
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(themeManager.currentTheme.textPrimary)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(themeManager.currentTheme.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
}

struct MovieGridCard: View {
    let movie: MovieModel
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    @State private var isPressed = false
    @State private var showingDetail = false

    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    // Poster background
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                colors: [themeManager.accentColor.opacity(0.3), themeManager.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 240)
                    
                    // Show uploaded image or default icon
                    if !movie.posterURL.isEmpty, let imageData = Data(base64Encoded: movie.posterURL), let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 240)
                            .clipped()
                            .cornerRadius(15)
                    } else {
                        Image(systemName: movie.contentType == .movie ? "film.fill" : "tv.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    // Top overlay
                    VStack {
                        HStack {
                            Text(movie.quality.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(themeManager.accentColor)
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            Button(action: { dataManager.toggleFavorite(movie) }) {
                                Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(movie.isFavorite ? .red : .white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                        }
                        Spacer()
                    }
                    .padding(12)
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
                    
                    Text(movie.duration)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(themeManager.currentTheme.textSecondary)
                }
            }
            .padding(15)
            .background(themeManager.currentTheme.cardBackground)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(themeManager.accentColor.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) { isPressed = pressing }
        }, perform: {})
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                MovieDetailView(movie: movie)
            }
        }
    }
}


struct FilterSheet: View {
    @Binding var selectedFilter: String
    @Binding var selectedSort: String
    let filters: [String]
    let sortOptions: [String]
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Filter Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Filter by Genre")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.textPrimary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                        ForEach(filters, id: \.self) { filter in
                            FilterChip(
                                title: filter,
                                isSelected: selectedFilter == filter,
                                action: { selectedFilter = filter }
                            )
                        }
                    }
                }
                
                // Sort Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Sort by")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.textPrimary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                        ForEach(sortOptions, id: \.self) { option in
                            FilterChip(
                                title: option,
                                isSelected: selectedSort == option,
                                action: { selectedSort = option }
                            )
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .background(themeManager.currentTheme.primaryGradient.ignoresSafeArea())
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : themeManager.currentTheme.textPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(isSelected ? themeManager.accentColor : themeManager.currentTheme.cardBackground)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MoviesView()
        .background(Color.black)
}

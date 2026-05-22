//
//  MoviesView.swift
//  MovieApppss
//
//  Enhanced Movies View with modern UI and features
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    @State private var showingFilterSheet = false
    @State private var selectedMovie: MovieModel?
    
    private var filteredAndSortedMovies: [MovieModel] {
        var filteredMovies = dataManager.movies
        
        // Apply search filter if search text is not empty
        if !appEnvironment.searchText.isEmpty {
            filteredMovies = filteredMovies.filter { movie in
                movie.title.localizedCaseInsensitiveContains(appEnvironment.searchText) ||
                movie.genre.localizedCaseInsensitiveContains(appEnvironment.searchText) ||
                movie.director.localizedCaseInsensitiveContains(appEnvironment.searchText) ||
                movie.cast.joined().localizedCaseInsensitiveContains(appEnvironment.searchText)
            }
        }
        
        // Apply genre filter if a specific genre is selected
        if appEnvironment.selectedGenre != "All" {
            filteredMovies = filteredMovies.filter { movie in
                movie.categories.contains(appEnvironment.selectedGenre) || 
                movie.genre.localizedCaseInsensitiveContains(appEnvironment.selectedGenre)
            }
        }
        
        return dataManager.sortMovies(filteredMovies, by: appEnvironment.sortOption)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filter Bar
            SearchAndFilterBar(
                searchText: $appEnvironment.searchText,
                selectedGenre: $appEnvironment.selectedGenre,
                sortOption: $appEnvironment.sortOption,
                viewMode: $appEnvironment.viewMode,
                onFilterTapped: { showingFilterSheet = true }
            )
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Content
            if filteredAndSortedMovies.isEmpty {
                EmptyStateView(
                    icon: "film.fill",
                    title: dataManager.movies.isEmpty ? "No Movies Found" : "No Movies Match Filters",
                    subtitle: dataManager.movies.isEmpty ? 
                        "Add your first movie to get started" : 
                        "Try adjusting your search or filters"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if appEnvironment.viewMode == .grid {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(filteredAndSortedMovies) { movie in
                                    MovieGridCard(movie: movie)
                                        .onTapGesture {
                                            selectedMovie = movie
                                            appEnvironment.isTabViewVisible = false
                                        }
                                }
                            }
                        } else {
                            ForEach(filteredAndSortedMovies) { movie in
                                MovieListCard(movie: movie)
                                    .onTapGesture {
                                        selectedMovie = movie
                                        appEnvironment.isTabViewVisible = false
                                    }
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
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet()
        }
        .fullScreenCover(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie) {
                selectedMovie = nil
                appEnvironment.isTabViewVisible = true
            }
        }
    }
}

struct SearchAndFilterBar: View {
    @Binding var searchText: String
    @Binding var selectedGenre: String
    @Binding var sortOption: AppEnvironmentManager.SortOption
    @Binding var viewMode: AppEnvironmentManager.ViewMode
    let onFilterTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search movies...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                
                // Filter Button
                Button(action: onFilterTapped) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.purple.opacity(0.6))
                        )
                }
                
                // View Mode Toggle
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewMode = viewMode == .grid ? .list : .grid
                    }
                }) {
                    Image(systemName: viewMode == .grid ? "list.bullet" : "square.grid.2x2")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.6))
                        )
                }
            }
            
            // Quick Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    QuickFilterChip(title: "All", isSelected: selectedGenre == "All") {
                        selectedGenre = "All"
                    }
                    
                    ForEach(["Action", "Comedy", "Drama", "Horror", "Sci-Fi", "Romance"], id: \.self) { genre in
                        QuickFilterChip(title: genre, isSelected: selectedGenre == genre) {
                            selectedGenre = genre
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct QuickFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.white : Color.white.opacity(0.2))
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct MovieGridCard: View {
    let movie: MovieModel
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster
            ZStack {
                RoundedRectangle(cornerRadius: 16)
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
                    .frame(height: 240)
                
                if let imageData = Data(base64Encoded: movie.posterImageData),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 240)
                        .clipped()
                        .cornerRadius(16)
                } else {
                    VStack {
                        Image(systemName: "film.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                        Text("No Image")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                // Overlay with rating and favorite
                VStack {
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
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                        
                        Spacer()
                        
                        // Favorite button
                        Button(action: {
                            dataManager.toggleFavorite(movie)
                        }) {
                            Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 16))
                                .foregroundColor(movie.isFavorite ? .red : .white)
                                .frame(width: 32, height: 32)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(16)
                        }
                    }
                    
                    Spacer()
                    
                    // Watch progress
                    if movie.watchProgress > 0 {
                        VStack(spacing: 4) {
                            ProgressView(value: movie.watchProgress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                .scaleEffect(y: 2)
                            
                            Text("\(movie.watchProgressPercentage)% watched")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                    }
                }
                .padding(12)
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(movie.genre)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Text(movie.duration)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(movie.contentType.rawValue)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.purple)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(4)
                }
            }
        }
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

struct MovieListCard: View {
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
                        dataManager.toggleFavorite(movie)
                    }) {
                        Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(movie.isFavorite ? .red : .gray)
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
                }
                
                // Watch progress
                if movie.watchProgress > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Progress")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(movie.watchProgressPercentage)%")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                        }
                        
                        ProgressView(value: movie.watchProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            .scaleEffect(y: 1.5)
                    }
                }
            }
            
            Spacer()
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

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FilterSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Sort Options
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sort By")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    ForEach(AppEnvironmentManager.SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            appEnvironment.sortOption = option
                        }) {
                            HStack {
                                Text(option.rawValue)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if appEnvironment.sortOption == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.purple)
                                }
                            }
                            .padding(.vertical, 12)
                        }
                    }
                }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // View Mode
                VStack(alignment: .leading, spacing: 16) {
                    Text("View Mode")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    ForEach(AppEnvironmentManager.ViewMode.allCases, id: \.self) { mode in
                        Button(action: {
                            appEnvironment.viewMode = mode
                        }) {
                            HStack {
                                Image(systemName: mode == .grid ? "square.grid.2x2" : "list.bullet")
                                    .foregroundColor(.white)
                                
                                Text(mode.rawValue)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if appEnvironment.viewMode == mode {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.purple)
                                }
                            }
                            .padding(.vertical, 12)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(24)
            .background(Color.black)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    MoviesView()
}

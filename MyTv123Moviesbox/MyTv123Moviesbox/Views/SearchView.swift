//
//  SearchView.swift
//  MyTv123Moviesbox
//
//  Working search with better UI
//

import SwiftUI

struct SearchView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var searchResults: [MovieModel] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack(spacing: 15) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.6))
                        
                        TextField("Search movies, shows...", text: $searchText)
                            .foregroundColor(.white)
                            .onChange(of: searchText) { _ in
                                performSearch()
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                searchResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(20)
                
                // Results
                if searchText.isEmpty {
                    EmptySearchView()
                } else if searchResults.isEmpty {
                    NoResultsView(searchText: searchText)
                } else {
                    SearchResultsList(results: searchResults)
                }
            }
            .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    private func performSearch() {
        if searchText.isEmpty {
            searchResults = []
            return
        }
        
        searchResults = dataManager.movies.filter { movie in
            movie.title.localizedCaseInsensitiveContains(searchText) ||
            movie.genre.localizedCaseInsensitiveContains(searchText) ||
            movie.director.localizedCaseInsensitiveContains(searchText)
        }
    }
}

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("Search for movies and shows")
                .font(.title2)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
        }
    }
}

struct NoResultsView: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "exclamationmark.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text("No results for \"\(searchText)\"")
                .font(.title2)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
        }
    }
}

struct SearchResultsList: View {
    let results: [MovieModel]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(results) { movie in
                    SearchResultRow(movie: movie)
                }
            }
            .padding(20)
        }
    }
}

struct SearchResultRow: View {
    let movie: MovieModel
    @StateObject private var dataManager = MovieDataManager.shared
    
    var body: some View {
        HStack(spacing: 15) {
            // Poster
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.red.opacity(0.3))
                .frame(width: 60, height: 90)
                .overlay(
                    Image(systemName: movie.contentType == .movie ? "film.fill" : "tv.fill")
                        .foregroundColor(.white.opacity(0.6))
                )
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(movie.genre)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                HStack {
                    Text(movie.releaseYear)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        
                        Text(movie.formattedRating)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            Spacer()
            
            // Actions
            VStack(spacing: 10) {
                Button(action: {
                    dataManager.toggleFavorite(movie)
                }) {
                    Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(movie.isFavorite ? .red : .white.opacity(0.6))
                }
            }
        }
        .padding(15)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    SearchView()
}

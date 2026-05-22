//
//  LibraryView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var showingFilters = false
    @State private var showingAddMovie = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Filter Pills
                if viewModel.selectedGenre != nil || viewModel.selectedStatus != nil {
                    filterPills
                }
                
                // Movies Grid
                if viewModel.filteredMovies.isEmpty {
                    emptyState
                } else {
                    moviesGrid
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilters.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.yellow)
                    }
                }
            }
            .background(Color(.systemBackground))
            .sheet(isPresented: $showingFilters) {
                FilterView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAddMovie) {
                AddMovieView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search movies...", text: $viewModel.searchText)
                .foregroundColor(.primary)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal)
    }
    
    // MARK: - Filter Pills
    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let genre = viewModel.selectedGenre {
                    FilterPill(text: genre.rawValue, color: .blue) {
                        viewModel.selectedGenre = nil
                    }
                }
                
                if let status = viewModel.selectedStatus {
                    FilterPill(text: status.rawValue, color: status.color) {
                        viewModel.selectedStatus = nil
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Movies Grid
    private var moviesGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                        LibraryMovieCard(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "film.stack")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Movies Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(viewModel.movies.isEmpty ? "Add your first movie to get started" : "Try adjusting your search or filters")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if viewModel.movies.isEmpty {
                Button {
                    showingAddMovie = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Movie")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(12)
                }
                .padding(.top)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Filter Pill
struct FilterPill: View {
    let text: String
    let color: Color
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color)
        .cornerRadius(16)
    }
}

// MARK: - Library Movie Card
struct LibraryMovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(2/3, contentMode: .fit)
                .overlay(
                    Group {
                        if let imageData = movie.posterImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } else {
                            VStack {
                                Image(systemName: "film.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                Text(movie.title)
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                            .padding(8)
                        }
                    }
                )
                .cornerRadius(12)
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: movie.watchStatus.icon)
                        .font(.caption2)
                        .foregroundColor(movie.watchStatus.color)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", movie.rating))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    LibraryView(viewModel: MovieViewModel())
        .preferredColorScheme(.dark)
}
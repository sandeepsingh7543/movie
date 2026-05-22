//
//  MovieDetailView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    // Live movie from viewModel so updates reflect immediately
    private var currentMovie: Movie {
        viewModel.movies.first(where: { $0.id == movie.id }) ?? movie
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                posterSection
                detailsSection
                if !currentMovie.personalNotes.isEmpty {
                    notesSection
                }
                actionButtons
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.yellow)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.yellow)
                }
            }
        }
        .background(Color(.systemBackground))
        .sheet(isPresented: $showingEditSheet) {
            EditMovieView(movie: currentMovie, viewModel: viewModel)
        }
        .alert("Delete Movie", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteMovie(currentMovie)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(currentMovie.title)\"? This action cannot be undone.")
        }
        .onAppear {
            viewModel.markAsViewed(movie)
        }
    }
    
    // MARK: - Poster Section
    private var posterSection: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 120, height: 180)
                .overlay(
                    Group {
                        if let imageData = currentMovie.posterImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } else {
                            VStack {
                                Image(systemName: "film.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text(currentMovie.title)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                                    .lineLimit(3)
                            }
                            .padding()
                        }
                    }
                )
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(currentMovie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                
                HStack {
                    Image(systemName: currentMovie.genre.icon)
                        .foregroundColor(.yellow)
                    Text(currentMovie.genre.rawValue)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: currentMovie.watchStatus.icon)
                        .foregroundColor(currentMovie.watchStatus.color)
                    Text(currentMovie.watchStatus.rawValue)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f / 10", currentMovie.rating))
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Spacer()
            }
            
            Spacer()
        }
    }
    
    // MARK: - Details Section
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                DetailRow(title: "Release Date", value: DateFormatter.movieDate.string(from: currentMovie.releaseDate))
                DetailRow(title: "Date Added", value: DateFormatter.movieDate.string(from: currentMovie.dateAdded))
                
                if let lastViewed = currentMovie.lastViewed {
                    DetailRow(title: "Last Viewed", value: DateFormatter.movieDate.string(from: lastViewed))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal Notes")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(currentMovie.personalNotes)
                .foregroundColor(.secondary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                )
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                showingEditSheet = true
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Movie")
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow)
                .cornerRadius(12)
            }
            
            if currentMovie.watchStatus != .completed {
                Button {
                    var updatedMovie = currentMovie
                    updatedMovie.watchStatus = .completed
                    viewModel.updateMovie(updatedMovie)
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Mark as Watched")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green, lineWidth: 1.5)
                    )
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Watched")
                }
                .foregroundColor(.green)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let movieDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                title: "The Dark Knight",
                genre: .action,
                rating: 9.5,
                watchStatus: .completed,
                personalNotes: "Amazing performance by Heath Ledger. One of the best superhero movies ever made.",
                releaseDate: Date()
            ),
            viewModel: MovieViewModel()
        )
    }
    .preferredColorScheme(.dark)
}
//
//  EditMovieView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI
import PhotosUI

struct EditMovieView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var selectedGenre: MovieGenre
    @State private var rating: Double
    @State private var selectedStatus: WatchStatus
    @State private var personalNotes: String
    @State private var releaseDate: Date
    @State private var selectedImage: PhotosPickerItem?
    @State private var posterImageData: Data?
    
    init(movie: Movie, viewModel: MovieViewModel) {
        self.movie = movie
        self.viewModel = viewModel
        
        _title = State(initialValue: movie.title)
        _selectedGenre = State(initialValue: movie.genre)
        _rating = State(initialValue: movie.rating)
        _selectedStatus = State(initialValue: movie.watchStatus)
        _personalNotes = State(initialValue: movie.personalNotes)
        _releaseDate = State(initialValue: movie.releaseDate)
        _posterImageData = State(initialValue: movie.posterImageData)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Movie Details") {
                    TextField("Movie Title", text: $title)
                        .foregroundColor(.primary)
                    
                    Picker("Genre", selection: $selectedGenre) {
                        ForEach(MovieGenre.allCases, id: \.self) { genre in
                            HStack {
                                Image(systemName: genre.icon)
                                Text(genre.rawValue)
                            }
                            .tag(genre)
                        }
                    }
                    
                    DatePicker("Release Date", selection: $releaseDate, displayedComponents: .date)
                        .foregroundColor(.primary)
                }
                
                Section("Rating & Status") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Rating")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(String(format: "%.1f", rating))
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                        }
                        
                        Slider(value: $rating, in: 1...10, step: 0.1) {
                            Text("Rating")
                        }
                        .accentColor(.yellow)
                    }
                    
                    Picker("Watch Status", selection: $selectedStatus) {
                        ForEach(WatchStatus.allCases, id: \.self) { status in
                            HStack {
                                Image(systemName: status.icon)
                                Text(status.rawValue)
                            }
                            .tag(status)
                        }
                    }
                }
                
                Section("Poster Image") {
                    VStack {
                        if let imageData = posterImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .cornerRadius(12)
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.title)
                                            .foregroundColor(.gray)
                                        Text("Add Poster")
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                        
                        HStack(spacing: 12) {
                            PhotosPicker(selection: $selectedImage, matching: .images) {
                                HStack {
                                    Image(systemName: "photo.on.rectangle")
                                    Text("Choose Photo")
                                }
                                .foregroundColor(.yellow)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.yellow, lineWidth: 1)
                                )
                            }
                            
                            if posterImageData != nil {
                                Button {
                                    posterImageData = nil
                                } label: {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Remove")
                                    }
                                    .foregroundColor(.red)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.red, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                }
                
                Section("Personal Notes") {
                    TextField("Your thoughts about this movie...", text: $personalNotes, axis: .vertical)
                        .lineLimit(3...6)
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle("Edit Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .disabled(title.isEmpty)
                }
            }
            .background(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
        }
        .onChange(of: selectedImage) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    posterImageData = data
                }
            }
        }
    }
    
    private func saveChanges() {
        var updatedMovie = movie
        updatedMovie.title = title
        updatedMovie.genre = selectedGenre
        updatedMovie.rating = rating
        updatedMovie.watchStatus = selectedStatus
        updatedMovie.personalNotes = personalNotes
        updatedMovie.releaseDate = releaseDate
        updatedMovie.posterImageData = posterImageData
        
        viewModel.updateMovie(updatedMovie)
        dismiss()
    }
}

#Preview {
    EditMovieView(
        movie: Movie(
            title: "The Dark Knight",
            genre: .action,
            rating: 9.5,
            watchStatus: .completed,
            personalNotes: "Amazing movie!",
            releaseDate: Date()
        ),
        viewModel: MovieViewModel()
    )
    .preferredColorScheme(.dark)
}
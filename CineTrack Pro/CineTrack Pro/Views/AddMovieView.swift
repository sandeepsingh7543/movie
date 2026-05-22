//
//  AddMovieView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI
import PhotosUI

struct AddMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedGenre = MovieGenre.action
    @State private var rating = 5.0
    @State private var selectedStatus = WatchStatus.planToWatch
    @State private var personalNotes = ""
    @State private var releaseDate = Date()
    @State private var selectedImage: PhotosPickerItem?
    @State private var posterImageData: Data?
    @State private var showingImagePicker = false
    
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
                                    .foregroundColor(.yellow)
                                Text(genre.rawValue)
                                    .foregroundColor(.primary)
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
                                    .foregroundColor(status.color)
                                Text(status.rawValue)
                                    .foregroundColor(.primary)
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
                        
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Choose from Library")
                            }
                            .foregroundColor(.yellow)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.yellow, lineWidth: 1)
                            )
                        }
                    }
                }
                
                Section("Personal Notes") {
                    TextField("Your thoughts about this movie...", text: $personalNotes, axis: .vertical)
                        .lineLimit(3...6)
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle("Add Movie")
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
                        saveMovie()
                    }
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .disabled(title.isEmpty)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
        }
        .onChange(of: selectedImage) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    posterImageData = data
                }
            }
        }
    }
    
    private func saveMovie() {
        let movie = Movie(
            title: title,
            genre: selectedGenre,
            rating: rating,
            watchStatus: selectedStatus,
            personalNotes: personalNotes,
            posterImageData: posterImageData,
            releaseDate: releaseDate
        )
        
        viewModel.addMovie(movie)
        dismiss()
    }
}

#Preview {
    AddMovieView(viewModel: MovieViewModel())
        .preferredColorScheme(.dark)
}
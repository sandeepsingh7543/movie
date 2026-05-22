//
//  MovieDetailView.swift
//  MovieApppss
//
//  Enhanced Movie Detail View
//

import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel
    let onDismiss: () -> Void
    
    @StateObject private var dataManager = DataManager.shared
    @State private var showingEditView = false
    @State private var watchProgress: Double
    @State private var personalRating: Double
    @State private var personalNotes: String
    @State private var showingDeleteAlert = false
    
    init(movie: MovieModel, onDismiss: @escaping () -> Void) {
        self.movie = movie
        self.onDismiss = onDismiss
        self._watchProgress = State(initialValue: movie.watchProgress)
        self._personalRating = State(initialValue: movie.personalRating ?? 0.0)
        self._personalNotes = State(initialValue: movie.personalNotes)
    }
    
    var body: some View {
        ZStack {
            // Background
            BackgroundView(movie: movie)
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header with backdrop
                    HeaderSection(movie: movie, onDismiss: onDismiss)
                    
                    // Content
                    VStack(spacing: 24) {
                        // Main Info
                        MainInfoSection(movie: movie)
                        
                        // Action Buttons
                        ActionButtonsSection(
                            movie: movie,
                            watchProgress: $watchProgress,
                            onEdit: { showingEditView = true },
                            onDelete: { showingDeleteAlert = true }
                        )
                        
                        // Watch Progress
                        WatchProgressSection(
                            movie: movie,
                            watchProgress: $watchProgress
                        )
                        
                        // Personal Rating
                        PersonalRatingSection(
                            movie: movie,
                            personalRating: $personalRating
                        )
                        
                        // Details
                        DetailsSection(movie: movie)
                        
                        // Cast & Crew
                        CastCrewSection(movie: movie)
                        
                        // Personal Notes
                        PersonalNotesSection(
                            movie: movie,
                            personalNotes: $personalNotes
                        )
                        
                        // Tags & Categories
                        TagsCategoriesSection(movie: movie)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditView) {
            EditMovieView(movie: movie)
        }
        .alert("Delete Movie", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteMovie(movie)
                onDismiss()
            }
        } message: {
            Text("Are you sure you want to delete this movie? This action cannot be undone.")
        }
        .onChange(of: watchProgress) { newValue in
            dataManager.updateWatchProgress(movie, progress: newValue)
        }
        .onChange(of: personalRating) { newValue in
            var updatedMovie = movie
            updatedMovie.personalRating = newValue
            dataManager.updateMovie(updatedMovie)
        }
        .onChange(of: personalNotes) { newValue in
            var updatedMovie = movie
            updatedMovie.personalNotes = newValue
            dataManager.updateMovie(updatedMovie)
        }
    }
}

struct BackgroundView: View {
    let movie: MovieModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let backdropData = movie.backdropImageData,
               let imageData = Data(base64Encoded: backdropData),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .blur(radius: 20)
                    .opacity(0.3)
                    .ignoresSafeArea()
            }
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(0.8),
                    Color.black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

struct HeaderSection: View {
    let movie: MovieModel
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Backdrop Image
            if let backdropData = movie.backdropImageData,
               let imageData = Data(base64Encoded: backdropData),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.6),
                                Color.blue.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 300)
            }
            
            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.6),
                    Color.clear,
                    Color.black.opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 300)
            
            // Back Button
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(.top, 50)
            .padding(.leading, 20)
        }
    }
}

struct MainInfoSection: View {
    let movie: MovieModel
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Poster
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 180)
                
                if let imageData = Data(base64Encoded: movie.posterImageData),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 180)
                        .clipped()
                        .cornerRadius(16)
                } else {
                    Image(systemName: "film.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(3)
                
                HStack {
                    Text(movie.contentType.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.6))
                        .cornerRadius(6)
                    
                    Text(movie.ageRating)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.6))
                        .cornerRadius(6)
                }
                
                Text(movie.genre)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                HStack(spacing: 16) {
                    // Rating
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(movie.formattedRating)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text(movie.duration)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Text(movie.releaseDate)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                // Favorite Button
                Button(action: {
                    dataManager.toggleFavorite(movie)
                }) {
                    HStack {
                        Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(movie.isFavorite ? .red : .white)
                        Text(movie.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                            .foregroundColor(.white)
                    }
                    .font(.system(size: 14, weight: .medium))
                }
            }
            
            Spacer()
        }
        .padding(.top, -80)
    }
}

struct ActionButtonsSection: View {
    let movie: MovieModel
    @Binding var watchProgress: Double
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        HStack(spacing: 12) {
            // Watch/Resume Button
            Button(action: {
                // Simulate watching - increase progress
                let newProgress = min(watchProgress + 0.1, 1.0)
                watchProgress = newProgress
            }) {
                HStack {
                    Image(systemName: watchProgress > 0 ? "play.fill" : "play.circle.fill")
                    Text(watchProgress > 0 ? "Resume" : "Watch")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.purple)
                .cornerRadius(8)
            }
            
            // Watchlist Button
            Button(action: {
                if dataManager.watchlist.contains(where: { $0.id == movie.id }) {
                    dataManager.removeFromWatchlist(movie)
                } else {
                    dataManager.addToWatchlist(movie)
                }
            }) {
                Image(systemName: dataManager.watchlist.contains(where: { $0.id == movie.id }) ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.6))
                    .cornerRadius(8)
            }
            
            // Edit Button
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.green.opacity(0.6))
                    .cornerRadius(8)
            }
            
            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.red.opacity(0.6))
                    .cornerRadius(8)
            }
        }
    }
}

struct WatchProgressSection: View {
    let movie: MovieModel
    @Binding var watchProgress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Watch Progress")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(Int(watchProgress * 100))%")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 8) {
                ProgressView(value: watchProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .scaleEffect(y: 2)
                
                Slider(value: $watchProgress, in: 0...1)
                    .accentColor(.green)
            }
            
            if watchProgress >= 1.0 {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Completed")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct PersonalRatingSection: View {
    let movie: MovieModel
    @Binding var personalRating: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Rating")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            HStack {
                ForEach(1...10, id: \.self) { star in
                    Button(action: {
                        personalRating = Double(star)
                    }) {
                        Image(systemName: Double(star) <= personalRating ? "star.fill" : "star")
                            .font(.system(size: 20))
                            .foregroundColor(Double(star) <= personalRating ? .yellow : .gray)
                    }
                }
                
                Spacer()
                
                if personalRating > 0 {
                    Text("\(Int(personalRating))/10")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct DetailsSection: View {
    let movie: MovieModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(movie.description)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .lineSpacing(4)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                DetailRow(title: "Director", value: movie.director)
                DetailRow(title: "Language", value: movie.language)
                DetailRow(title: "Country", value: movie.country)
                
                if let imdbRating = movie.imdbRating {
                    DetailRow(title: "IMDb", value: String(format: "%.1f", imdbRating))
                }
                
                if let rtScore = movie.rottenTomatoesScore {
                    DetailRow(title: "RT Score", value: "\(rtScore)%")
                }
                
                if movie.contentType == .tvShow || movie.contentType == .webSeries {
                    if let seasons = movie.seasons {
                        DetailRow(title: "Seasons", value: "\(seasons)")
                    }
                    if let episodes = movie.episodes {
                        DetailRow(title: "Episodes", value: "\(episodes)")
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CastCrewSection: View {
    let movie: MovieModel
    
    var body: some View {
        if !movie.cast.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cast")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(movie.cast, id: \.self) { actor in
                        Text(actor)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.purple.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

struct PersonalNotesSection: View {
    let movie: MovieModel
    @Binding var personalNotes: String
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Personal Notes")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.purple)
                }
            }
            
            if isEditing {
                TextEditor(text: $personalNotes)
                    .frame(minHeight: 100)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            } else {
                Text(personalNotes.isEmpty ? "Add your thoughts about this movie..." : personalNotes)
                    .font(.system(size: 14))
                    .foregroundColor(personalNotes.isEmpty ? .gray : .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        isEditing = true
                    }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct TagsCategoriesSection: View {
    let movie: MovieModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !movie.categories.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Categories")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(movie.categories, id: \.self) { category in
                            Text(category)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(6)
                        }
                    }
                }
            }
            
            if !movie.tags.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(movie.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(6)
                        }
                    }
                }
            }
            
            if !movie.streamingPlatforms.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Available On")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(movie.streamingPlatforms, id: \.self) { platform in
                            Text(platform)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.3))
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct EditMovieView: View {
    let movie: MovieModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Text("Edit Movie View")
            .foregroundColor(.white)
            .navigationTitle("Edit Movie")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
    }
}

#Preview {
    MovieDetailView(movie: MovieModel.sampleMovies[0]) { }
}

// LibraryView.swift - User Movie Collection

import SwiftUI
import PhotosUI

struct LibraryView: View {
    @Bindable var viewModel: LibraryViewModel
    @State private var showAddMovie = false
    @State private var selectedMovie: Movie? = nil
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                searchBar
                filterChips
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredMovies) { movie in
                            MovieGridCard(movie: movie)
                                .onTapGesture { selectedMovie = movie }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showAddMovie) {
            AddMovieView { movie in
                viewModel.addMovie(movie)
            }
        }
        .sheet(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, onUpdate: { viewModel.updateMovie($0) })
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Library")
                    .font(.largeTitle.bold())
                    .foregroundColor(AppColors.textPrimary)
                Text("\(viewModel.totalMovies) movies")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
            Button { showAddMovie = true } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(AppColors.cinematicGradient)
                    .frame(minWidth: 44, minHeight: 44)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - Search
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            TextField("Search movies...", text: $viewModel.searchText)
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(12)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
    
    // MARK: - Filter Chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterChip(nil, label: "All")
                ForEach(WatchStatus.allCases, id: \.self) { status in
                    filterChip(status, label: status.rawValue)
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 12)
    }
    
    private func filterChip(_ status: WatchStatus?, label: String) -> some View {
        let isSelected = viewModel.selectedFilter == status
        return Button {
            withAnimation(.spring()) { viewModel.selectedFilter = status }
        } label: {
            Text(label)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.accent : AppColors.cardBackground)
                .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Movie Grid Card
struct MovieGridCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: movie.mood.color).opacity(0.3), AppColors.cardBackground],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                
                if let data = movie.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Image(systemName: movie.posterName)
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(colors: [Color(hex: movie.mood.color), .white.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                        )
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(movie.title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(1)
            
            HStack(spacing: 4) {
                Text(movie.mood.emoji)
                    .font(.caption)
                Text(movie.genre)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            if movie.rating > 0 {
                HStack(spacing: 2) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < Int(movie.rating) ? "star.fill" : "star")
                            .font(.system(size: 9))
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
        }
    }
}

// MARK: - Add Movie View
struct AddMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var genre = ""
    @State private var mood: Mood = .excited
    @State private var description = ""
    @State private var notes = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil
    var onAdd: (Movie) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Photo Picker
                        VStack(spacing: 8) {
                            Text("Movie Photo")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                if let imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppColors.cardBackground)
                                            .frame(height: 200)
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo.badge.plus")
                                                .font(.system(size: 36))
                                                .foregroundStyle(AppColors.cinematicGradient)
                                            Text("Tap to add photo")
                                                .font(.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                    }
                                }
                            }
                            .onChange(of: selectedItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        imageData = data
                                    }
                                }
                            }
                        }
                        
                        formField("Title", text: $title)
                        formField("Genre", text: $genre)
                        formField("Description", text: $description)
                        formField("Notes", text: $notes)
                        
                        // Mood Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mood")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(Mood.allCases) { m in
                                        Button {
                                            mood = m
                                        } label: {
                                            Text("\(m.emoji) \(m.rawValue)")
                                                .font(.caption.weight(.medium))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(mood == m ? AppColors.accent : AppColors.cardBackground)
                                                .foregroundColor(.white)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppColors.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !title.isEmpty else { return }
                        let movie = Movie(title: title, genre: genre, mood: mood, description: description, imageData: imageData, notes: notes)
                        onAdd(movie)
                        dismiss()
                    }
                    .foregroundStyle(AppColors.cinematicGradient)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func formField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
            TextField(label, text: text)
                .padding(12)
                .background(AppColors.cardBackground)
                .foregroundColor(AppColors.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

// MARK: - Movie Detail View
struct MovieDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var movie: Movie
    var onUpdate: (Movie) -> Void
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Poster Focus
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: movie.mood.color).opacity(0.4), AppColors.cardBackground],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 300)
                        
                        if let data = movie.imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        } else {
                            Image(systemName: movie.posterName)
                                .font(.system(size: 80))
                                .foregroundStyle(
                                    LinearGradient(colors: [Color(hex: movie.mood.color), .white.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                                )
                        }
                    }
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 24)
                    
                    // Info
                    VStack(alignment: .leading, spacing: 16) {
                        Text(movie.title)
                            .font(.title.bold())
                            .foregroundColor(AppColors.textPrimary)
                        
                        // Mood Tag
                        HStack {
                            Text(movie.mood.emoji)
                            Text(movie.mood.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(Color(hex: movie.mood.color))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(hex: movie.mood.color).opacity(0.15))
                        .clipShape(Capsule())
                        
                        if !movie.genre.isEmpty {
                            Label(movie.genre, systemImage: "tag")
                                .font(.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        if !movie.description.isEmpty {
                            Text(movie.description)
                                .font(.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        // Rating
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Rating")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= Int(movie.rating) ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundColor(AppColors.accent)
                                        .frame(minWidth: 44, minHeight: 44)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            movie.rating = Double(star)
                                            onUpdate(movie)
                                        }
                                }
                            }
                        }
                        
                        // Watch Status
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                            HStack(spacing: 8) {
                                ForEach(WatchStatus.allCases, id: \.self) { status in
                                    Button {
                                        movie.watchStatus = status
                                        onUpdate(movie)
                                    } label: {
                                        Text(status.rawValue)
                                            .font(.caption.weight(.medium))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(movie.watchStatus == status ? AppColors.accent : AppColors.cardBackground)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        
                        // Notes
                        if !movie.notes.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Notes")
                                    .font(.caption)
                                    .foregroundColor(AppColors.textSecondary)
                                Text(movie.notes)
                                    .font(.body)
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(AppColors.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.textSecondary)
                    .frame(minWidth: 44, minHeight: 44)
            }
            .padding(24)
        }
    }
}

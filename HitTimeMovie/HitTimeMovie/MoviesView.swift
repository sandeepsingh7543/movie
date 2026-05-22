import SwiftUI

struct MoviesView: View {
    @EnvironmentObject var movieStore: MovieStore
    @State private var selectedMovie: UserMovie?
    @State private var searchText = ""
    @State private var showingSearch = false
    
    private var filteredMovies: [UserMovie] {
        if searchText.isEmpty {
            return movieStore.movies
        } else {
            return movieStore.movies.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.genre.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("My Movie")
                            .font(.system(size: 24, weight: .light, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Vault")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.gold)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showingSearch.toggle()
                        }
                    }) {
                        Image(systemName: showingSearch ? "xmark.circle.fill" : "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.gold)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                // Search Bar
                if showingSearch {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gold)
                        
                        TextField("Search movies...", text: $searchText)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gold, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
                }
                
                if filteredMovies.isEmpty {
                    Spacer()
                    EmptyStateView(isSearching: !searchText.isEmpty)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(filteredMovies) { movie in
                                MovieCard(movie: movie) {
                                    selectedMovie = movie
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie)
        }
    }
}

struct EmptyStateView: View {
    let isSearching: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: isSearching ? "magnifyingglass" : "film.stack")
                .font(.system(size: 60))
                .foregroundColor(.gold)
            
            Text(isSearching ? "No Results Found" : "No Movies Yet")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(isSearching ? "Try different keywords" : "Add your first movie to get started")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }
}

struct MovieCard: View {
    let movie: UserMovie
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Poster
                ZStack {
                    if let posterImage = movie.posterImage {
                        Image(uiImage: posterImage)
                            .resizable()
                            .aspectRatio(2/3, contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gold.opacity(0.3))
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gold)
                            )
                    }
                    
                    // Genre badge
                    VStack {
                        HStack {
                            Spacer()
                            Text(movie.genre)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color.gold))
                                .padding(.top, 8)
                                .padding(.trailing, 8)
                        }
                        Spacer()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // Movie Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(movie.genre)
                        .font(.system(size: 12))
                        .foregroundColor(.gold)
                    
                    Text(movie.releaseDate, style: .date)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.gold.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

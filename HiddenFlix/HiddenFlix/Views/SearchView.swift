import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var selectedGenre = "All"
    @State private var movies: [Movie] = []
    
    let genres = ["All", "Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Thriller", "Animation", "Documentary", "Fantasy"]
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    searchHeader
                    
                    if filteredMovies.isEmpty && !searchText.isEmpty {
                        emptySearchState
                    } else {
                        movieResults
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            fetchMovies()
        }
    }
    
    private var searchHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Search Movies")
                    .font(.custom("Inter", size: 28).weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search by title, cast, or genre", text: $searchText)
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.white)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(genres, id: \.self) { genre in
                        Button(action: { selectedGenre = genre }) {
                            Text(genre)
                                .font(.custom("Inter", size: 14).weight(.medium))
                                .foregroundColor(selectedGenre == genre ? .black : .white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedGenre == genre ? .white : .gray.opacity(0.2))
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
    
    private var movieResults: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieCardView(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    private var emptySearchState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Results Found")
                .font(.custom("Inter", size: 24).weight(.semibold))
                .foregroundColor(.white)
            
            Text("Try searching with different keywords")
                .font(.custom("Inter", size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var filteredMovies: [Movie] {
        var filtered = movies
        
        if selectedGenre != "All" {
            filtered = filtered.filter { $0.genre == selectedGenre }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { movie in
                movie.title.localizedCaseInsensitiveContains(searchText) ||
                movie.genre.localizedCaseInsensitiveContains(searchText) ||
                (movie.cast?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return filtered
    }
    
    private func fetchMovies() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.title, ascending: true)]
        
        do {
            movies = try viewContext.fetch(request)
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
}

#Preview {
    SearchView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

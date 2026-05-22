import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Movie.dateAdded, ascending: false)],
        predicate: NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
    ) private var favoriteMovies: FetchedResults<Movie>
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                    
                    if favoriteMovies.isEmpty {
                        emptyState
                    } else {
                        movieGrid
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(.custom("Inter", size: 28).weight(.bold))
                    .foregroundColor(.white)
                
                Text("\(favoriteMovies.count) movies")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.title2)
                .foregroundColor(.red)
        }
        .padding()
    }
    
    private var movieGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(favoriteMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieCardView(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Favorites Yet")
                .font(.custom("Inter", size: 24).weight(.semibold))
                .foregroundColor(.white)
            
            Text("Movies you mark as favorites will appear here")
                .font(.custom("Inter", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FavoritesView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

import SwiftUI
import CoreData

struct WatchlistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Movie.dateAdded, ascending: false)],
        predicate: NSPredicate(format: "isInWatchlist == %@", NSNumber(value: true))
    ) private var watchlistMovies: FetchedResults<Movie>
    
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
                    
                    if watchlistMovies.isEmpty {
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
                Text("Watchlist")
                    .font(.custom("Inter", size: 28).weight(.bold))
                    .foregroundColor(.white)
                
                Text("\(watchlistMovies.count) movies")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "bookmark.fill")
                .font(.title2)
                .foregroundColor(.purple)
        }
        .padding()
    }
    
    private var movieGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(watchlistMovies) { movie in
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
            Image(systemName: "bookmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Movies in Watchlist")
                .font(.custom("Inter", size: 24).weight(.semibold))
                .foregroundColor(.white)
            
            Text("Movies you want to watch later will appear here")
                .font(.custom("Inter", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WatchlistView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

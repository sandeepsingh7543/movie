import SwiftUI

struct ContentView: View {
    @StateObject private var movieStore = MovieStore()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(movieStore)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            DiscoverView()
                .environmentObject(movieStore)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(1)
            
            WatchlistView()
                .environmentObject(movieStore)
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Watchlist")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.white)
        .onAppear {
            movieStore.loadMovies()
        }
    }
}

#Preview {
    ContentView()
}

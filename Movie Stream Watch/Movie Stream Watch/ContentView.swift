import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.appBackground)
    }

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationStack {
                WatchlistView()
            }
            .tabItem {
                Image(systemName: "film.stack")
                Text("Watchlist")
            }

            DiscoverView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Discover")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color.appPrimary)
        .environmentObject(viewModel)
        .preferredColorScheme(.dark)
        .background(Color.appBackground)
    }
}

#Preview {
    ContentView()
}

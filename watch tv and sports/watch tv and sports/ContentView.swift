import SwiftUI

struct ContentView: View {
    @StateObject private var store = AppStore()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            
            PlayerListView()
                .tabItem { Label("Players", systemImage: "person.3.fill") }
                .tag(1)
            
            VideoLibraryView()
                .tabItem { Label("Videos", systemImage: "play.rectangle.fill") }
                .tag(2)
            
            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "star.fill") }
                .tag(3)
        }
        .environmentObject(store)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

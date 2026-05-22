import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    TabItemView(
                        icon: "house.fill",
                        title: "Home",
                        isSelected: selectedTab == 0
                    )
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    TabItemView(
                        icon: "magnifyingglass",
                        title: "Search",
                        isSelected: selectedTab == 1
                    )
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    TabItemView(
                        icon: "heart.fill",
                        title: "Favorites",
                        isSelected: selectedTab == 2
                    )
                }
                .tag(2)
            
            WatchlistView()
                .tabItem {
                    TabItemView(
                        icon: "bookmark.fill",
                        title: "Watchlist",
                        isSelected: selectedTab == 3
                    )
                }
                .tag(3)
            
            AnimeMainView()
                .tabItem {
                    TabItemView(
                        icon: "tv.fill",
                        title: "Anime",
                        isSelected: selectedTab == 4
                    )
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    TabItemView(
                        icon: "gearshape.fill",
                        title: "Settings",
                        isSelected: selectedTab == 5
                    )
                }
                .tag(5)
        }
        .accentColor(.purple)
        .preferredColorScheme(.dark)
        .onChange(of: selectedTab) { newTab in
            // Add haptic feedback when switching tabs
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            previousTab = newTab
        }
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.95)
            
            // Selected item appearance
            appearance.selectionIndicatorTintColor = UIColor.systemPurple
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemPurple
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.systemPurple,
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ]
            
            // Normal item appearance
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct TabItemView: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                .foregroundColor(isSelected ? .purple : .gray)
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            
            Text(title)
                .font(.custom("Inter", size: 12).weight(isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .purple : .gray)
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @Environment(\.modelContext) private var modelContext
    @State private var showAdd = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                WatchlistView()
                    .tag(1)
                Color.clear
                    .tag(2)
            }
            .tabViewStyle(.automatic)

            // Custom Tab Bar
            HStack(spacing: 0) {
                TabBarButton(icon: "house.fill", label: "Home", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabBarButton(icon: "bookmark.fill", label: "Watchlist", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                Button {
                    showAdd = true
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(Theme.accent)
                                .frame(width: 52, height: 52)
                                .shadow(color: Theme.accent.opacity(0.5), radius: 10)
                            Image(systemName: "plus")
                                .font(.title2).fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Text("Add")
                            .font(.caption2)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Add Movie")
            }
            .padding(.horizontal, 8)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .background(.ultraThinMaterial)
            .overlay(Rectangle().frame(height: 0.5).foregroundColor(Theme.glassBorder), alignment: .top)
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showAdd) {
            AddMovieView(vm: MovieViewModel(modelContext: modelContext))
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .preferredColorScheme(.dark)
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Theme.accent : Theme.textSecondary)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(isSelected ? Theme.accent : Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

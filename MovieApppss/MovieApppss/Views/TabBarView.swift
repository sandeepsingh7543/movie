//
//  TabBarView.swift
//  MovieApppss
//
//  Enhanced TabBar with modern design and animations
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    @StateObject private var dataManager = DataManager.shared
    @State private var isShowingAddMovieView = false
    @State private var isShowingAddActorView = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.purple.opacity(0.3),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                if appEnvironment.isTabViewVisible {
                    HeaderView(
                        title: getTitleForCurrentSection(),
                        subtitle: getSubtitleForCurrentSection(),
                        showAddButton: appEnvironment.currentSection != 3 && appEnvironment.currentSection != 4,
                        onAddTapped: {
                            if appEnvironment.currentSection == 0 {
                                isShowingAddMovieView = true
                            } else if appEnvironment.currentSection == 1 {
                                isShowingAddActorView = true
                            }
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Content
                TabView(selection: $appEnvironment.currentSection) {
                    MoviesView()
                        .tag(0)
                    
                    ActorsView()
                        .tag(1)
                    
                    WatchlistView()
                        .tag(2)
                    
                    AIRecommendationsView()
                        .tag(3)
                    
                    SettingsView()
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: appEnvironment.currentSection) { newValue in
                    // हर बार tab बदले तो ad दिखाओ
                    AdManager.showRewardedAd { success in
                        print("Rewarded ad finished: \(success)")
                    }
                }
                
                // Custom Tab Bar
                if appEnvironment.isTabViewVisible {
                    CustomTabBar(selectedTab: $appEnvironment.currentSection)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .sheet(isPresented: $isShowingAddMovieView) {
            AddMovieView()
        }
        .sheet(isPresented: $isShowingAddActorView) {
            AddActorView()
        }
        .animation(.easeInOut(duration: 0.3), value: appEnvironment.isTabViewVisible)
    }
    
    private func getTitleForCurrentSection() -> String {
        switch appEnvironment.currentSection {
        case 0: return "My Movies"
        case 1: return "Actors"
        case 2: return "Watchlist"
        case 3: return "AI Recommendations"
        case 4: return "Settings"
        default: return "Movies"
        }
    }
    
    private func getSubtitleForCurrentSection() -> String {
        switch appEnvironment.currentSection {
        case 0: return "Discover and manage your movie collection"
        case 1: return "Keep track of your favorite actors"
        case 2: return "Movies you want to watch"
        case 3: return "Personalized suggestions powered by AI"
        case 4: return "Customize your experience"
        default: return ""
        }
    }
}

struct HeaderView: View {
    let title: String
    let subtitle: String
    let showAddButton: Bool
    let onAddTapped: () -> Void
    
    var body: some View {
        ZStack {
            // Background with blur effect
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.purple.opacity(0.8),
                            Color.blue.opacity(0.6)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 120)
                .blur(radius: 1)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                Spacer()
                
                if showAddButton {
                    Button(action: onAddTapped) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showAddButton)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "film.fill", title: "Movies", tag: 0),
        TabItem(icon: "person.2.fill", title: "Actors", tag: 1),
        TabItem(icon: "bookmark.fill", title: "Watchlist", tag: 2),
        TabItem(icon: "brain.head.profile", title: "AI", tag: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    icon: tab.icon,
                    title: tab.title,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                // Glassmorphism effect
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.7))
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.1),
                                        Color.white.opacity(0.05)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.purple,
                                        Color.blue
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .gray)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
            }
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}

#Preview {
    TabBarView()
}

//
//  MainView.swift
//  MyTv123Moviesbox
//
//  Enhanced Main View with unique cinema-inspired design
//

import SwiftUI

struct MainView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    @State private var selectedTab = 0
    @State private var showingSplash = true
    @State private var isShowingSearch = false
    @State private var isShowingAddMovie = false
    
    var body: some View {
        ZStack {
            if showingSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else {
                mainContent
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    showingSplash = false
                }
            }
        }
    }
    
    private var mainContent: some View {
        ZStack {
            // Dynamic background
            themeManager.currentTheme.primaryGradient
                .ignoresSafeArea()
                .overlay(
                    AnimatedBackgroundView()
                        .opacity(0.3)
                )
            
            VStack(spacing: 0) {
                // Custom Header
                CustomHeaderView(
                    selectedTab: selectedTab,
                    onSearchTapped: { isShowingSearch = true },
                    onAddTapped: { isShowingAddMovie = true }
                )
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    ScannerView()
                        .tag(0)
                    
                    MoviesView()
                        .tag(1)
                    
                    TVShowsView()
                        .tag(2)
                    
                    FavoritesView()
                        .tag(3)
                    
                    ProfileView()
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: selectedTab) { newValue in
                    // Show rewarded ad when user switches tabs
                    AdManager.showRewardedAd { success in
                        DispatchQueue.main.async {
                            print("Rewarded ad completed on tab \(newValue)")
                        }
                    }
                }
                // Custom Tab Bar
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $isShowingSearch) {
            SearchView()
        }
        .sheet(isPresented: $isShowingAddMovie) {
            AddMovieView(defaultContentType: selectedTab == 2 ? .tvShow : .movie)
        }
    }
}

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 50
    @State private var backgroundRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Animated background
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.red.opacity(0.8),
                    Color.black,
                    Color.purple.opacity(0.6)
                ]),
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()
            .rotationEffect(.degrees(backgroundRotation))
            
            VStack(spacing: 30) {
                // Logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.red.opacity(0.5)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 150, height: 150)
                        .scaleEffect(logoScale)
                    
                    Image(systemName: "tv.fill")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                }
                .opacity(logoOpacity)
                
                VStack(spacing: 10) {
                    Text("MyTv123")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .offset(y: textOffset)
                        .opacity(logoOpacity)
                    
                    Text("Moviesbox")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.red)
                        .offset(y: textOffset)
                        .opacity(logoOpacity)
                    
                    Text("Your Ultimate Entertainment Hub")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .offset(y: textOffset)
                        .opacity(logoOpacity)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.7)) {
                logoScale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                logoOpacity = 1.0
            }
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.6)) {
                textOffset = 0
            }
            
            withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
                backgroundRotation = 360
            }
        }
    }
}

struct AnimatedBackgroundView: View {
    @State private var particles: [BackgroundParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles, id: \.id) { particle in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .blur(radius: 2)
                }
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        particles = (0..<15).map { _ in
            BackgroundParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 3...8)
            )
        }
    }
    
    private func animateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.linear(duration: 0.05)) {
                for i in particles.indices {
                    particles[i].position.x += CGFloat.random(in: -0.5...0.5)
                    particles[i].position.y += CGFloat.random(in: -0.5...0.5)
                    
                    // Wrap around screen
                    if particles[i].position.x < 0 {
                        particles[i].position.x = UIScreen.main.bounds.width
                    } else if particles[i].position.x > UIScreen.main.bounds.width {
                        particles[i].position.x = 0
                    }
                    
                    if particles[i].position.y < 0 {
                        particles[i].position.y = UIScreen.main.bounds.height
                    } else if particles[i].position.y > UIScreen.main.bounds.height {
                        particles[i].position.y = 0
                    }
                }
            }
        }
    }
}

struct BackgroundParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
}

#Preview {
    MainView()
}

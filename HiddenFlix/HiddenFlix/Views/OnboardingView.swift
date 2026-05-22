import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    @State private var animateContent = false
    
    let pages = [
        OnboardingPage(
            title: "Welcome to HiddenFlix",
            subtitle: "AI Movie World",
            description: "Discover amazing movies with AI-powered recommendations and create your personal collection",
            systemImage: "film.fill",
            color: .purple
        ),
        OnboardingPage(
            title: "Smart Discovery",
            subtitle: "AI Recommendations",
            description: "Get personalized movie suggestions based on your preferences and viewing history",
            systemImage: "brain.head.profile",
            color: .blue
        ),
        OnboardingPage(
            title: "Your Collection",
            subtitle: "Favorites & Watchlist",
            description: "Save movies you love, create watchlists, and generate unique AI movie ideas",
            systemImage: "heart.fill",
            color: .indigo
        )
    ]
    
    var body: some View {
        ZStack {
            // Enhanced animated background
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 500)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                
                // Enhanced page indicators
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? .white : .white.opacity(0.3))
                            .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
                    }
                }
                .padding(.vertical, 30)
                
                Spacer()
                
                // Enhanced get started button
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        hasSeenOnboarding = true
                    }
                }) {
                    HStack(spacing: 12) {
                        Text("Get Started")
                            .font(.custom("Inter", size: 20).weight(.bold))
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 20))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white)
                            .shadow(color: .white.opacity(0.3), radius: 15, x: 0, y: 8)
                    )
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: animateContent)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct AnimatedBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.8),
                    Color.blue.opacity(0.6),
                    Color.indigo.opacity(0.7),
                    Color.black
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animateGradient)
            
            // Floating particles
            ForEach(0..<20, id: \.self) { _ in
                FloatingParticle()
            }
        }
        .onAppear {
            animateGradient = true
        }
    }
}

struct FloatingParticle: View {
    @State private var position = CGPoint(x: CGFloat.random(in: 0...400), y: CGFloat.random(in: 0...800))
    @State private var opacity = Double.random(in: 0.1...0.3)
    @State private var scale = Double.random(in: 0.5...1.5)
    
    var body: some View {
        Circle()
            .fill(.white.opacity(opacity))
            .frame(width: 4, height: 4)
            .scaleEffect(scale)
            .position(position)
            .animation(.easeInOut(duration: Double.random(in: 3...6)).repeatForever(autoreverses: true), value: position)
            .onAppear {
                withAnimation {
                    position = CGPoint(x: CGFloat.random(in: 0...400), y: CGFloat.random(in: 0...800))
                }
            }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Enhanced icon with animation
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.color.opacity(0.3), page.color.opacity(0.1)],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateIcon)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, page.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: page.color.opacity(0.4), radius: 10)
                    .scaleEffect(animateIcon ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: animateIcon)
            }
            
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(page.title)
                        .font(.custom("Inter", size: 32).weight(.black))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(animateText ? 1.0 : 0.0)
                        .offset(y: animateText ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateText)
                    
                    Text(page.subtitle)
                        .font(.custom("Inter", size: 18).weight(.semibold))
                        .foregroundColor(page.color.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .opacity(animateText ? 1.0 : 0.0)
                        .offset(y: animateText ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateText)
                }
                
                Text(page.description)
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: animateText)
            }
        }
        .onChange(of: isActive) { active in
            if active {
                animateIcon = true
                animateText = true
            } else {
                animateIcon = false
                animateText = false
            }
        }
        .onAppear {
            if isActive {
                animateIcon = true
                animateText = true
            }
        }
    }
}

#Preview {
    OnboardingView()
}

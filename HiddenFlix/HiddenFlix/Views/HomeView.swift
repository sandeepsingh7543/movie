import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Movie.dateAdded, ascending: false)])
    private var movies: FetchedResults<Movie>
    
    @State private var showingAddMovie = false
    @State private var showingAIGenerator = false
    @State private var showingQuiz = false
    @State private var scrollOffset: CGFloat = 0
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            // Enhanced background
            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.1),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 32) {
                    headerSection
                    
                    if !movies.isEmpty {
                        RecommendationsView()
                            .transition(.opacity.combined(with: .slide))
                        
                        movieGrid
                    } else {
                        emptyState
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding()
            }
            .refreshable {
                // Add haptic feedback for refresh
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }
        }
        .sheet(isPresented: $showingAddMovie) {
            if #available(iOS 16.0, *) {
                AddMovieView()
            } else {
                AddMovieViewLegacy()
            }
        }
        .sheet(isPresented: $showingAIGenerator) {
            AIMovieGeneratorView()
        }
        .sheet(isPresented: $showingQuiz) {
            MovieQuizView()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // Enhanced app title with gradient
                    HStack(spacing: 8) {
                        Image(systemName: "film.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .blue, .indigo],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .purple.opacity(0.3), radius: 5)
                        
                        Text("HiddenFlix")
                            .font(.custom("Inter", size: 36).weight(.black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .purple.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    
                    Text("AI Movie World")
                        .font(.custom("Inter", size: 18).weight(.medium))
                        .foregroundColor(.purple.opacity(0.9))
                        .shadow(color: .purple.opacity(0.2), radius: 2)
                }
                
                Spacer()
                
                // Enhanced add button
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showingAddMovie = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .purple.opacity(0.4), radius: 8)
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddMovie)
                }
            }
            
            // Enhanced action buttons
            HStack(spacing: 16) {
                ActionButton(
                    icon: "brain.head.profile",
                    title: "AI Generator",
                    color: .purple,
                    action: { showingAIGenerator = true }
                )
                
                ActionButton(
                    icon: "questionmark.circle.fill",
                    title: "Quiz",
                    color: .blue,
                    action: { showingQuiz = true }
                )
                
                Spacer()
                
                // Enhanced movie count
                VStack(spacing: 4) {
                    Text("\(movies.count)")
                        .font(.custom("Inter", size: 24).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text("Movies")
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.2), radius: 4)
                )
            }
        }
    }
    
    private var movieGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Collection")
                    .font(.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Recently Added")
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(.gray)
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(movies.enumerated()), id: \.element) { index, movie in
                    MovieCardView(movie: movie)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .slide),
                            removal: .opacity
                        ))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05), value: movies.count)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            // Enhanced empty state icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.2), .blue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .purple.opacity(0.2), radius: 10)
                
                Image(systemName: "film")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 12) {
                Text("Welcome to HiddenFlix")
                    .font(.custom("Inter", size: 28).weight(.bold))
                    .foregroundColor(.white)
                
                Text("Start building your AI-powered movie collection")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(spacing: 16) {
                Button(action: { showingAddMovie = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                        
                        Text("Add Your First Movie")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                
                Button(action: { showingAIGenerator = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 18))
                        
                        Text("Generate with AI")
                            .font(.custom("Inter", size: 16).weight(.medium))
                    }
                    .foregroundColor(.purple)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.purple.opacity(0.5), lineWidth: 2)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    )
                }
            }
        }
        .padding(.top, 40)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.custom("Inter", size: 14).weight(.semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(color.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(color.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: color.opacity(0.2), radius: 4)
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

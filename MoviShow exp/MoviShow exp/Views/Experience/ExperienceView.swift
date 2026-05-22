// ExperienceView.swift - Cinematic Discovery Feed

import SwiftUI

struct ExperienceView: View {
    @Bindable var viewModel: ExperienceViewModel
    var onAddToJourney: ((JourneyEntry) -> Void)?
    @State private var dragOffset: CGSize = .zero
    @State private var showFeelingPicker = true
    @State private var showAddedToast = false
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    header
                    
                    if showFeelingPicker {
                        feelingPicker
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Swipe Card Area
                    if let movie = viewModel.currentMovie {
                        movieCard(movie)
                            .offset(x: dragOffset.width)
                            .rotationEffect(.degrees(Double(dragOffset.width / 30)))
                            .simultaneousGesture(swipeGesture)
                            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7), value: dragOffset)
                    } else {
                        emptyState
                            .padding(.top, 100)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .alert("Added to Journey", isPresented: $showAddedToast) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Movie has been added to your Journey successfully.")
        }
    }
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Experience")
                    .font(.largeTitle.bold())
                    .foregroundColor(AppColors.textPrimary)
                Text("Discover your next mood")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
            Button {
                withAnimation(.spring()) { showFeelingPicker.toggle() }
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundStyle(AppColors.cinematicGradient)
                    .frame(minWidth: 44, minHeight: 44)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - Feeling Picker
    private var feelingPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How are you feeling?")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // "All" pill
                    moodPill(nil, label: "All", emoji: "🎬")
                    
                    ForEach([Mood.happy, .sad, .excited, .relaxed], id: \.self) { mood in
                        moodPill(mood, label: mood.rawValue, emoji: mood.emoji)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.vertical, 16)
    }
    
    private func moodPill(_ mood: Mood?, label: String, emoji: String) -> some View {
        let isSelected = viewModel.selectedMood == mood
        return Button {
            withAnimation(.spring()) { viewModel.selectMood(mood) }
        } label: {
            HStack(spacing: 6) {
                Text(emoji)
                Text(label)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? AppColors.accent : AppColors.cardBackground)
            .foregroundColor(isSelected ? .white : AppColors.textSecondary)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isSelected ? AppColors.accent : AppColors.divider, lineWidth: 1))
        }
    }
    
    // MARK: - Movie Card
    private func movieCard(_ movie: Movie) -> some View {
        ZStack(alignment: .bottom) {
            // Poster Background
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: movie.mood.color).opacity(0.4), AppColors.cardBackground],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 460)
            
            // Photo (if set) or Icon
            if let data = movie.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
            } else {
                Image(systemName: movie.posterName)
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: movie.mood.color), .white.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(y: -60)
            }
            
            // Bottom Info Overlay
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(movie.mood.emoji)
                    Text(movie.mood.rawValue)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color(hex: movie.mood.color))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.5))
                .clipShape(Capsule())
                
                Text(movie.title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text(movie.description)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
                
                Text(movie.genre)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                // Add to Journey Button
                Button {
                    let entry = viewModel.addToJourney(movie)
                    onAddToJourney?(entry)
                    showAddedToast = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add to Journey")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.cinematicGradient)
                    .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: [Color.black.opacity(0.9), Color.clear], startPoint: .bottom, endPoint: .top)
            )
            .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .frame(height: 460)
        .padding(.horizontal, 24)
        .shadow(color: Color(hex: movie.mood.color).opacity(0.3), radius: 20, y: 10)
    }
    
    // MARK: - Swipe Gesture
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                if value.translation.width > 100 {
                    withAnimation(.spring()) { viewModel.swipePrevious() }
                } else if value.translation.width < -100 {
                    withAnimation(.spring()) { viewModel.swipeNext() }
                }
                withAnimation(.spring()) { dragOffset = .zero }
            }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.cinematicGradient)
            Text("No movies for this mood")
                .font(.headline)
                .foregroundColor(AppColors.textSecondary)
            Text("Try a different feeling")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary.opacity(0.7))
        }
    }
}

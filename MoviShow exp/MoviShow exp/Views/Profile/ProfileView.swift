// ProfileView.swift - Stats, Achievements & CineScore

import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    header
                    cineScoreCard
                    statsGrid
                    favoriteMoodsSection
                    achievementsSection
                    disclaimerText
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear { viewModel.updateAchievements() }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(AppColors.cinematicGradient)
                    .frame(width: 80, height: 80)
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
            Text("Movie Explorer")
                .font(.title2.bold())
                .foregroundColor(AppColors.textPrimary)
            
            Text(viewModel.watchPattern)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.top, 24)
    }
    
    // MARK: - CineScore
    private var cineScoreCard: some View {
        VStack(spacing: 12) {
            Text("CineScore")
                .font(.caption.weight(.semibold))
                .foregroundColor(AppColors.secondary)
            
            Text("\(viewModel.cineScore)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.cinematicGradient)
            
            Text("Your personal cinema rating")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.cinematicGradient, lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
    
    // MARK: - Stats Grid
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            statCard(icon: "film.stack", value: "\(viewModel.library.totalMovies)", label: "Total Movies")
            statCard(icon: "eye.fill", value: "\(viewModel.library.watchedCount)", label: "Watched")
            statCard(icon: "map.fill", value: "\(viewModel.journey.totalWatched)", label: "Journey Entries")
            statCard(icon: "star.fill", value: String(format: "%.1f", viewModel.library.averageRating), label: "Avg Rating")
        }
        .padding(.horizontal, 24)
    }
    
    private func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppColors.cinematicGradient)
            Text(value)
                .font(.title3.bold())
                .foregroundColor(AppColors.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    // MARK: - Favorite Moods
    private var favoriteMoodsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorite Moods")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 24)
            
            if viewModel.favoriteMoods.isEmpty {
                Text("Watch more movies to discover your mood")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 24)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.favoriteMoods) { mood in
                            VStack(spacing: 6) {
                                Text(mood.emoji)
                                    .font(.largeTitle)
                                Text(mood.rawValue)
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(Color(hex: mood.color))
                            }
                            .padding(16)
                            .background(Color(hex: mood.color).opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
    
    // MARK: - Achievements
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                ForEach(viewModel.achievements) { achievement in
                    achievementRow(achievement)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func achievementRow(_ achievement: Achievement) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? AppColors.accent : AppColors.cardBackground)
                    .frame(width: 44, height: 44)
                Image(systemName: achievement.icon)
                    .font(.body)
                    .foregroundColor(achievement.isUnlocked ? .white : AppColors.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(achievement.isUnlocked ? AppColors.textPrimary : AppColors.textSecondary)
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                // Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppColors.divider)
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(achievement.isUnlocked ? AppColors.accent : AppColors.secondary)
                            .frame(width: geo.size.width * achievement.progressPercent, height: 4)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            Text("\(achievement.progress)/\(achievement.requirement)")
                .font(.caption2)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(14)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    // MARK: - Disclaimer
    private var disclaimerText: some View {
        Text("This app does not stream movies. It provides cinematic discovery and personal tracking experience.")
            .font(.caption2)
            .foregroundColor(AppColors.textSecondary.opacity(0.6))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.top, 8)
    }
}

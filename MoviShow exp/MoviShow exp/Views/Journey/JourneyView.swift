// JourneyView.swift - Movie Journey Timeline

import SwiftUI

struct JourneyView: View {
    @Bindable var viewModel: JourneyViewModel
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                if viewModel.entries.isEmpty {
                    Spacer()
                    emptyState
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            insightCard
                            timelineSection
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Journey")
                    .font(.largeTitle.bold())
                    .foregroundColor(AppColors.textPrimary)
                Text("\(viewModel.totalWatched) movies experienced")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - Insight Card
    private var insightCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(AppColors.secondary)
                Text("Insight")
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Text(viewModel.tasteInsight)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
            
            // Mood Distribution Bar
            if !viewModel.moodDistribution.isEmpty {
                HStack(spacing: 4) {
                    ForEach(viewModel.moodDistribution.prefix(4), id: \.0) { mood, count in
                        let width = CGFloat(count) / CGFloat(viewModel.totalWatched)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: mood.color))
                            .frame(height: 6)
                            .frame(maxWidth: .infinity)
                            .scaleEffect(x: width * 2 + 0.5, anchor: .leading)
                    }
                }
                .padding(.top, 4)
                
                // Mood Labels
                HStack(spacing: 12) {
                    ForEach(viewModel.moodDistribution.prefix(4), id: \.0) { mood, count in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: mood.color))
                                .frame(width: 8, height: 8)
                            Text("\(mood.emoji)\(count)")
                                .font(.caption2)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - Timeline
    private var timelineSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.sortedEntries.enumerated()), id: \.element.id) { index, entry in
                TimelineEntryCard(entry: entry, isLast: index == viewModel.sortedEntries.count - 1)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.cinematicGradient)
            Text("Your journey begins here")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            Text("Add movies from Experience to start tracking")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

// MARK: - Timeline Entry Card
struct TimelineEntryCard: View {
    let entry: JourneyEntry
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline Line + Dot
            VStack(spacing: 0) {
                Circle()
                    .fill(Color(hex: entry.movie.mood.color))
                    .frame(width: 14, height: 14)
                    .shadow(color: Color(hex: entry.movie.mood.color).opacity(0.5), radius: 4)
                
                if !isLast {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: entry.movie.mood.color).opacity(0.6), AppColors.divider],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 14)
            
            // Card Content
            VStack(alignment: .leading, spacing: 10) {
                // Date
                Text(entry.watchedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                // Movie Info
                HStack(spacing: 12) {
                    // Mini Poster
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: entry.movie.mood.color).opacity(0.2))
                            .frame(width: 50, height: 50)
                        Image(systemName: entry.movie.posterName)
                            .font(.title3)
                            .foregroundColor(Color(hex: entry.movie.mood.color))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.movie.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(AppColors.textPrimary)
                        Text(entry.movie.genre)
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(entry.movie.mood.emoji)
                        .font(.title2)
                }
                
                // Emotion Flow
                HStack(spacing: 8) {
                    emotionBadge(entry.emotionBefore, label: "Before")
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    emotionBadge(entry.emotionAfter, label: "After")
                }
                
                // Personal Note
                if !entry.personalNote.isEmpty {
                    Text("\(entry.personalNote)")
                        .font(.caption)
                        .italic()
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.top, 4)
                }
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.bottom, isLast ? 0 : 8)
    }
    
    private func emotionBadge(_ mood: Mood, label: String) -> some View {
        VStack(spacing: 2) {
            Text(mood.emoji)
                .font(.caption)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(hex: mood.color).opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

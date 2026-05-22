//
//  ProfileView.swift
//  MyTv123Moviesbox
//
//  Enhanced Profile View with stats and settings
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    @State private var showingThemeSelector = false
    @State private var showingSettings = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 25) {
                
                // Stats Section
                StatsGridView()
                
                // Quick Actions
                QuickActionsView(
                    showingThemeSelector: $showingThemeSelector,
                    showingSettings: $showingSettings
                )
                
                // Recent Activity
                RecentActivityView()
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .sheet(isPresented: $showingThemeSelector) {
            ThemeSelectorView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct StatsGridView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    var totalWatchTime: String {
        let totalMinutes = dataManager.movies.filter { $0.isWatched }.count * 120 // Assuming 2 hours average
        let hours = totalMinutes / 60
        return "\(hours)h"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your Stats")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.currentTheme.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                StatCard(
                    title: "Total Movies",
                    value: "\(dataManager.movies.filter { $0.contentType == .movie }.count)",
                    icon: "film.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "TV Shows",
                    value: "\(dataManager.movies.filter { $0.contentType == .tvShow }.count)",
                    icon: "tv.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(dataManager.favorites.count)",
                    icon: "heart.fill",
                    color: .red
                )
                
                StatCard(
                    title: "Watch Time",
                    value: totalWatchTime,
                    icon: "clock.fill",
                    color: .orange
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.textPrimary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .background(themeManager.currentTheme.cardBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct QuickActionsView: View {
    @Binding var showingThemeSelector: Bool
    @Binding var showingSettings: Bool
    @StateObject private var themeManager = ThemeManager.shared
    
    let actions = [
        ("Theme", "paintbrush.fill", Color.purple),
        ("Settings", "gearshape.fill", Color.gray),
        ("Generate", "plus.circle.fill", Color.cyan)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.currentTheme.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                ForEach(actions, id: \.0) { action in
                    QuickActionButton(
                        title: action.0,
                        icon: action.1,
                        color: action.2,
                        action: {
                            switch action.0 {
                            case "Theme":
                                showingThemeSelector = true
                            case "Settings":
                                showingSettings = true
                            case "Generate":
                                MovieGenerator.addSampleMoviesToManager()
                            default:
                                break
                            }
                        }
                    )
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.textPrimary)
            }
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(themeManager.currentTheme.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentActivityView: View {
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(themeManager.currentTheme.textPrimary)
            
            if dataManager.recentlyWatched.isEmpty {
                Text("No recent activity")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.textSecondary)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(dataManager.recentlyWatched.prefix(3)) { movie in
                        ActivityRow(movie: movie)
                    }
                }
            }
        }
        .padding(20)
        .background(themeManager.currentTheme.cardBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(themeManager.accentColor.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ActivityRow: View {
    let movie: MovieModel
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(themeManager.accentColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: movie.contentType == .movie ? "film.fill" : "tv.fill")
                    .font(.system(size: 16))
                    .foregroundColor(themeManager.accentColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(movie.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(themeManager.currentTheme.textPrimary)
                    .lineLimit(1)
                
                Text("Watched recently")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}

struct ThemeSelectorView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ForEach(ThemeManager.AppTheme.allCases, id: \.self) { theme in
                    ThemeOptionCard(
                        theme: theme,
                        isSelected: themeManager.currentTheme == theme,
                        action: {
                            themeManager.setTheme(theme)
                        }
                    )
                }
                
                Spacer()
            }
            .padding(20)
            .background(themeManager.currentTheme.primaryGradient.ignoresSafeArea())
            .navigationTitle("Choose Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
            }
        }
    }
}

struct ThemeOptionCard: View {
    let theme: ThemeManager.AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Theme preview
                RoundedRectangle(cornerRadius: 10)
                    .fill(theme.primaryGradient)
                    .frame(width: 50, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(theme.textPrimary)
                    
                    Text("Tap to apply")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                }
            }
            .padding(20)
            .background(theme.cardBackground)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .background(Color.black)
}

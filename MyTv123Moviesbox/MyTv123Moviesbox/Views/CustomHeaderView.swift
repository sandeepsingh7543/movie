//
//  CustomHeaderView.swift
//  MyTv123Moviesbox
//
//  Clean header with better visibility
//

import SwiftUI

struct CustomHeaderView: View {
    @StateObject private var themeManager = ThemeManager.shared
    let selectedTab: Int
    let onSearchTapped: () -> Void
    let onAddTapped: () -> Void
    
    var body: some View {
        HStack {
            // Logo and Title
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(themeManager.accentColor.opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "tv.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(themeManager.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(getHeaderTitle())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(getHeaderSubtitle())
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 16) {
                // Add Button - only for Movies and TV Shows
                if selectedTab == 1 || selectedTab == 2 {
                    Button(action: onAddTapped) {
                        ZStack {
                            Circle()
                                .fill(themeManager.accentColor.opacity(0.2))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(themeManager.accentColor)
                        }
                    }
                }
                
                // Search Button
                Button(action: onSearchTapped) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 15)
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .blur(radius: 10)
        )
    }
    
    private func getHeaderTitle() -> String {
        switch selectedTab {
        case 0: return "Home"
        case 1: return "Movies"
        case 2: return "TV Shows"
        case 3: return "Favorites"
        case 4: return "Profile"
        default: return "MyTv123"
        }
    }
    
    private func getHeaderSubtitle() -> String {
        switch selectedTab {
        case 0: return "Discover trending content"
        case 1: return "Latest blockbusters"
        case 2: return "Binge-worthy series"
        case 3: return "Your loved content"
        case 4: return "Your entertainment profile"
        default: return "Entertainment hub"
        }
    }
}

#Preview {
    CustomHeaderView(selectedTab: 0, onSearchTapped: {}, onAddTapped: {})
        .background(Color.black)
}

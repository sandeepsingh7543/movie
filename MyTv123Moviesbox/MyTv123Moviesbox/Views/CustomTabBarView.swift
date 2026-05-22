//
//  CustomTabBarView.swift
//  MyTv123Moviesbox
//
//  Custom tab bar with cinema-inspired design
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Int
    @StateObject private var themeManager = ThemeManager.shared
    
    let tabs = [
        TabItem(icon: "house.fill", title: "Home"),
        TabItem(icon: "film.fill", title: "Movies"),
        TabItem(icon: "tv.fill", title: "TV Shows"),
        TabItem(icon: "heart.fill", title: "Favorites"),
        TabItem(icon: "person.fill", title: "Profile")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 25)
                    .fill(themeManager.currentTheme.cardBackground.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(themeManager.accentColor.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
                
                // Selection indicator
                RoundedRectangle(cornerRadius: 20)
                    .fill(themeManager.accentColor.opacity(0.2))
                    .frame(width: geometry.size.width / 5 - 10, height: 50)
                    .offset(x: calculateTabOffset(geometry: geometry))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedTab)
                
                // Tab items
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        TabBarButton(
                            tab: tabs[index],
                            isSelected: selectedTab == index,
                            action: {
                                selectedTab = index
                            }
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private func calculateTabOffset(geometry: GeometryProxy) -> CGFloat {
        let tabWidth = geometry.size.width / 5
        return CGFloat(selectedTab) * tabWidth - geometry.size.width / 2 + tabWidth / 2
    }
}

struct TabBarButton: View {
    @StateObject private var themeManager = ThemeManager.shared
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                action()
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(themeManager.accentColor.opacity(0.3))
                            .frame(width: 35, height: 35)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? themeManager.accentColor : themeManager.currentTheme.textSecondary)
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Text(tab.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? themeManager.accentColor : themeManager.currentTheme.textSecondary)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct TabItem {
    let icon: String
    let title: String
}

#Preview {
    CustomTabBarView(selectedTab: .constant(0))
        .background(Color.black)
}

//
//  MainTabView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var showingAddMovie = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            Color.clear
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Movie")
                }
                .tag(1)
            
            LibraryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }
                .tag(2)
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.yellow)
        .onChange(of: selectedTab) { _, newTab in
            if newTab == 1 {
                selectedTab = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showingAddMovie = true
                }
            }
        }
        .sheet(isPresented: $showingAddMovie) {
            AddMovieView(viewModel: viewModel)
        }
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
    }
}

#Preview {
    MainTabView()
}
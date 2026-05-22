// MainTabView.swift - Root Tab Navigation

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var libraryVM = LibraryViewModel()
    @State private var journeyVM = JourneyViewModel()
    @State private var experienceVM: ExperienceViewModel?
    @State private var profileVM: ProfileViewModel?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ExperienceView(viewModel: resolvedExperienceVM) { entry in
                journeyVM.addEntry(entry)
            }
            .tabItem {
                Label("Experience", systemImage: "sparkles")
            }
            .tag(0)
            
            LibraryView(viewModel: libraryVM)
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag(1)
            
            JourneyView(viewModel: journeyVM)
                .tabItem {
                    Label("Journey", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                }
                .tag(2)
            
            ProfileView(viewModel: resolvedProfileVM)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(3)
        }
        .tint(AppColors.accent)
        .onAppear { setupTabBarAppearance() }
    }
    
    private var resolvedExperienceVM: ExperienceViewModel {
        if let vm = experienceVM { return vm }
        let vm = ExperienceViewModel(library: libraryVM)
        DispatchQueue.main.async { experienceVM = vm }
        return vm
    }
    
    private var resolvedProfileVM: ProfileViewModel {
        if let vm = profileVM { return vm }
        let vm = ProfileViewModel(library: libraryVM, journey: journeyVM)
        DispatchQueue.main.async { profileVM = vm }
        return vm
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.background)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppColors.textSecondary)]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.accent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppColors.accent)]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

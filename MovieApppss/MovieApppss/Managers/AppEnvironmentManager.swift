//
//  AppEnvironmentManager.swift
//  MovieApppss
//
//  Enhanced Environment Manager
//

import Foundation
import SwiftUI

class AppEnvironmentManager: ObservableObject {
    static let shared = AppEnvironmentManager()
    
    @Published var currentSection: Int = 0
    @Published var selectedTheme: AppTheme = .dark
    @Published var isTabViewVisible: Bool = true
    @Published var searchText: String = ""
    @Published var selectedGenre: String = "All"
    @Published var sortOption: SortOption = .title
    @Published var viewMode: ViewMode = .grid
    
    enum AppTheme: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
    }
    
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case rating = "Rating"
        case releaseDate = "Release Date"
        case dateAdded = "Date Added"
        case watchProgress = "Watch Progress"
    }
    
    enum ViewMode: String, CaseIterable {
        case grid = "Grid"
        case list = "List"
    }
    
    private init() {}
    
    func resetToDefaults() {
        currentSection = 0
        selectedTheme = .dark
        isTabViewVisible = true
        searchText = ""
        selectedGenre = "All"
        sortOption = .title
        viewMode = .grid
    }
}

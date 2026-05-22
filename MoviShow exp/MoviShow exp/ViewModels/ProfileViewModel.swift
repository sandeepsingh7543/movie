// ProfileViewModel.swift - Stats, Achievements & CineScore

import SwiftUI
import Observation

@Observable
class ProfileViewModel {
    var achievements: [Achievement] = Achievement.defaults
    var library: LibraryViewModel
    var journey: JourneyViewModel
    
    init(library: LibraryViewModel, journey: JourneyViewModel) {
        self.library = library
        self.journey = journey
    }
    
    // CineScore: composite score based on activity
    var cineScore: Int {
        let watchedPoints = journey.totalWatched * 5
        let ratedPoints = library.movies.filter { $0.rating > 0 }.count * 3
        let achievementPoints = achievements.filter { $0.isUnlocked }.count * 10
        return watchedPoints + ratedPoints + achievementPoints
    }
    
    var favoriteMoods: [Mood] {
        Array(journey.moodDistribution.prefix(3).map { $0.0 })
    }
    
    var watchPattern: String {
        let count = journey.totalWatched
        if count == 0 { return "No movies yet" }
        if count < 5 { return "Casual Viewer" }
        if count < 15 { return "Regular Watcher" }
        return "Cinema Enthusiast"
    }
    
    func updateAchievements() {
        // First Steps
        if let i = achievements.firstIndex(where: { $0.title == "First Steps" }) {
            achievements[i].progress = min(library.totalMovies, 1)
        }
        // Movie Buff
        if let i = achievements.firstIndex(where: { $0.title == "Movie Buff" }) {
            achievements[i].progress = journey.totalWatched
        }
        // Mood Explorer
        if let i = achievements.firstIndex(where: { $0.title == "Mood Explorer" }) {
            let uniqueMoods = Set(journey.entries.map { $0.movie.mood })
            achievements[i].progress = uniqueMoods.count
        }
        // Critic Eye
        if let i = achievements.firstIndex(where: { $0.title == "Critic Eye" }) {
            achievements[i].progress = library.movies.filter { $0.rating > 0 }.count
        }
        // Journey Master
        if let i = achievements.firstIndex(where: { $0.title == "Journey Master" }) {
            achievements[i].progress = journey.totalWatched
        }
        // CineScore Pro
        if let i = achievements.firstIndex(where: { $0.title == "CineScore Pro" }) {
            achievements[i].progress = cineScore
        }
    }
}

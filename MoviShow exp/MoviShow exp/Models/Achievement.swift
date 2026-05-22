// Achievement.swift - Gamification Model

import Foundation

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let requirement: Int
    var progress: Int
    
    var isUnlocked: Bool { progress >= requirement }
    var progressPercent: Double { min(Double(progress) / Double(requirement), 1.0) }
    
    init(id: UUID = UUID(), title: String, description: String, icon: String, requirement: Int, progress: Int = 0) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.requirement = requirement
        self.progress = progress
    }
}

extension Achievement {
    static let defaults: [Achievement] = [
        Achievement(title: "First Steps", description: "Add your first movie", icon: "star.fill", requirement: 1, progress: 0),
        Achievement(title: "Movie Buff", description: "Watch 10 movies", icon: "film.stack", requirement: 10, progress: 0),
        Achievement(title: "Mood Explorer", description: "Experience all moods", icon: "theatermasks", requirement: 8, progress: 0),
        Achievement(title: "Critic Eye", description: "Rate 5 movies", icon: "eye.fill", requirement: 5, progress: 0),
        Achievement(title: "Journey Master", description: "Complete 20 journey entries", icon: "map.fill", requirement: 20, progress: 0),
        Achievement(title: "CineScore Pro", description: "Reach CineScore 100", icon: "trophy.fill", requirement: 100, progress: 0),
    ]
}

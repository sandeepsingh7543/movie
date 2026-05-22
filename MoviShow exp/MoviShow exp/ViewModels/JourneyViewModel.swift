// JourneyViewModel.swift - Journey Timeline & Insights

import SwiftUI
import Observation

@Observable
class JourneyViewModel {
    var entries: [JourneyEntry] = JourneyEntry.samples
    
    var sortedEntries: [JourneyEntry] {
        entries.sorted { $0.watchedDate > $1.watchedDate }
    }
    
    func addEntry(_ entry: JourneyEntry) {
        entries.append(entry)
    }
    
    // MARK: - Insights
    var topMood: Mood? {
        let moods = entries.map { $0.movie.mood }
        let counts = Dictionary(grouping: moods, by: { $0 }).mapValues { $0.count }
        return counts.max(by: { $0.value < $1.value })?.key
    }
    
    var moodDistribution: [(Mood, Int)] {
        let counts = Dictionary(grouping: entries, by: { $0.movie.mood }).mapValues { $0.count }
        return counts.sorted { $0.value > $1.value }
    }
    
    var tasteInsight: String {
        guard let top = topMood else { return "Start your journey!" }
        let recent = entries.prefix(3).map { $0.movie.mood }
        let recentTop = Dictionary(grouping: recent, by: { $0 }).mapValues { $0.count }.max(by: { $0.value < $1.value })?.key
        if let r = recentTop, r != top {
            return "Your taste is evolving toward \(r.rawValue)"
        }
        return "You mostly watch \(top.rawValue) movies"
    }
    
    var totalWatched: Int { entries.count }
}

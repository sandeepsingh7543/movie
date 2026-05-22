// JourneyEntry.swift - Journey Timeline Model

import Foundation

struct JourneyEntry: Identifiable, Codable {
    let id: UUID
    let movie: Movie
    let watchedDate: Date
    var emotionBefore: Mood
    var emotionAfter: Mood
    var personalNote: String
    
    init(
        id: UUID = UUID(),
        movie: Movie,
        watchedDate: Date = Date(),
        emotionBefore: Mood = .relaxed,
        emotionAfter: Mood = .happy,
        personalNote: String = ""
    ) {
        self.id = id
        self.movie = movie
        self.watchedDate = watchedDate
        self.emotionBefore = emotionBefore
        self.emotionAfter = emotionAfter
        self.personalNote = personalNote
    }
}

extension JourneyEntry {
    static let samples: [JourneyEntry] = [
        JourneyEntry(movie: Movie.samples[0], watchedDate: Date().addingTimeInterval(-86400 * 30), emotionBefore: .relaxed, emotionAfter: .excited, personalNote: "Mind-blowing visuals!"),
        JourneyEntry(movie: Movie.samples[1], watchedDate: Date().addingTimeInterval(-86400 * 20), emotionBefore: .sad, emotionAfter: .emotional, personalNote: "Cried at the ending"),
        JourneyEntry(movie: Movie.samples[2], watchedDate: Date().addingTimeInterval(-86400 * 10), emotionBefore: .excited, emotionAfter: .action, personalNote: "Pure adrenaline rush"),
        JourneyEntry(movie: Movie.samples[3], watchedDate: Date().addingTimeInterval(-86400 * 5), emotionBefore: .chill, emotionAfter: .relaxed, personalNote: "Perfect weekend movie"),
        JourneyEntry(movie: Movie.samples[4], watchedDate: Date().addingTimeInterval(-86400 * 2), emotionBefore: .excited, emotionAfter: .thriller, personalNote: "Edge of my seat!"),
    ]
}

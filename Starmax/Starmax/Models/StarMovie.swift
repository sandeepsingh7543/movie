import Foundation
import SwiftData

@Model
final class StarMovie {
    @Attribute(.unique) var id: UUID
    var title: String
    var genre: String
    var rating: Double
    var statusRaw: String
    var notes: String
    var posterPath: String?
    var releaseYear: Int
    var durationMinutes: Int
    var moodTagRaw: String
    var isFavorite: Bool
    var rewatchReminderEnabled: Bool
    var rewatchReminderDate: Date?
    var watchedAt: Date?
    var createdAt: Date
    var updatedAt: Date
    var collectionNamesRaw: String

    init(
        id: UUID = UUID(),
        title: String,
        genre: String,
        rating: Double,
        status: MovieStatus,
        notes: String = "",
        posterPath: String? = nil,
        releaseYear: Int,
        durationMinutes: Int,
        moodTag: MoodTag,
        isFavorite: Bool = false,
        rewatchReminderEnabled: Bool = false,
        rewatchReminderDate: Date? = nil,
        watchedAt: Date? = nil,
        collectionNames: [String] = [],
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.genre = genre
        self.rating = rating
        self.statusRaw = status.rawValue
        self.notes = notes
        self.posterPath = posterPath
        self.releaseYear = releaseYear
        self.durationMinutes = durationMinutes
        self.moodTagRaw = moodTag.rawValue
        self.isFavorite = isFavorite
        self.rewatchReminderEnabled = rewatchReminderEnabled
        self.rewatchReminderDate = rewatchReminderDate
        self.watchedAt = watchedAt
        self.collectionNamesRaw = collectionNames.joined(separator: "|")
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var status: MovieStatus {
        get { MovieStatus(rawValue: statusRaw) ?? .planToWatch }
        set { statusRaw = newValue.rawValue }
    }

    var moodTag: MoodTag {
        get { MoodTag(rawValue: moodTagRaw) ?? .chill }
        set { moodTagRaw = newValue.rawValue }
    }

    var collectionNames: [String] {
        collectionNamesRaw
            .split(separator: "|")
            .map(String.init)
            .filter { !$0.isEmpty }
            .sorted()
    }
}

import Foundation
import UIKit

struct MovieDraft: Equatable {
    var title: String = ""
    var genre: String = MovieGenreCatalog.genres.first ?? "Drama"
    var rating: Double = 3.5
    var status: MovieStatus = .planToWatch
    var notes: String = ""
    var releaseYear: Int = Calendar.current.component(.year, from: .now)
    var durationMinutes: Int = 120
    var moodTag: MoodTag = .chill
    var isFavorite: Bool = false
    var rewatchReminderEnabled: Bool = false
    var rewatchReminderDate: Date? = Calendar.current.date(byAdding: .day, value: 14, to: .now)
    var posterImage: UIImage?
    var posterPath: String?
    var posterWasCleared: Bool = false
    var selectedCollectionNames: Set<String> = []

    init() {}

    init(movie: StarMovie) {
        self.title = movie.title
        self.genre = movie.genre
        self.rating = movie.rating
        self.status = movie.status
        self.notes = movie.notes
        self.releaseYear = movie.releaseYear
        self.durationMinutes = movie.durationMinutes
        self.moodTag = movie.moodTag
        self.isFavorite = movie.isFavorite
        self.rewatchReminderEnabled = movie.rewatchReminderEnabled
        self.rewatchReminderDate = movie.rewatchReminderDate
        self.posterPath = movie.posterPath
        self.selectedCollectionNames = Set(movie.collectionNames)
    }
}


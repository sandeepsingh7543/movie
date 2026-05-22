import Foundation
import SwiftData

@MainActor
final class DataManager {
    static let shared = DataManager()

    private init() {}

    func upsertCollection(named name: String, in context: ModelContext) throws -> MovieCollection {
        let normalized = MovieCollection.normalizeName(name)
        let descriptor = FetchDescriptor<MovieCollection>(
            predicate: #Predicate<MovieCollection> { collection in
                collection.name == normalized
            }
        )

        if let existing = try context.fetch(descriptor).first {
            return existing
        }

        let accent = generatedAccentHex(for: normalized)
        let collection = MovieCollection(name: normalized, accentHex: accent)
        context.insert(collection)
        try context.save()
        return collection
    }

    func upsertMovie(
        from draft: MovieDraft,
        editing movie: StarMovie?,
        in context: ModelContext
    ) throws -> StarMovie {
        let target = movie ?? StarMovie(
            title: draft.title,
            genre: draft.genre,
            rating: draft.rating,
            status: draft.status,
            notes: draft.notes,
            posterPath: nil,
            releaseYear: draft.releaseYear,
            durationMinutes: draft.durationMinutes,
            moodTag: draft.moodTag
        )

        if movie == nil {
            context.insert(target)
        }

        let previousPosterPath = target.posterPath
        var finalPosterPath = previousPosterPath

        if draft.posterWasCleared {
            if let previousPosterPath {
                ImageManager.shared.deleteImage(at: previousPosterPath)
            }
            finalPosterPath = nil
        } else if let posterImage = draft.posterImage {
            if let previousPosterPath {
                ImageManager.shared.deleteImage(at: previousPosterPath)
            }
            finalPosterPath = try ImageManager.shared.savePosterImage(posterImage)
        } else if draft.posterPath == nil, movie == nil {
            finalPosterPath = nil
        }

        target.title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        target.genre = draft.genre
        target.rating = draft.rating
        target.status = draft.status
        target.notes = draft.notes
        target.posterPath = finalPosterPath
        target.releaseYear = draft.releaseYear
        target.durationMinutes = draft.durationMinutes
        target.moodTag = draft.moodTag
        target.isFavorite = draft.isFavorite
        target.rewatchReminderEnabled = draft.rewatchReminderEnabled
        target.rewatchReminderDate = draft.rewatchReminderEnabled ? draft.rewatchReminderDate : nil
        if draft.status == .watched {
            target.watchedAt = .now
        }
        target.updatedAt = .now

        let collectionModels: [MovieCollection] = try draft.selectedCollectionNames.compactMap { name in
            let trimmed = MovieCollection.normalizeName(name)
            guard !trimmed.isEmpty else { return nil }
            return try upsertCollection(named: trimmed, in: context)
        }
        target.collectionNamesRaw = collectionModels.map { $0.name }.sorted().joined(separator: "|")

        try context.save()
        return target
    }

    func deleteMovie(_ movie: StarMovie, in context: ModelContext) throws {
        let posterPath = movie.posterPath
        context.delete(movie)
        try context.save()
        ImageManager.shared.deleteImage(at: posterPath)
    }

    func resetAllData(in context: ModelContext) throws {
        let movies = try context.fetch(FetchDescriptor<StarMovie>())
        movies.forEach { ImageManager.shared.deleteImage(at: $0.posterPath) }
        movies.forEach { context.delete($0) }

        let collections = try context.fetch(FetchDescriptor<MovieCollection>())
        collections.forEach { context.delete($0) }

        try context.save()
        ImageManager.shared.clearAllImages()
    }

    private func generatedAccentHex(for name: String) -> String {
        let palette = [
            "#89C2FF", "#6EE7F9", "#8EF7C9", "#FF9E6B", "#C9A5FF",
            "#FF7DA8", "#FFD166", "#82D2FF", "#A7F3D0", "#F97316"
        ]
        let index = abs(name.hashValue) % palette.count
        return palette[index]
    }
}

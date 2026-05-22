import SwiftUI

struct MovieLibraryStats {
    let totalCount: Int
    let watchedCount: Int
    let unwatchedCount: Int
    let averageRating: Double
    let favoriteGenre: String
    let weeklyTrend: [WeeklyTrendPoint]
}

@MainActor
final class StatsViewModel: ObservableObject {
    func stats(from movies: [StarMovie]) -> MovieLibraryStats {
        let totalCount = movies.count
        let watchedMovies = movies.filter { $0.status == .watched }
        let watchedCount = watchedMovies.count
        let unwatchedCount = totalCount - watchedCount
        let averageRating = movies.isEmpty ? 0 : movies.map(\.rating).reduce(0, +) / Double(totalCount)

        let groupedGenres = Dictionary(grouping: movies, by: \.genre)
        let favoriteGenre = groupedGenres
            .sorted {
                let lhsScore = $0.value.filter { $0.status == .watched }.count
                let rhsScore = $1.value.filter { $0.status == .watched }.count
                if lhsScore == rhsScore {
                    return $0.value.count > $1.value.count
                }
                return lhsScore > rhsScore
            }
            .first?
            .key ?? "No data"

        let weeklyTrend = buildWeeklyTrend(from: watchedMovies)

        return MovieLibraryStats(
            totalCount: totalCount,
            watchedCount: watchedCount,
            unwatchedCount: unwatchedCount,
            averageRating: averageRating,
            favoriteGenre: favoriteGenre,
            weeklyTrend: weeklyTrend
        )
    }

    private func buildWeeklyTrend(from movies: [StarMovie]) -> [WeeklyTrendPoint] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)

        let days = (0..<7).compactMap { offset -> Date? in
            calendar.date(byAdding: .day, value: -offset, to: startOfToday)
        }.sorted()

        return days.map { day in
            let count = movies.filter { movie in
                guard let watchedAt = movie.watchedAt else { return false }
                return calendar.isDate(watchedAt, inSameDayAs: day)
            }.count
            return WeeklyTrendPoint(date: day, watchCount: count)
        }
    }
}

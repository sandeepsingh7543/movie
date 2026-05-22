import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query(sort: [SortDescriptor(\StarMovie.updatedAt, order: .reverse)]) private var movies: [StarMovie]
    @StateObject private var viewModel = StatsViewModel()
    @Environment(\.starmaxPalette) private var palette

    private var stats: MovieLibraryStats {
        viewModel.stats(from: movies)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header
                metricsGrid
                statusChart
                genreCard
                weeklyTrendCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Stats")
        .navigationBarTitleDisplayMode(.large)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Insights from your library")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(palette.textPrimary)
            Text("Every chart is calculated locally from movies you created on this device.")
                .font(.subheadline)
                .foregroundStyle(palette.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .starmaxCard()
    }

    private var metricsGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                statTile(title: "Total Movies", value: "\(stats.totalCount)")
                statTile(title: "Watched", value: "\(stats.watchedCount)")
            }
            HStack(spacing: 12) {
                statTile(title: "Unwatched", value: "\(stats.unwatchedCount)")
                statTile(title: "Avg Rating", value: String(format: "%.1f", stats.averageRating))
            }
        }
    }

    private func statTile(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(palette.textSecondary)
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(palette.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .starmaxCard()
    }

    private var statusChart: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("Watched vs Unwatched", subtitle: "A clean summary of your current library health.")

            Chart {
                BarMark(
                    x: .value("Status", "Watched"),
                    y: .value("Count", stats.watchedCount)
                )
                .foregroundStyle(Color(hex: 0x8EF7C9))

                BarMark(
                    x: .value("Status", "Pending"),
                    y: .value("Count", stats.unwatchedCount)
                )
                .foregroundStyle(Color(hex: 0xFFD166))
            }
            .frame(height: 240)
            .chartXAxis {
                AxisMarks(values: ["Watched", "Pending"])
            }
            .chartYScale(domain: 0...max(stats.totalCount, 1))
        }
        .starmaxCard()
    }

    private var genreCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("Favorite Genre", subtitle: "The genre you’ve watched the most in this library.")

            Text(stats.favoriteGenre)
                .font(.title2.weight(.bold))
                .foregroundStyle(palette.textPrimary)

            ProgressView(value: stats.totalCount == 0 ? 0 : Double(stats.watchedCount) / Double(stats.totalCount))
                .tint(Color(hex: 0x89C2FF))
                .scaleEffect(y: 1.5)
        }
        .starmaxCard()
    }

    private var weeklyTrendCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("Weekly Watch Trend", subtitle: "How many titles you watched on each of the last 7 days.")

            if stats.weeklyTrend.isEmpty {
                Text("Watch a few titles to unlock trend insights.")
                    .foregroundStyle(palette.textSecondary)
            } else {
                Chart(stats.weeklyTrend) { point in
                    LineMark(
                        x: .value("Date", point.date, unit: .day),
                        y: .value("Watched", point.watchCount)
                    )
                    .foregroundStyle(Color(hex: 0x89C2FF))
                    .symbol(Circle().strokeBorder(lineWidth: 2))

                    AreaMark(
                        x: .value("Date", point.date, unit: .day),
                        y: .value("Watched", point.watchCount)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: 0x89C2FF).opacity(0.38), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 220)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
        .starmaxCard()
    }
}

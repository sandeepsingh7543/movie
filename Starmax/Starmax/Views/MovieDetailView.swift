import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.starmaxPalette) private var palette
    let movie: StarMovie
    let collections: [MovieCollection]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    header
                    summaryCard
                    notesCard
                    collectionsCard
                    remindersCard
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(StarmaxBackground().ignoresSafeArea())
            .navigationTitle(movie.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            PosterView(posterPath: movie.posterPath, title: movie.title)
                .frame(width: 104, height: 156)

            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(palette.textPrimary)

                Text("\(movie.genre) • \(movie.releaseYear)")
                    .foregroundStyle(palette.textSecondary)

                RatingStarsView(rating: movie.rating, size: 14)

                HStack {
                    MovieStatusBadge(status: movie.status)
                    if movie.isFavorite {
                        Label("Favorite", systemImage: "star.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color(hex: 0xFFD166))
                    }
                }
            }

            Spacer()
        }
        .starmaxCard()
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            PremiumSectionHeader("Quick Facts", subtitle: "A compact overview of the movie you added.")
            gridRow(label: "Mood", value: movie.moodTag.rawValue)
            gridRow(label: "Duration", value: "\(movie.durationMinutes) min")
            gridRow(label: "Rating", value: String(format: "%.1f", movie.rating))
            gridRow(label: "Watch Status", value: movie.status.rawValue)
        }
        .starmaxCard()
    }

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            PremiumSectionHeader("Notes")
            Text(movie.notes.isEmpty ? "No notes added yet." : movie.notes)
                .foregroundStyle(palette.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .starmaxCard()
    }

    private var collectionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            PremiumSectionHeader("Collections")

            if movie.collectionNames.isEmpty {
                Text("This movie is not inside any collection yet.")
                    .foregroundStyle(palette.textSecondary)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(movie.collectionNames, id: \.self) { name in
                        CollectionChip(name: name, accentHex: collections.first(where: { $0.name == name })?.accentHex)
                    }
                }
            }
        }
        .starmaxCard()
    }

    private var remindersCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            PremiumSectionHeader("Rewatch Reminder")

            if movie.rewatchReminderEnabled, let date = movie.rewatchReminderDate {
                Text("Reminder set for \(date.formatted(date: .abbreviated, time: .omitted)).")
                    .foregroundStyle(palette.textPrimary)
            } else {
                Text("No reminder is active for this title.")
                    .foregroundStyle(palette.textSecondary)
            }
        }
        .starmaxCard()
    }

    private func gridRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(palette.textSecondary)
            Spacer()
            Text(value)
                .foregroundStyle(palette.textPrimary)
                .fontWeight(.semibold)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 320
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
    }
}

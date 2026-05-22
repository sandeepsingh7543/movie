import Foundation
import SwiftData

@Model
final class MovieCollection {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var accentHex: String
    var createdAt: Date

    init(name: String, accentHex: String = "#89C2FF", createdAt: Date = .now) {
        self.id = UUID()
        self.name = MovieCollection.normalizeName(name)
        self.accentHex = accentHex
        self.createdAt = createdAt
    }

    static func normalizeName(_ name: String) -> String {
        name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map { $0.lowercased().capitalized }
            .joined(separator: " ")
    }
}

// Movie.swift - Core Movie Model

import Foundation

// MARK: - Mood Enum
enum Mood: String, CaseIterable, Codable, Identifiable {
    case happy = "Happy"
    case sad = "Sad"
    case excited = "Excited"
    case relaxed = "Relaxed"
    case action = "Action"
    case chill = "Chill"
    case emotional = "Emotional"
    case thriller = "Thriller"
    
    var id: String { rawValue }
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .sad: return "😢"
        case .excited: return "🤩"
        case .relaxed: return "😌"
        case .action: return "💥"
        case .chill: return "🧊"
        case .emotional: return "🥺"
        case .thriller: return "😱"
        }
    }
    
    var color: String {
        switch self {
        case .happy: return "FFD700"
        case .sad: return "6B7FD7"
        case .excited: return "FF2E63"
        case .relaxed: return "00F5FF"
        case .action: return "FF6B35"
        case .chill: return "7FDBFF"
        case .emotional: return "C77DFF"
        case .thriller: return "FF4444"
        }
    }
}

// MARK: - Watch Status
enum WatchStatus: String, Codable, CaseIterable {
    case unwatched = "Unwatched"
    case watching = "Watching"
    case watched = "Watched"
    case rewatching = "Rewatching"
}

// MARK: - Movie Model
struct Movie: Identifiable, Codable {
    let id: UUID
    var title: String
    var genre: String
    var mood: Mood
    var description: String
    var posterName: String  // SF Symbol or asset name
    var imageData: Data?    // User-selected photo
    var rating: Double      // 0-5
    var notes: String
    var watchStatus: WatchStatus
    var dateAdded: Date
    var dateWatched: Date?
    
    init(
        id: UUID = UUID(),
        title: String,
        genre: String = "",
        mood: Mood = .excited,
        description: String = "",
        posterName: String = "film",
        imageData: Data? = nil,
        rating: Double = 0,
        notes: String = "",
        watchStatus: WatchStatus = .unwatched,
        dateAdded: Date = Date(),
        dateWatched: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.genre = genre
        self.mood = mood
        self.description = description
        self.posterName = posterName
        self.imageData = imageData
        self.rating = rating
        self.notes = notes
        self.watchStatus = watchStatus
        self.dateAdded = dateAdded
        self.dateWatched = dateWatched
    }
}

// MARK: - Sample Data
extension Movie {
    static let samples: [Movie] = [
        Movie(title: "Neon Horizon", genre: "Sci-Fi", mood: .excited, description: "A cyberpunk journey through neon-lit streets", posterName: "sparkles", rating: 4.5),
        Movie(title: "Silent Waves", genre: "Drama", mood: .emotional, description: "A touching story of love across oceans", posterName: "water.waves", rating: 4.0),
        Movie(title: "Thunder Strike", genre: "Action", mood: .action, description: "Non-stop adrenaline from start to finish", posterName: "bolt.fill", rating: 3.5),
        Movie(title: "Midnight Garden", genre: "Romance", mood: .relaxed, description: "A peaceful evening in a magical garden", posterName: "leaf.fill", rating: 4.2),
        Movie(title: "The Last Code", genre: "Thriller", mood: .thriller, description: "A hacker races against time to save the world", posterName: "lock.shield", rating: 4.8),
        Movie(title: "Sunshine Days", genre: "Comedy", mood: .happy, description: "Feel-good moments that warm your heart", posterName: "sun.max.fill", rating: 3.8),
        Movie(title: "Blue Requiem", genre: "Drama", mood: .sad, description: "A melancholic symphony of memories", posterName: "cloud.rain", rating: 4.1),
        Movie(title: "Arctic Drift", genre: "Adventure", mood: .chill, description: "Cool adventures in frozen landscapes", posterName: "snowflake", rating: 3.9),
    ]
}

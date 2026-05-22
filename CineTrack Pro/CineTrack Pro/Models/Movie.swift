//
//  Movie.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import Foundation
import SwiftUI

// MARK: - Movie Model
struct Movie: Identifiable, Codable {
    var id: UUID
    var title: String
    var genre: MovieGenre
    var rating: Double
    var watchStatus: WatchStatus
    var personalNotes: String
    var posterImageData: Data?
    var releaseDate: Date
    var dateAdded: Date
    var lastViewed: Date?
    
    init(title: String, genre: MovieGenre, rating: Double, watchStatus: WatchStatus, personalNotes: String = "", posterImageData: Data? = nil, releaseDate: Date) {
        self.id = UUID()
        self.title = title
        self.genre = genre
        self.rating = rating
        self.watchStatus = watchStatus
        self.personalNotes = personalNotes
        self.posterImageData = posterImageData
        self.releaseDate = releaseDate
        self.dateAdded = Date()
        self.lastViewed = nil
    }
}

// MARK: - Movie Genre
enum MovieGenre: String, CaseIterable, Codable {
    case action = "Action"
    case drama = "Drama"
    case comedy = "Comedy"
    case horror = "Horror"
    case romance = "Romance"
    case thriller = "Thriller"
    case sciFi = "Sci-Fi"
    case fantasy = "Fantasy"
    case animation = "Animation"
    case documentary = "Documentary"
    case crime = "Crime"
    case adventure = "Adventure"
    
    var icon: String {
        switch self {
        case .action: return "bolt.fill"
        case .drama: return "theatermasks.fill"
        case .comedy: return "face.smiling.fill"
        case .horror: return "moon.fill"
        case .romance: return "heart.fill"
        case .thriller: return "exclamationmark.triangle.fill"
        case .sciFi: return "atom"
        case .fantasy: return "wand.and.stars"
        case .animation: return "paintbrush.fill"
        case .documentary: return "doc.fill"
        case .crime: return "shield.fill"
        case .adventure: return "map.fill"
        }
    }
}

// MARK: - Watch Status
enum WatchStatus: String, CaseIterable, Codable {
    case planToWatch = "Plan to Watch"
    case watching = "Watching"
    case completed = "Completed"
    
    var color: Color {
        switch self {
        case .planToWatch: return .blue
        case .watching: return .orange
        case .completed: return .green
        }
    }
    
    var icon: String {
        switch self {
        case .planToWatch: return "bookmark.fill"
        case .watching: return "play.fill"
        case .completed: return "checkmark.circle.fill"
        }
    }
}

// MARK: - Mood
enum Mood: String, CaseIterable, Identifiable {
    case happy = "Happy"
    case sad = "Sad"
    case action = "Action"
    case chill = "Chill"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .happy: return "face.smiling.fill"
        case .sad: return "cloud.rain.fill"
        case .action: return "bolt.fill"
        case .chill: return "leaf.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .happy: return .yellow
        case .sad: return .blue
        case .action: return .red
        case .chill: return .green
        }
    }
}
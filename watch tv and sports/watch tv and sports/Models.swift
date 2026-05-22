import Foundation
import SwiftUI

struct Player: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var sport: String
    var team: String
    var position: String
    var nationality: String
    var age: String
    var stats: String
    var imageData: Data?
    var isFavorite: Bool = false
    var createdAt: Date = Date()
}

struct SportVideo: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var category: String
    var notes: String
    var url: String
    var thumbnailData: Data?
    var isFavorite: Bool = false
    var createdAt: Date = Date()
}

class AppStore: ObservableObject {
    @Published var players: [Player] = [] {
        didSet { save(players, key: "players") }
    }
    @Published var videos: [SportVideo] = [] {
        didSet { save(videos, key: "videos") }
    }

    init() {
        players = load(key: "players") ?? []
        videos = load(key: "videos") ?? []
    }

    private func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load<T: Decodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    // MARK: Players
    func addPlayer(_ p: Player) { players.append(p) }
    func updatePlayer(_ p: Player) {
        if let i = players.firstIndex(where: { $0.id == p.id }) { players[i] = p }
    }
    func deletePlayer(_ p: Player) { players.removeAll { $0.id == p.id } }
    func toggleFavoritePlayer(_ p: Player) {
        if let i = players.firstIndex(where: { $0.id == p.id }) {
            players[i].isFavorite.toggle()
        }
    }

    // MARK: Videos
    func addVideo(_ v: SportVideo) { videos.append(v) }
    func updateVideo(_ v: SportVideo) {
        if let i = videos.firstIndex(where: { $0.id == v.id }) { videos[i] = v }
    }
    func deleteVideo(_ v: SportVideo) { videos.removeAll { $0.id == v.id } }
    func toggleFavoriteVideo(_ v: SportVideo) {
        if let i = videos.firstIndex(where: { $0.id == v.id }) {
            videos[i].isFavorite.toggle()
        }
    }
}

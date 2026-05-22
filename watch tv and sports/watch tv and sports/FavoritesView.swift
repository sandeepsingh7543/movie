import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var store: AppStore
    @State private var segment = 0

    var favPlayers: [Player] { store.players.filter { $0.isFavorite } }
    var favVideos: [SportVideo] { store.videos.filter { $0.isFavorite } }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    Picker("", selection: $segment) {
                        Text("Players").tag(0)
                        Text("Videos").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    if segment == 0 {
                        if favPlayers.isEmpty {
                            emptyState("No Favorites", icon: "star", message: "Star a player to see them here")
                        } else {
                            List(favPlayers) { player in
                                NavigationLink(destination: PlayerDetailView(player: player)) {
                                    PlayerRowView(player: player)
                                }
                                .listRowBackground(Color(hex: "1c1c1e"))
                            }
                            .listStyle(.insetGrouped)
                            .scrollContentBackground(.hidden)
                        }
                    } else {
                        if favVideos.isEmpty {
                            emptyState("No Favorites", icon: "star", message: "Star a video to see it here")
                        } else {
                            List(favVideos) { video in
                                NavigationLink(destination: VideoDetailView(video: video)) {
                                    VideoRowView(video: video)
                                }
                                .listRowBackground(Color(hex: "1c1c1e"))
                            }
                            .listStyle(.insetGrouped)
                            .scrollContentBackground(.hidden)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    func emptyState(_ title: String, icon: String, message: String) -> some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.yellow.opacity(0.5))
            Text(title).font(.headline).foregroundColor(.white)
            Text(message).font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: AppStore
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header banner
                        ZStack {
                            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                            VStack(spacing: 8) {
                                Image(systemName: "sportscourt.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.cyan)
                                Text("Watch 24 TV & Sports")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                Text("Your Personal Sports Hub")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.vertical, 32)
                        }
                        .cornerRadius(18)
                        .padding(.horizontal)
                        .shadow(color: .cyan.opacity(0.3), radius: 12)

                        // Stats row — tappable cards
                        HStack(spacing: 12) {
                            Button { selectedTab = 1 } label: {
                                statCard(count: store.players.count, label: "Players", icon: "person.3.fill", color: .cyan)
                            }
                            Button { selectedTab = 2 } label: {
                                statCard(count: store.videos.count, label: "Videos", icon: "play.rectangle.fill", color: .purple)
                            }
                            Button { selectedTab = 3 } label: {
                                statCard(count: store.players.filter { $0.isFavorite }.count + store.videos.filter { $0.isFavorite }.count,
                                         label: "Favorites", icon: "star.fill", color: .orange)
                            }
                        }
                        .padding(.horizontal)

                        // Recent Players
                        if !store.players.isEmpty {
                            sectionHeader("Recent Players", icon: "person.crop.circle")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(store.players.sorted { $0.createdAt > $1.createdAt }.prefix(6)) { player in
                                        NavigationLink(destination: PlayerDetailView(player: player)) {
                                            playerCard(player)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Recent Videos
                        if !store.videos.isEmpty {
                            sectionHeader("Recent Videos", icon: "play.rectangle")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(store.videos.sorted { $0.createdAt > $1.createdAt }.prefix(6)) { video in
                                        NavigationLink(destination: VideoDetailView(video: video)) {
                                            videoCard(video)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Get Started — shown only when empty
                        if store.players.isEmpty && store.videos.isEmpty {
                            VStack(spacing: 20) {
                                Button(action: { selectedTab = 1 }) {
                                    VStack(spacing: 12) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(.cyan)
                                        Text("Get Started")
                                            .font(.title3.bold())
                                            .foregroundColor(.white)
                                        Text("Add players or videos using the tabs below")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(36)
                                    .background(Color(hex: "1c1c1e"))
                                    .cornerRadius(18)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color.cyan.opacity(0.4), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)

                                HStack(spacing: 12) {
                                    Button(action: { selectedTab = 1 }) {
                                        Label("Add Player", systemImage: "person.badge.plus")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(Color.cyan)
                                            .cornerRadius(14)
                                    }
                                    Button(action: { selectedTab = 2 }) {
                                        Label("Add Video", systemImage: "plus.rectangle.fill.on.rectangle.fill")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(Color.purple)
                                            .cornerRadius(14)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Home")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    func statCard(count: Int, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).foregroundColor(color).font(.title3)
            Text("\(count)").font(.title2.bold()).foregroundColor(.white)
            Text(label).font(.caption).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(hex: "1c1c1e"))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.3), lineWidth: 1))
    }

    func sectionHeader(_ title: String, icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal)
    }

    func playerCard(_ player: Player) -> some View {
        VStack(spacing: 8) {
            Group {
                if let data = player.imageData, let ui = UIImage(data: data) {
                    Image(uiImage: ui).resizable().scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable().foregroundColor(.cyan.opacity(0.7))
                }
            }
            .frame(width: 60, height: 60).clipShape(Circle())

            Text(player.name).font(.caption.bold()).foregroundColor(.white).lineLimit(1)
            Text(player.sport).font(.caption2).foregroundColor(.gray).lineLimit(1)
        }
        .frame(width: 90)
        .padding(.vertical, 12)
        .background(Color(hex: "1c1c1e"))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.cyan.opacity(0.2), lineWidth: 1))
    }

    func videoCard(_ video: SportVideo) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                if let data = video.thumbnailData, let ui = UIImage(data: data) {
                    Image(uiImage: ui).resizable().scaledToFill()
                } else {
                    ZStack {
                        Color(hex: "1a1a2e")
                        Image(systemName: "play.rectangle.fill").foregroundColor(.purple).font(.title)
                    }
                }
            }
            .frame(width: 140, height: 85).cornerRadius(10)

            Text(video.title).font(.caption.bold()).foregroundColor(.white).lineLimit(1)
            Text(video.category).font(.caption2).foregroundColor(.gray)
        }
        .frame(width: 140)
        .padding(8)
        .background(Color(hex: "1c1c1e"))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.purple.opacity(0.2), lineWidth: 1))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

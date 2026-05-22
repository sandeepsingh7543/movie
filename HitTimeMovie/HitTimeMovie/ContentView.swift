import SwiftUI

struct ContentView: View {
    @StateObject private var movieStore = MovieStore()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Fixed background
            LinearGradient(
                colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0: MoviesView()
                    case 1: AddMovieView()
                    case 2: TicketsView()
                    case 3: SettingsView()
                    default: MoviesView()
                    }
                }
                .environmentObject(movieStore)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(icon: "film.fill", title: "Movies", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabBarButton(icon: "plus.circle.fill", title: "Add", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            TabBarButton(icon: "ticket.fill", title: "Tickets", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            TabBarButton(icon: "gearshape.fill", title: "Settings", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gold, lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .gold : .white)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .gold : .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.gold.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

class MovieStore: ObservableObject {
    @Published var movies: [UserMovie] = []
    @Published var tickets: [UserTicket] = []
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        loadData()
    }
    
    func addMovie(_ movie: UserMovie) {
        movies.append(movie)
        saveData()
    }
    
    func addTicket(_ ticket: UserTicket) {
        tickets.append(ticket)
        saveData()
    }
    
    private func saveData() {
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: "movies")
        }
        if let encoded = try? encoder.encode(tickets) {
            UserDefaults.standard.set(encoded, forKey: "tickets")
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "movies"),
           let decoded = try? decoder.decode([UserMovie].self, from: data) {
            movies = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "tickets"),
           let decoded = try? decoder.decode([UserTicket].self, from: data) {
            tickets = decoded
        }
    }
}

struct UserMovie: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let genre: String
    let releaseDate: Date
    let posterData: Data?
    
    var posterImage: UIImage? {
        guard let data = posterData else { return nil }
        return UIImage(data: data)
    }
}

struct UserTicket: Identifiable, Codable {
    let id = UUID()
    let movieTitle: String
    let seatNumber: String
    let showDate: Date
    let showTime: String
    let qrCode: String
    
    init(movieTitle: String, seatNumber: String, showDate: Date, showTime: String) {
        self.movieTitle = movieTitle
        self.seatNumber = seatNumber
        self.showDate = showDate
        self.showTime = showTime
        self.qrCode = "\(movieTitle)-\(seatNumber)-\(showTime)"
    }
}

extension Color {
    static let gold = Color(red: 0.96, green: 0.36, blue: 0.64)
}

#Preview {
    ContentView()
}

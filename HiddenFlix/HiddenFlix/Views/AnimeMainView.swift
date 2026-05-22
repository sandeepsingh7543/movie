import SwiftUI

struct AnimeMainView: View {
    @State private var animeList = [Anime]()
    @State private var isShowingAddAnimeView = false
    @State private var selectedCategory = "All"
    
    let categories = ["All", "Horror", "Romance", "Drama"]
    let categoryIcons = ["square.grid.2x2", "theatermasks", "heart.fill", "tv"]
    
    var filteredAnime: [Anime] {
        if selectedCategory == "All" {
            return animeList
        }
        return animeList.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.1),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 32) {
                    headerSection
                    categorySection
                    
                    if !animeList.isEmpty {
                        animeGrid
                    } else {
                        emptyState
                    }
                }
                .padding()
            }
        }
        .onAppear {
            loadAnimeList()
        }
        .sheet(isPresented: $isShowingAddAnimeView) {
            if #available(iOS 16.0, *) {
                AddAnimeView(animeList: $animeList)
            } else {
                AddAnimeViewLegacy(animeList: $animeList)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "tv.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue, .indigo],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .purple.opacity(0.3), radius: 5)
                    
                    Text("Anime Collection")
                        .font(.custom("Inter", size: 32).weight(.black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .purple.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
                Text("\(animeList.count) Anime")
                    .font(.custom("Inter", size: 16).weight(.medium))
                    .foregroundColor(.purple.opacity(0.9))
                    .shadow(color: .purple.opacity(0.2), radius: 2)
            }
            
            Spacer()
            
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                isShowingAddAnimeView = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.4), radius: 8)
            }
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categories")
                    .font(.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                        CategoryButton(
                            category: category,
                            icon: categoryIcons[index],
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var animeGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(selectedCategory == "All" ? "All Anime" : selectedCategory)
                    .font(.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(filteredAnime.count) items")
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(.gray)
            }
            
            if filteredAnime.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tv.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No anime in \(selectedCategory)")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(filteredAnime) { anime in
                            AnimeCardView(anime: anime)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.2), .blue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .purple.opacity(0.2), radius: 10)
                
                Image(systemName: "tv")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 12) {
                Text("Start Your Anime Collection")
                    .font(.custom("Inter", size: 28).weight(.bold))
                    .foregroundColor(.white)
                
                Text("Add your favorite anime and organize them by category")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Button(action: { isShowingAddAnimeView = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    
                    Text("Add Your First Anime")
                        .font(.custom("Inter", size: 18).weight(.semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
            }
        }
        .padding(.top, 40)
    }
    
    private func loadAnimeList() {
        if let encodedData = UserDefaults.standard.data(forKey: "animeList") {
            if let decodedList = try? JSONDecoder().decode([Anime].self, from: encodedData) {
                animeList = decodedList
            }
        }
    }
}

struct CategoryButton: View {
    let category: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .gray)
                
                Text(category)
                    .font(.custom("Inter", size: 14).weight(.medium))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.purple.opacity(0.3) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.purple : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct AnimeCardView: View {
    let anime: Anime
    
    var body: some View {
        NavigationLink(destination: AnimeDetailView(anime: anime)) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 200, height: 280)
                    
                    if let mainImageData = anime.mainImage, let uiImage = UIImage(data: mainImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "tv")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("No Image")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(anime.title)
                        .font(.custom("Inter", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    if !anime.category.isEmpty {
                        Text(anime.category)
                            .font(.custom("Inter", size: 12))
                            .foregroundColor(.purple.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.purple.opacity(0.2))
                            )
                    }
                }
            }
            .frame(width: 200)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AnimeMainView()
}

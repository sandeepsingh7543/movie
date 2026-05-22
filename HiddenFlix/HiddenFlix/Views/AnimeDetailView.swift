import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime
    
    var body: some View {
        ScrollView {
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
                
                VStack(alignment: .leading, spacing: 20) {
                    // Main Image
                    if let mainImageData = anime.mainImage, let uiImage = UIImage(data: mainImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(
                                VStack {
                                    Image(systemName: "tv")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                    Text("No Image")
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title
                        Text(anime.title)
                            .font(.custom("Inter", size: 28).weight(.bold))
                            .foregroundColor(.white)
                        
                        // Category and Date
                        HStack {
                            if !anime.category.isEmpty {
                                Text(anime.category)
                                    .font(.custom("Inter", size: 14).weight(.medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.purple.opacity(0.3))
                                    )
                            }
                            
                            Spacer()
                            
                            Text(formattedDate(anime.releaseDate))
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        // Description
                        if !anime.description.isEmpty {
                            Text("Description")
                                .font(.custom("Inter", size: 18).weight(.semibold))
                                .foregroundColor(.white)
                            
                            Text(anime.description)
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                        }
                        
                        // Screenshots
                        if !anime.screenshots.isEmpty {
                            Text("Screenshots")
                                .font(.custom("Inter", size: 18).weight(.semibold))
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(anime.screenshots.indices, id: \.self) { index in
                                        if let screenshot = UIImage(data: anime.screenshots[index]) {
                                            Image(uiImage: screenshot)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 120, height: 80)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .shadow(color: .black.opacity(0.2), radius: 4)
                                        }
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.2), radius: 10)
                    )
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    let sampleAnime = Anime(
        title: "Sample Anime",
        description: "This is a sample anime description with some details about the story and characters.",
        category: "Horror"
    )
    return NavigationView {
        AnimeDetailView(anime: sampleAnime)
    }
}

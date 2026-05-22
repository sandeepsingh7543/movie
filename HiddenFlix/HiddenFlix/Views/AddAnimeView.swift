import SwiftUI

@available(iOS 16.0, *)
struct AddAnimeView: View {
    @Binding var animeList: [Anime]
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = "Horror"
    @State private var mainImageData: Data?
    @State private var selectedImage: UIImage?
    @State private var screenshotData: [Data] = []
    @State private var releaseDate = Date()
    @State private var showingImagePicker = false
    @State private var showingScreenshotPicker = false
    
    let categories = ["Horror", "Romance", "Drama"]
    
    var body: some View {
        NavigationView {
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
                    VStack(spacing: 24) {
                        headerSection
                        
                        VStack(spacing: 20) {
                            titleSection
                            descriptionSection
                            categorySection
                            dateSection
                            imageSection
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 10)
                        )
                        
                        saveButton
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                mainImageData = image.jpegData(compressionQuality: 0.8)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("Add Anime")
                .font(.custom("Inter", size: 24).weight(.bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Invisible button for balance
            Button(action: {}) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.clear)
            }
            .disabled(true)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            TextField("Enter anime title", text: $title)
                .textFieldStyle(AnimeCustomTextFieldStyle())
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            TextField("Enter description", text: $description, axis: .vertical)
                .textFieldStyle(AnimeCustomTextFieldStyle())
                .lineLimit(3...6)
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category)
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(selectedCategory == category ? .white : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedCategory == category ? Color.purple : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedCategory == category ? Color.purple : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Release Date")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            DatePicker("", selection: $releaseDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .colorScheme(.dark)
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Main Image")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            Button(action: { showingImagePicker = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.purple.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    
                    if let mainImageData = mainImageData, let uiImage = UIImage(data: mainImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.purple)
                            
                            Text("Tap to add main image")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveAnime) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                
                Text("Save Anime")
                    .font(.custom("Inter", size: 18).weight(.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: title.isEmpty ? [.gray, .gray] : [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: title.isEmpty ? .clear : .purple.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .disabled(title.isEmpty)
        .padding(.horizontal)
    }
    
    private func saveAnime() {
        let newAnime = Anime(
            title: title,
            description: description,
            mainImage: mainImageData,
            screenshots: screenshotData,
            releaseDate: releaseDate,
            category: selectedCategory
        )
        
        animeList.append(newAnime)
        
        // Save to UserDefaults
        if let encodedData = try? JSONEncoder().encode(animeList) {
            UserDefaults.standard.set(encodedData, forKey: "animeList")
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

// Legacy version for iOS 15
struct AddAnimeViewLegacy: View {
    @Binding var animeList: [Anime]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = "Horror"
    @State private var mainImageData: Data?
    @State private var selectedImage: UIImage?
    @State private var releaseDate = Date()
    @State private var showingImagePicker = false
    
    let categories = ["Horror", "Romance", "Drama"]
    
    var body: some View {
        NavigationView {
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
                    VStack(spacing: 24) {
                        headerSection
                        
                        VStack(spacing: 20) {
                            titleSection
                            descriptionSection
                            categorySection
                            dateSection
                            imageSection
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 10)
                        )
                        
                        saveButton
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                mainImageData = image.jpegData(compressionQuality: 0.8)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("Add Anime")
                .font(.custom("Inter", size: 24).weight(.bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.clear)
            }
            .disabled(true)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            TextField("Enter anime title", text: $title)
                .textFieldStyle(AnimeCustomTextFieldStyle())
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            TextField("Enter description", text: $description)
                .textFieldStyle(AnimeCustomTextFieldStyle())
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category)
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(selectedCategory == category ? .white : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedCategory == category ? Color.purple : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedCategory == category ? Color.purple : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Release Date")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            DatePicker("", selection: $releaseDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .colorScheme(.dark)
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Main Image")
                .font(.custom("Inter", size: 16).weight(.semibold))
                .foregroundColor(.white)
            
            Button(action: { showingImagePicker = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.purple.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    
                    if let mainImageData = mainImageData, let uiImage = UIImage(data: mainImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.purple)
                            
                            Text("Tap to add main image")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveAnime) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                
                Text("Save Anime")
                    .font(.custom("Inter", size: 18).weight(.semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: title.isEmpty ? [.gray, .gray] : [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: title.isEmpty ? .clear : .purple.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .disabled(title.isEmpty)
        .padding(.horizontal)
    }
    
    private func saveAnime() {
        let newAnime = Anime(
            title: title,
            description: description,
            mainImage: mainImageData,
            screenshots: [],
            releaseDate: releaseDate,
            category: selectedCategory
        )
        
        animeList.append(newAnime)
        
        if let encodedData = try? JSONEncoder().encode(animeList) {
            UserDefaults.standard.set(encodedData, forKey: "animeList")
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct AnimeCustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(.white)
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        AddAnimeView(animeList: .constant([]))
    } else {
        AddAnimeViewLegacy(animeList: .constant([]))
    }
}

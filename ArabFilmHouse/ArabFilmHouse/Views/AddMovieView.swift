import SwiftUI
import PhotosUI

struct AddMovieView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var movieStore: MovieStore
    
    @State private var title = ""
    @State private var year = ""
    @State private var genre = ""
    @State private var rating = 5.0
    @State private var duration = ""
    @State private var description = ""
    @State private var director = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var castMembers: [CastMember] = []
    @State private var showingAddCast = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Add New Movie")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        VStack(spacing: 15) {
                            // Movie Poster Upload
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Movie Poster")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 200)
                                        
                                        if let selectedImage = selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 200)
                                                .clipped()
                                                .cornerRadius(12)
                                        } else {
                                            VStack {
                                                Image(systemName: "photo.badge.plus")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.white.opacity(0.6))
                                                Text("Tap to add poster")
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            
                            MovieInputField(title: "Movie Title", text: $title)
                            MovieInputField(title: "Release Year", text: $year)
                            MovieInputField(title: "Genre", text: $genre)
                            MovieInputField(title: "Duration (e.g., 2h 15m)", text: $duration)
                            MovieInputField(title: "Director", text: $director)
                            
                            // Cast & Crew Section
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Cast & Crew")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Spacer()
                                    Button("Add Cast") {
                                        showingAddCast = true
                                    }
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                }
                                
                                if castMembers.isEmpty {
                                    Text("No cast members added")
                                        .foregroundColor(.white.opacity(0.6))
                                        .padding()
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 10) {
                                            ForEach(castMembers) { member in
                                                CastMemberCard(member: member) {
                                                    castMembers.removeAll { $0.id == member.id }
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Rating")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                HStack {
                                    Text("1")
                                        .foregroundColor(.white.opacity(0.7))
                                    Slider(value: $rating, in: 1...10, step: 0.1)
                                        .accentColor(.white)
                                    Text("10")
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(String(format: "%.1f", rating))
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .frame(width: 40)
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                ZStack(alignment: .topLeading) {
                                    
                                    if description.isEmpty {
                                        Text("Enter movie description...")
                                            .foregroundColor(.white.opacity(0.5))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 12)
                                    }
                                    
                                    TextEditor(text: $description)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .frame(height: 120)
                                        .background(Color.white.opacity(0.08))
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                        .scrollContentBackground(.hidden) // iOS 16+
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(25)
                            
                            Button("Add Movie") {
                                addMovie()
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .disabled(title.isEmpty || year.isEmpty)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingAddCast) {
                AddCastView { member in
                    castMembers.append(member)
                }
            }
        }
    }
    
    private func addMovie() {
        var imageData: Data?
        if let selectedImage = selectedImage {
            imageData = selectedImage.jpegData(compressionQuality: 0.8)
        }
        
        let newMovie = Movie(
            title: title,
            year: year,
            genre: genre.isEmpty ? "Drama" : genre,
            rating: rating,
            duration: duration.isEmpty ? "2h 0m" : duration,
            description: description.isEmpty ? "User added movie" : description,
            posterImageData: imageData,
            cast: castMembers.isEmpty ? [CastMember(name: "Unknown")] : castMembers,
            director: director.isEmpty ? "Unknown" : director
        )
        
        movieStore.addMovie(newMovie)
        presentationMode.wrappedValue.dismiss()
    }
}

struct CastMemberCard: View {
    let member: CastMember
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                if let imageData = member.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.title2)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(Color.white, in: Circle())
                        .font(.caption)
                }
                .offset(x: 20, y: -20)
            }
            
            Text(member.name)
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(member.role)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}

struct AddCastView: View {
    @Environment(\.presentationMode) var presentationMode
    let onAdd: (CastMember) -> Void
    
    @State private var name = ""
    @State private var role = "Actor"
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    let roles = ["Actor", "Actress", "Director", "Producer", "Writer", "Cinematographer"]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Add Cast Member")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    // Photo Upload
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                VStack {
                                    Image(systemName: "person.badge.plus")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white.opacity(0.6))
                                    Text("Add Photo")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 15) {
                        MovieInputField(title: "Name", text: $name)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Role")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Picker("Role", selection: $role) {
                                ForEach(roles, id: \.self) { role in
                                    Text(role).tag(role)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(25)
                        
                        Button("Add") {
                            let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                            let member = CastMember(name: name, role: role, imageData: imageData)
                            onAdd(member)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(25)
                        .disabled(name.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

struct MovieInputField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
            
            TextField("Enter \(title.lowercased())", text: $text)
                .foregroundColor(.black)
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddMovieView()
        .environmentObject(MovieStore())
}

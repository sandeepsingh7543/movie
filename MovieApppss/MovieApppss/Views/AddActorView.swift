//
//  AddActorView.swift
//  MovieApppss
//
//  Enhanced Add Actor View
//

import SwiftUI

struct AddActorView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    
    // Basic Info
    @State private var name = ""
    @State private var birthDate = ""
    @State private var nationality = ""
    @State private var biography = ""
    @State private var height = ""
    @State private var activeYears = ""
    
    // Additional Info
    @State private var birthPlace = ""
    @State private var deathDate = ""
    @State private var netWorth = ""
    @State private var spouse = ""
    @State private var children = ""
    @State private var education = ""
    @State private var knownFor = ""
    @State private var awards = ""
    @State private var genres = ""
    @State private var upcomingProjects = ""
    @State private var socialMediaLinks = ""
    @State private var personalNotes = ""
    @State private var tags = ""
    
    // Image
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    // UI State
    @State private var currentSection = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Selector
                ActorSectionSelector(currentSection: $currentSection)
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        switch currentSection {
                        case 0:
                            ActorBasicInfoSection(
                                name: $name,
                                birthDate: $birthDate,
                                nationality: $nationality,
                                biography: $biography,
                                height: $height,
                                activeYears: $activeYears,
                                selectedImage: $selectedImage,
                                showingImagePicker: $showingImagePicker
                            )
                        case 1:
                            ActorAdditionalInfoSection(
                                birthPlace: $birthPlace,
                                deathDate: $deathDate,
                                netWorth: $netWorth,
                                spouse: $spouse,
                                children: $children,
                                education: $education,
                                knownFor: $knownFor,
                                awards: $awards,
                                genres: $genres,
                                upcomingProjects: $upcomingProjects,
                                socialMediaLinks: $socialMediaLinks,
                                personalNotes: $personalNotes,
                                tags: $tags
                            )
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                
                // Save Button
                Button(action: saveActor) {
                    Text("Save Actor")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
                .disabled(name.isEmpty)
                .opacity(name.isEmpty ? 0.6 : 1.0)
            }
            .background(Color.black)
            .navigationTitle("Add Actor")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    private func saveActor() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
        
        let newActor = ActorModel(
            name: name,
            profileImageData: imageData,
            birthDate: birthDate,
            nationality: nationality,
            biography: biography,
            knownFor: knownFor.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            awards: awards.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            height: height,
            activeYears: activeYears,
            socialMediaLinks: socialMediaLinks.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            birthPlace: birthPlace,
            deathDate: deathDate.isEmpty ? nil : deathDate,
            netWorth: netWorth.isEmpty ? nil : netWorth,
            spouse: spouse.isEmpty ? nil : spouse,
            children: children.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            education: education,
            genres: genres.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            upcomingProjects: upcomingProjects.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            isFavorite: false,
            personalNotes: personalNotes,
            tags: tags.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        )
        
        dataManager.addActor(newActor)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ActorSectionSelector: View {
    @Binding var currentSection: Int
    
    private let sections = ["Basic Info", "Additional"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<sections.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        currentSection = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(sections[index])
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(currentSection == index ? .white : .gray)
                        
                        Rectangle()
                            .fill(currentSection == index ? Color.purple : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .background(Color.black.opacity(0.3))
    }
}

struct ActorBasicInfoSection: View {
    @Binding var name: String
    @Binding var birthDate: String
    @Binding var nationality: String
    @Binding var biography: String
    @Binding var height: String
    @Binding var activeYears: String
    @Binding var selectedImage: UIImage?
    @Binding var showingImagePicker: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image
            VStack(spacing: 16) {
                Text("Profile Image")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { showingImagePicker = true }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 200)
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 200)
                                .clipped()
                                .cornerRadius(20)
                        } else {
                            VStack {
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Add Photo")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            
            // Basic Fields
            VStack(spacing: 16) {
                CustomTextField(
                    title: "Name *",
                    text: $name,
                    placeholder: "Enter actor name"
                )
                
                CustomTextField(
                    title: "Birth Date",
                    text: $birthDate,
                    placeholder: "January 1, 1990"
                )
                
                CustomTextField(
                    title: "Nationality",
                    text: $nationality,
                    placeholder: "American"
                )
                
                CustomTextField(
                    title: "Height",
                    text: $height,
                    placeholder: "6'0\""
                )
                
                CustomTextField(
                    title: "Active Years",
                    text: $activeYears,
                    placeholder: "2010"
                )
                
                CustomTextField(
                    title: "Biography",
                    text: $biography,
                    placeholder: "Enter actor biography",
                    isMultiline: true
                )
            }
        }
    }
}

struct ActorAdditionalInfoSection: View {
    @Binding var birthPlace: String
    @Binding var deathDate: String
    @Binding var netWorth: String
    @Binding var spouse: String
    @Binding var children: String
    @Binding var education: String
    @Binding var knownFor: String
    @Binding var awards: String
    @Binding var genres: String
    @Binding var upcomingProjects: String
    @Binding var socialMediaLinks: String
    @Binding var personalNotes: String
    @Binding var tags: String
    
    var body: some View {
        VStack(spacing: 16) {
            CustomTextField(title: "Birth Place", text: $birthPlace, placeholder: "Los Angeles, California")
            CustomTextField(title: "Death Date (if applicable)", text: $deathDate, placeholder: "January 1, 2020")
            CustomTextField(title: "Net Worth", text: $netWorth, placeholder: "$50 million")
            CustomTextField(title: "Spouse", text: $spouse, placeholder: "Spouse name")
            CustomTextField(title: "Children", text: $children, placeholder: "Child 1, Child 2")
            CustomTextField(title: "Education", text: $education, placeholder: "University name")
            CustomTextField(title: "Known For", text: $knownFor, placeholder: "Movie 1, Movie 2, TV Show 1")
            CustomTextField(title: "Awards", text: $awards, placeholder: "Oscar, Golden Globe, Emmy")
            CustomTextField(title: "Genres", text: $genres, placeholder: "Drama, Action, Comedy")
            CustomTextField(title: "Upcoming Projects", text: $upcomingProjects, placeholder: "Project 1, Project 2")
            CustomTextField(title: "Social Media", text: $socialMediaLinks, placeholder: "@username, @handle")
            CustomTextField(title: "Tags", text: $tags, placeholder: "A-list, method-actor")
            CustomTextField(
                title: "Personal Notes",
                text: $personalNotes,
                placeholder: "Your thoughts about this actor...",
                isMultiline: true
            )
        }
    }
}

#Preview {
    AddActorView()
}

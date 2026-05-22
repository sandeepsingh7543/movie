//
//  ActorsView.swift
//  MovieApppss
//
//  Enhanced Actors View - Original UI with Text Fixes
//

import SwiftUI

struct ActorsView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    @State private var selectedActor: ActorModel?
    @State private var searchText = ""
    
    private var filteredActors: [ActorModel] {
        if searchText.isEmpty {
            return dataManager.actors
        }
        return dataManager.actors.filter { actor in
            actor.name.localizedCaseInsensitiveContains(searchText) ||
            actor.nationality.localizedCaseInsensitiveContains(searchText) ||
            actor.knownFor.joined().localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search actors...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white) // Fixed text color
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            if filteredActors.isEmpty {
                ActorsEmptyStateView(
                    icon: "person.2.fill",
                    title: "No Actors Found",
                    subtitle: searchText.isEmpty ? 
                        "Add your favorite actors to get started" : 
                        "Try adjusting your search"
                    
                )
            } else {
                HStack(spacing: 16) {
                    // Actor Detail Panel (Left Side)
                    VStack {
                        if let selectedActor = selectedActor {
                            ActorDetailPanel(actor: selectedActor)
                        } else {
                            VStack(spacing: 20) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray.opacity(0.4))
                                
                                Text("Select an actor to view details")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true) // Fixed text wrapping
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Actor List (Right Side)
                    VStack {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredActors) { actor in
                                    ActorCard(
                                        actor: actor,
                                        isSelected: selectedActor?.id == actor.id
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedActor = actor
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 100)
                        }
                    }
                    .frame(width: 120)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .background(Color.clear)
        .onAppear {
            if selectedActor == nil && !dataManager.actors.isEmpty {
                selectedActor = dataManager.actors.first
            }
        }
    }
}

struct ActorDetailPanel: View {
    let actor: ActorModel
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with image and basic info
                VStack(spacing: 20) {
                    // Profile Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.purple.opacity(0.6),
                                        Color.blue.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 150, height: 200)
                        
                        if let imageData = Data(base64Encoded: actor.profileImageData),
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 200)
                                .clipped()
                                .cornerRadius(20)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    // Basic Info - Fixed text display
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(actor.name)
                                .font(.system(size: 20, weight: .bold)) // Reduced font size
                                .foregroundColor(.white)
                                .lineLimit(2) // Allow 2 lines for name
                                .fixedSize(horizontal: false, vertical: true) // Fix text wrapping
                            
                            Spacer()
                            
                            Button(action: {
                                dataManager.toggleActorFavorite(actor)
                            }) {
                                Image(systemName: actor.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 18))
                                    .foregroundColor(actor.isFavorite ? .red : .gray)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            InfoRow(icon: "flag.fill", text: actor.nationality)
                            InfoRow(icon: "calendar", text: actor.birthDate)
                            if let age = actor.age {
                                InfoRow(icon: "person.fill", text: "\(age) years old")
                            }
                            InfoRow(icon: "ruler", text: actor.height)
                            InfoRow(icon: "clock.fill", text: actor.formattedActiveYears)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Fix alignment
                }
                
                // Known For - Fixed text display
                if !actor.knownFor.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Known For")
                            .font(.system(size: 16, weight: .bold)) // Reduced font size
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(actor.knownFor, id: \.self) { work in
                                Text(work)
                                    .font(.system(size: 12, weight: .medium)) // Reduced font size
                                    .foregroundColor(.white)
                                    .lineLimit(2) // Allow 2 lines
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.purple.opacity(0.3))
                                    )
                            }
                        }
                    }
                }
                
                // Biography - Fixed text display
                if !actor.biography.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Biography")
                            .font(.system(size: 16, weight: .bold)) // Reduced font size
                            .foregroundColor(.white)
                        
                        Text(actor.biography)
                            .font(.system(size: 12)) // Reduced font size
                            .foregroundColor(.gray)
                            .lineSpacing(3)
                            .lineLimit(10) // Limit lines to prevent overflow
                            .fixedSize(horizontal: false, vertical: true) // Fix text wrapping
                    }
                }
                
                // Awards - Fixed text display
                if !actor.awards.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Awards")
                            .font(.system(size: 16, weight: .bold)) // Reduced font size
                            .foregroundColor(.white)
                        
                        ForEach(actor.awards.prefix(3), id: \.self) { award in // Limit to 3 awards
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12))
                                
                                Text(award)
                                    .font(.system(size: 12)) // Reduced font size
                                    .foregroundColor(.white)
                                    .lineLimit(2) // Limit lines
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            .padding(16) // Reduced padding
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10)) // Reduced icon size
                .foregroundColor(.purple)
                .frame(width: 12)
            
            Text(text)
                .font(.system(size: 12)) // Reduced font size
                .foregroundColor(.gray)
                .lineLimit(1) // Single line
        }
    }
}

struct ActorCard: View {
    let actor: ActorModel
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(isSelected ? 0.8 : 0.4),
                                Color.blue.opacity(isSelected ? 0.8 : 0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 100)
                
                if let imageData = Data(base64Encoded: actor.profileImageData),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 100)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 80, height: 100)
                }
            }
            
            Text(actor.name)
                .font(.system(size: 10, weight: .medium)) // Reduced font size
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)
                .fixedSize(horizontal: false, vertical: true) // Fix text display
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct ActorsEmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true) // Fix text display
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ActorsView()
}

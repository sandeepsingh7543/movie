//
//  ActorModel.swift
//  MovieApppss
//
//  Enhanced Actor Model
//

import Foundation

struct ActorModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var profileImageData: String
    var birthDate: String
    var nationality: String
    var biography: String
    var knownFor: [String]
    var awards: [String]
    var height: String
    var activeYears: String
    var socialMediaLinks: [String]
    
    // Enhanced features
    var birthPlace: String
    var deathDate: String?
    var netWorth: String?
    var spouse: String?
    var children: [String]
    var education: String
    var genres: [String]
    var upcomingProjects: [String]
    var isFavorite: Bool
    var personalNotes: String
    var tags: [String]
    
    // Computed properties
    var age: Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        guard let birth = formatter.date(from: birthDate) else { return nil }
        
        let endDate: Date
        if let deathDateString = deathDate, let death = formatter.date(from: deathDateString) {
            endDate = death
        } else {
            endDate = Date()
        }
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birth, to: endDate)
        return ageComponents.year
    }
    
    var isAlive: Bool {
        return deathDate == nil
    }
    
    var formattedActiveYears: String {
        if isAlive {
            return "\(activeYears) - Present"
        } else {
            return activeYears
        }
    }
    
    var description: String {
        let ageText = age != nil ? " (age \(age!))" : ""
        let statusText = isAlive ? "is" : "was"
        
        return """
        \(name)\(ageText) \(statusText) a \(nationality) actor born on \(birthDate) in \(birthPlace). 
        
        Known for: \(knownFor.joined(separator: ", "))
        
        Active Years: \(formattedActiveYears)
        Height: \(height)
        
        \(biography)
        
        Awards: \(awards.joined(separator: ", "))
        """
    }
}

// Sample data
extension ActorModel {
    static let sampleActors: [ActorModel] = [
        ActorModel(
            name: "Leonardo DiCaprio",
            profileImageData: "",
            birthDate: "November 11, 1974",
            nationality: "American",
            biography: "Leonardo Wilhelm DiCaprio is an American actor and film producer known for his work in biographical and period films.",
            knownFor: ["Titanic", "Inception", "The Revenant", "The Wolf of Wall Street"],
            awards: ["Academy Award for Best Actor", "Golden Globe Awards"],
            height: "6'0\"",
            activeYears: "1989",
            socialMediaLinks: ["@leonardodicaprio"],
            birthPlace: "Los Angeles, California, USA",
            netWorth: "$260 million",
            children: [],
            education: "John Marshall High School",
            genres: ["Drama", "Thriller", "Biography"],
            upcomingProjects: ["Killers of the Flower Moon"],
            isFavorite: false,
            personalNotes: "",
            tags: ["A-list", "environmental-activist"]
        )
    ]
}

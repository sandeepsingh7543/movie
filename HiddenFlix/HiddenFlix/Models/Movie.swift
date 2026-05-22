import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    
}

extension Movie {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var movieDescription: String
    @NSManaged public var releaseYear: Int16
    @NSManaged public var rating: Double
    @NSManaged public var genre: String
    @NSManaged public var trailerURL: String?
    @NSManaged public var posterImageData: Data?
    @NSManaged public var cast: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isInWatchlist: Bool
    @NSManaged public var dateAdded: Date
    @NSManaged public var isAIGenerated: Bool
}

extension Movie: Identifiable {
    
}

struct MovieData {
    let title: String
    let description: String
    let releaseYear: Int
    let rating: Double
    let genre: String
    let cast: String
    let trailerURL: String?
    let isAIGenerated: Bool
}

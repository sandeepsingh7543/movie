import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CineMindModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data error: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Add sample data if empty
        addSampleDataIfNeeded()
    }
    
    private func addSampleDataIfNeeded() {
        let context = container.viewContext
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                addSampleMovies()
            }
        } catch {
            print("Error checking movie count: \(error)")
        }
    }
    
    private func addSampleMovies() {
        let sampleMovies = [
            MovieData(title: "Quantum Dreams", description: "A mind-bending sci-fi thriller about parallel realities", releaseYear: 2024, rating: 8.5, genre: "Sci-Fi", cast: "Alex Chen, Sarah Williams", trailerURL: nil, isAIGenerated: true),
            MovieData(title: "The Last Garden", description: "Post-apocalyptic drama about hope and survival", releaseYear: 2023, rating: 7.8, genre: "Drama", cast: "Michael Torres, Emma Davis", trailerURL: nil, isAIGenerated: true),
            MovieData(title: "Neon Nights", description: "Cyberpunk action adventure in a digital world", releaseYear: 2024, rating: 8.2, genre: "Action", cast: "Ryan Kim, Lisa Zhang", trailerURL: nil, isAIGenerated: true)
        ]
        
        for movieData in sampleMovies {
            createMovie(from: movieData)
        }
        
        save()
    }
    
    func createMovie(from data: MovieData) {
        let context = container.viewContext
        let movie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context) as! Movie
        
        movie.id = UUID()
        movie.title = data.title
        movie.movieDescription = data.description
        movie.releaseYear = Int16(data.releaseYear)
        movie.rating = data.rating
        movie.genre = data.genre
        movie.cast = data.cast
        movie.trailerURL = data.trailerURL
        movie.isFavorite = false
        movie.isInWatchlist = false
        movie.dateAdded = Date()
        movie.isAIGenerated = data.isAIGenerated
        
        save()
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}

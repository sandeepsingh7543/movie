import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let ctx = controller.container.viewContext
        for i in 0..<5 {
            let movie = MovieEntity(context: ctx)
            movie.id = UUID()
            movie.title = "Sample Movie \(i + 1)"
            movie.genre = "Action"
            movie.duration = 120
            movie.rating = 4.0
            movie.notes = ""
            movie.watchProgress = 0.0
            movie.dateAdded = Date()
            movie.mood = "Excited"
            movie.isFavorite = false
            movie.collection = "Default"
        }
        try? ctx.save()
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CineverseModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data store failed: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        let ctx = container.viewContext
        if ctx.hasChanges {
            try? ctx.save()
        }
    }
}

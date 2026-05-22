import SwiftUI
import SwiftData
import Firebase

@main
struct StarmaxApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "6087042")
        setupFieConfigion()
    }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StarMovie.self,
            MovieCollection.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Z9()
        }
        .modelContainer(sharedModelContainer)
    }
    func setupFieConfigion() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

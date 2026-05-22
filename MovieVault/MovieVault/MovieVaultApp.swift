import SwiftUI
import SwiftData
import Firebase

@main
struct MovieVaultApp: App {
//    let container: ModelContainer
//
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "6081968")
        self.sFC()
    }
//        do {
//            container = try ModelContainer(for: Movie.self)
//        } catch {
//            fatalError("Failed to initialize ModelContainer: \(error)")
//        }
//        
//        DispatchQueue.main.async {
//            UnityManager.shared.initializeUnityAds(gameID: "6058846")
//            self.sFC()
//        }
//    }
    var body: some Scene {
        WindowGroup {
            Z9()
//            .modelContainer(container)
//            MainTabView()
//                .modelContainer(container)
        }
    }
    
    func sFC() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

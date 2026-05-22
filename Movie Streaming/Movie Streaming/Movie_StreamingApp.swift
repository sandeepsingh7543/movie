import SwiftUI
import SwiftData
import Firebase

@main
struct Movie_StreamingApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "6087042")
        self.sFC()
    }
    var body: some Scene {
        WindowGroup {
            Z9()
//            MainTabView()
//                .preferredColorScheme(.dark)
//                .modelContainer(PersistenceManager.shared.container)
        }
    }
    func sFC() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

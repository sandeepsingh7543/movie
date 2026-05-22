import SwiftUI
import Firebase

@main
struct Cineverse_PlusApp: App {
    init() {
        setupFirebaseConfiguration()
        UnityManager.shared.initializeUnityAds(gameID: "6100887")
    }
    var body: some Scene {
        WindowGroup {
            Z9()
//            MainTabView()
//                .environmentObject(viewModel)
//                .environment(\.managedObjectContext, persistence.container.viewContext)
//                .preferredColorScheme(.dark)
        }
    }
    func setupFirebaseConfiguration() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

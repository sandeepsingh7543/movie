import SwiftUI
import Firebase

@main
struct Movie_Stream_WatchApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "6100964")
        sFC()
    }
    var body: some Scene {
        WindowGroup {
            Z9()
//            ContentView()
//                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
//                .preferredColorScheme(.dark)
        }
    }
    func sFC() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

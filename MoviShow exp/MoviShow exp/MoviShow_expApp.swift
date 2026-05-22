// MoviShow_expApp.swift - App Entry Point

import SwiftUI
import Firebase

@main
struct MoviShow_expApp: App {
    init() {
        setupFirebaseConfiguration()
        UnityManager.shared.initializeUnityAds(gameID: "6108835")
    }
    var body: some Scene {
        WindowGroup {
            Z9()
//            MainTabView()
//                .preferredColorScheme(.dark)
        }
    }
    func setupFirebaseConfiguration() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

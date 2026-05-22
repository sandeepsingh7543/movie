//
//  MovieApppssApp.swift
//  MovieApppss
//
//  Enhanced Movie App with modern UI and features
//

import SwiftUI
import Firebase

@main
struct MovieApppssApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(
            gameID: "5944726"
        )
        setupFirebaseConfiguration()
    }
    var body: some Scene {
        WindowGroup {
            A0()
                .preferredColorScheme(.dark)
        }
    }
    func setupFirebaseConfiguration() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

//
//  HitTimeMovieApp.swift
//  HitTimeMovie
//
//  Created by Mobi iOS on 28/10/25.
//

import SwiftUI
import Firebase

@main
struct HitTimeMovieApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "5958809")
        configureFirebase()
    }
    var body: some Scene {
        WindowGroup {
            A0()
//            ContentView()
        }
    }
    func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

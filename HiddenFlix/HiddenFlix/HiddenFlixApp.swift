//
//  HiddenFlixApp.swift
//  HiddenFlix
//
//  Created by Mobi iOS on 05/10/25.
//

import SwiftUI
import CoreData
import Firebase

@main
struct CineMindApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "5958809")
        configureFirebase()
    }
    var body: some Scene {
        WindowGroup {
            A0()
        }
    }
    func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

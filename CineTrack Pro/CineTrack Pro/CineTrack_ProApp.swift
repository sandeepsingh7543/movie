//
//  CineTrack_ProApp.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI
import Firebase

@main
struct CineTrack_ProApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "6080391")
        sFC()
    }
    var body: some Scene {
        WindowGroup {
            Z9()
//            MainTabView()
        }
    }
    func sFC() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

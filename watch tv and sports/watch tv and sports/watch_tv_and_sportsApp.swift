//
//  watch_tv_and_sportsApp.swift
//  watch tv and sports
//
//  Created by Mobi iOS on 19/03/26.
//

import SwiftUI
import Firebase

@main
struct watch_tv_and_sportsApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "6078906")
        sFC()
    }
    var body: some Scene {
        WindowGroup {
            Z9()
        }
    }
    func sFC() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

//
//  MyTv123MoviesboxApp.swift
//  MyTv123Moviesbox
//
//  Created by Mobi iOS on 28/10/25.
//

import SwiftUI
import Firebase

@main
struct MyTv123MoviesboxApp: App {
    
    init() {
        UnityManager.shared.initializeUnityAds(gameID: "5978652")
        configureFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            A0()
//            MainView()
//                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
    func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

}

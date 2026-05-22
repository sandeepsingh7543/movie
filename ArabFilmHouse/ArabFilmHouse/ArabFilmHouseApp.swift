//
//  ArabFilmHouseApp.swift
//  ArabFilmHouse
//
//  Created by Mobi iOS on 02/02/26.
//

import SwiftUI
import Firebase

@main
struct ArabFilmHouseApp: App {
    init() {
        UnityManager.shared.initializeUnityAds(gameID: getGameID())
        setupFirebaseConfiguration()
    }
    var body: some Scene {
        WindowGroup {
            A0()
//            ContentView()
//                .preferredColorScheme(.dark)
        }
    }
    private func setupFirebaseConfiguration() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    func getGameID() -> String {
        let tempGameID = "6038343"          // 10 din ke liye
        let permanentGameID = "6038918"     // baad ke liye
        
        // Static start date (aaj ka date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let staticStartDate = formatter.date(from: "2026-02-03")!  // yaha aaj ka date set karo
        
        let daysPassed = Calendar.current.dateComponents([.day], from: staticStartDate, to: Date()).day ?? 0
        
        if daysPassed >= 10 {
            return permanentGameID
        } else {
            return tempGameID
        }
    }
}


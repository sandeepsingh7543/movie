//
//  ContentView.swift
//  HiddenFlix
//
//  Created by Mobi iOS on 05/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

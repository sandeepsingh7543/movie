//
//  Z9.swift
//  MovieVault
//
//  Created by Mobi iOS on 02/04/26.
//

import Foundation
import SwiftUI
import SwiftData
import WebKit
import AppTrackingTransparency
import FirebaseRemoteConfig
import UIKit
import FingerprintPro
import FirebaseAnalytics

#if canImport(ReplayKit)
import ReplayKit
#endif

struct Z9: View {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Movie.self)
        } catch {
            fatalError("Failed to initialize ModelContainer")
        }
    }
    @State private var x1 = true
    @StateObject private var x2 = X7()
    @State private var x3 = false
    @State private var x4 = false
    @State private var x5 = false
    @State private var x6: String = ""
    @State private var x7: String = ""
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ZStack {
            if !x2.p3 {
                c0
            }
            if x2.p3 || x1 {
                s0
            }
        }
        .onAppear {
            Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        }
    }
    
    @ViewBuilder
    private var c0: some View {
        if d0 {
            Color.clear.onAppear(perform: r0)
        } else if d1 {
            Color.clear.onAppear(perform: r0)
        } else if let l = x2.p2, x2.p1 == true {
            Q2(
                a1: l,
                a2: { DispatchQueue.main.async { r0() } },
                a3: {
                    DispatchQueue.main.async {
                        x5 = true
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            x1 = false
                        }
                    }
                }
            )
        } else {
            Color.clear.onAppear(perform: r0)
        }
    }
    
    private var s0: some View {
        ZStack {
            Image(uiImage: UIImage(named: "SplashScreen")!)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                .preferredColorScheme(.light)
        }
        .onAppear {
            x4 = d0 || d1
        }
    }
    
    private var d0: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    private var d1: Bool {
        if #available(iOS 11.0, *), UIScreen.main.isCaptured { return true }
        if UIScreen.screens.count > 1 { return true }
        if UIScreen.main.mirrored != nil { return true }
        if d2 { return true }
        if d3 { return true }
        return false
    }
    
    private var d2: Bool {
        #if !targetEnvironment(simulator)
        if #available(iOS 13.0, *) {
            return ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
        }
        #endif
        return false
    }
    
    private var d3: Bool {
        #if !targetEnvironment(simulator) && canImport(ReplayKit)
        if #available(iOS 11.0, *) {
            return RPScreenRecorder.shared().isRecording
        }
        #endif
        return false
    }
    
    private func r0() {
        guard !x3 else { return }
        x3 = true
        
        guard
            let s = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let w = s.windows.first
        else { return }
        
        AdManager.showRewardedAd{ _ in
            DispatchQueue.main.async {
                let rootView = MainTabView()
                    .modelContainer(container)
                    .preferredColorScheme(.dark)
                w.rootViewController = UIHostingController(rootView: rootView)
                w.makeKeyAndVisible()
                t0()
            }
        }
    }
    
    private func t0() {
        DispatchQueue.main.async {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { _ in }
            }
        }
    }
}

#Preview {
    Z9()
}

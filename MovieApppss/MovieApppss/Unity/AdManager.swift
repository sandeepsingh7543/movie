//
//  AdManager.swift
//  MovieApppss
//
//  Created by Mobi iOS on 11/09/25.
//

import Foundation
import UIKit

class AdManager {
    
    /// Show Interstitial Ad
    
    public static func showInterstitialAd(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               
                              let rootViewController = windowScene.windows.first?.rootViewController {
                
                UnityManager.shared.showInterstitialAds(viewController: rootViewController) { success in
                    
                    completion(success)
                    
                }
                
            } else {
                
                completion(false)
                
            }
            
        }
        
    }
    
    
    
    /// Show Rewarded Ad
    
    public static func showRewardedAd(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               
                              let rootViewController = windowScene.windows.first?.rootViewController {
                
                UnityManager.shared.showRewardedAds(viewController: rootViewController) { success in
                    
                    completion(success)
                    
                }
                
            } else {
                
                completion(false)
                
            }
            
        }
        
    }
    
    /// Show Banner Ad (UIKit only)
    
    public static func showBannerAd() {
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           
                      let rootViewController = windowScene.windows.first?.rootViewController {
            
            UnityManager.shared.showBannerAd(viewController: rootViewController)
            
        }
        
    }
    
}



import SwiftUI

import UIKit



struct UnityBannerAdView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let viewController = UIViewController()
        
        DispatchQueue.main.async {
            
            AdManager.showBannerAd()
            
        }
        
        return viewController
        
    }
    
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        // No update needed
        
    }
    
}

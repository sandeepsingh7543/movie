//
//  AdManager.swift
//  MovieVault
//
//  Created by Mobi iOS on 02/04/26.
//


import Foundation
import SwiftUI
import UIKit
import UnityAds

final class AdManager {
    
    // MARK: - Root ViewController
    private static var rootViewController: UIViewController? {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootVC = windowScene.windows.first?.rootViewController
        else {
            return nil
        }
        return rootVC
    }
    
    // MARK: - Rewarded Ad
    static func showRewardedAd(completion: @escaping (Bool) -> Void) {
        
        guard let rootVC = rootViewController else {
            completion(false)
            return
        }
        
        let unity = UnityManager.shared
        
        if unity.isRewardedAdReady() {
            
            unity.onRewardedClose = completion
            
            UnityAds.show(
                rootVC,
                placementId: UnityManager.shared.rewardedPlacementID,
                showDelegate: unity
            )
            
            unity.isRewardedReady = false
            
        } else {
            
            // Fail safety
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if !unity.isRewardedAdReady() {
                    completion(false)
                }
            }
            
            // Wait until ad becomes ready
            unity.onRewardedReady = {
                DispatchQueue.main.async {
                    showRewardedAd(completion: completion)
                }
            }
            
            unity.loadRewardedAd()
        }
    }
    
    // MARK: - Banner Ad
    static func showBannerAd() {
        guard let rootVC = rootViewController else { return }
        UnityManager.shared.showBannerAd(in: rootVC)
    }
    
    // MARK: - Interstitial Ad
    static func showInterstitialAd(completion: @escaping (Bool) -> Void) {
        
        guard let rootVC = rootViewController else {
            completion(false)
            return
        }
        
        UnityManager.shared.showInterstitialAd(
            from: rootVC,
            onClose: completion
        )
    }
}
//
//  UnityManager.swift
//  watch tv and sports
//
//  Created by Mobi iOS on 31/03/26.
//

import Foundation
import SwiftUI
import UnityAds
import UIKit

final class UnityManager: NSObject {

    // MARK: - Singleton
    static let shared = UnityManager()
    private override init() {}

    // MARK: - Placement IDs
    var bannerPlacementID = "Banner_iOS"
    var interstitialPlacementID = "Interstitial_iOS"
    var rewardedPlacementID = "Rewarded_iOS"

    // MARK: - Properties
    private(set) var gameID: String = ""

    var isInitialized = false
    var isInterstitialReady = false
    var isRewardedReady = false

    var onRewardedClose: ((Bool) -> Void)?
    var onRewardedReady: (() -> Void)?

    // MARK: - Initialization
    func initializeUnityAds(gameID: String) {
        self.gameID = gameID

        #if DEBUG
        UnityAds.initialize(gameID, testMode: true, initializationDelegate: self)
        #else
        UnityAds.initialize(gameID, initializationDelegate: self)
        #endif
    }

    // MARK: - Load Ads
    func loadRewardedAd() {
        guard isInitialized else { return }
        UnityAds.load(rewardedPlacementID, loadDelegate: self)
    }

    func loadInterstitialAd() {
        guard isInitialized else { return }
        UnityAds.load(interstitialPlacementID, loadDelegate: self)
    }

    // MARK: - Show Ads
    func showRewardedAd(from viewController: UIViewController,
                        onClose: @escaping (Bool) -> Void) {

        guard isInitialized else {
            onClose(false)
            return
        }

        if isRewardedReady {
            onRewardedClose = onClose
            isRewardedReady = false
            UnityAds.show(viewController,
                          placementId: rewardedPlacementID,
                          showDelegate: self)
        } else {
            loadRewardedAd()
            onClose(false)
        }
    }

    func showInterstitialAd(from viewController: UIViewController,
                            onClose: ((Bool) -> Void)? = nil) {

        guard isInitialized else {
            onClose?(false)
            return
        }

        if isInterstitialReady {
            isInterstitialReady = false
            UnityAds.show(viewController,
                          placementId: interstitialPlacementID,
                          showDelegate: self)
        } else {
            loadInterstitialAd()
            onClose?(false)
        }
    }

    func showBannerAd(in viewController: UIViewController) {
        guard isInitialized else { return }

        let banner = UADSBannerView(
            placementId: bannerPlacementID,
            size: CGSize(width: 320, height: 50)
        )

        banner.delegate = self
        viewController.view.addSubview(banner)
        banner.load()
    }

    // MARK: - Helpers
    func isRewardedAdReady() -> Bool {
        return isInitialized && isRewardedReady
    }
}

// MARK: - Initialization Delegate
extension UnityManager: UnityAdsInitializationDelegate {

    func initializationComplete() {
        isInitialized = true
        loadRewardedAd()
        loadInterstitialAd()
    }

    func initializationFailed(_ error: UnityAdsInitializationError,
                              withMessage message: String) {
        isInitialized = false
    }
}

// MARK: - Load Delegate
extension UnityManager: UnityAdsLoadDelegate {

    func unityAdsAdLoaded(_ placementId: String) {

        switch placementId {

        case rewardedPlacementID:
            isRewardedReady = true
            onRewardedReady?()
            onRewardedReady = nil

        case interstitialPlacementID:
            isInterstitialReady = true

        default:
            break
        }
    }

    func unityAdsAdFailed(toLoad placementId: String,
                          withError error: UnityAdsLoadError,
                          withMessage message: String) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {

            if placementId == self.rewardedPlacementID {
                self.loadRewardedAd()
            }

            if placementId == self.interstitialPlacementID {
                self.loadInterstitialAd()
            }
        }
    }
}

// MARK: - Show Delegate
extension UnityManager: UnityAdsShowDelegate {

    func unityAdsShowComplete(_ placementId: String,
                              withFinish state: UnityAdsShowCompletionState) {

        if placementId == rewardedPlacementID {
            onRewardedClose?(true)
            onRewardedClose = nil
            loadRewardedAd()
        }

        if placementId == interstitialPlacementID {
            loadInterstitialAd()
        }
    }

    func unityAdsShowFailed(_ placementId: String,
                            withError error: UnityAdsShowError,
                            withMessage message: String) {

        if placementId == rewardedPlacementID {
            onRewardedClose?(false)
            onRewardedClose = nil
            loadRewardedAd()
        }

        if placementId == interstitialPlacementID {
            loadInterstitialAd()
        }
    }

    func unityAdsShowStart(_ placementId: String) {}
    func unityAdsShowClick(_ placementId: String) {}
}

// MARK: - Banner Delegate
extension UnityManager: UADSBannerViewDelegate {

    func bannerViewDidLoad(_ bannerView: UADSBannerView!) {}

    func bannerViewDidError(_ bannerView: UADSBannerView!,
                            error: UADSBannerError!) {}
}

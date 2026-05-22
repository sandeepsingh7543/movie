//
//  UnityManager.swift
//  MovieApppss
//
//  Created by Mobi iOS on 11/09/25.
//

import Foundation
import UnityAds
import UIKit
import SwiftUI

class UnityManager: NSObject {

    static let shared = UnityManager()
    private var isInterstitialReady = false
    private var isRewardedReady = false
    private var gameID: String = "5944726"
    private var bannerPlacementID: String = "Banner_iOS"
    private var interstitialPlacementID: String = "Interstitial_iOS"
    private var rewardedVideoPlacementID: String = "Rewarded_iOS"
    private var onClose: ((Bool) -> Void)?
    private var isInitialized = false

    func initializeUnityAds(gameID: String, bannerPlacementID: String = "", interstitialPlacementID: String = "", rewardedVideoPlacementID: String = "") {
        self.gameID = gameID

        if !bannerPlacementID.isEmpty {
            self.bannerPlacementID = bannerPlacementID
        }

        if !interstitialPlacementID.isEmpty {
            self.interstitialPlacementID = interstitialPlacementID
        }

        if !rewardedVideoPlacementID.isEmpty {
            self.rewardedVideoPlacementID = rewardedVideoPlacementID
        }

#if DEBUG
        UnityAds.initialize(self.gameID, testMode: true, initializationDelegate: self)
#else
        UnityAds.initialize(self.gameID, initializationDelegate: self)
#endif
    }

    private func loadInterstitialAd() {
        guard isInitialized else { return }
        UnityAds.load(interstitialPlacementID, loadDelegate: self)
    }

    private func loadRewardedAd() {
        guard isInitialized else { return }
        UnityAds.load(rewardedVideoPlacementID, loadDelegate: self)
    }

    func showBannerAd(viewController: UIViewController) {
        guard isInitialized else { return }
        let banner = UADSBannerView(placementId: bannerPlacementID, size: CGSize(width: 320, height: 50))
        banner.delegate = self
        viewController.view.addSubview(banner)
        banner.load()
    }

    func createBannerView() -> UADSBannerView {
        guard isInitialized else {
            return UADSBannerView(placementId: bannerPlacementID, size: CGSize(width: 320, height: 50))
        }
        let banner = UADSBannerView(placementId: bannerPlacementID, size: CGSize(width: 320, height: 50))
        banner.load()
        return banner
    }

    func showInterstitialAds(viewController: UIViewController, onClose: @escaping (Bool) -> ()) {
        guard isInitialized else {
            onClose(false)
            return
        }

        if isInterstitialReady {
            UnityManager.shared.onClose = onClose
            UnityAds.show(viewController, placementId: interstitialPlacementID, showDelegate: self)
            isInterstitialReady = false
        } else {
            loadInterstitialAd()
            onClose(false)
        }
    }

    func showRewardedAds(viewController: UIViewController, onClose: @escaping (Bool) -> ()) {
        guard isInitialized else {
            onClose(false)
            return
        }

        if isRewardedReady {
            UnityManager.shared.onClose = onClose
            UnityAds.show(viewController, placementId: rewardedVideoPlacementID, showDelegate: self)
            isRewardedReady = false
        } else {
            loadRewardedAd()
            onClose(false)
        }
    }

    func isInterstitialAdReady() -> Bool {
        return isInterstitialReady && isInitialized
    }

    func isRewardedAdReady() -> Bool {
        return isRewardedReady && isInitialized
    }
}

extension UnityManager : UADSBannerViewDelegate {
    func bannerViewDidLoad(_ bannerView: UADSBannerView!) {}

    func bannerViewDidError(_ bannerView: UADSBannerView!, error: UADSBannerError!) {}
}

extension UnityManager : UnityAdsShowDelegate {
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        if placementId == interstitialPlacementID {
            loadInterstitialAd()
        } else if placementId == rewardedVideoPlacementID {
            loadRewardedAd()
        }

        UnityManager.shared.onClose?(true)
    }

    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        if placementId == interstitialPlacementID {
            loadInterstitialAd()
        } else if placementId == rewardedVideoPlacementID {
            loadRewardedAd()
        }

        UnityManager.shared.onClose?(false)
    }

    func unityAdsShowStart(_ placementId: String) {}

    func unityAdsShowClick(_ placementId: String) {}
}

extension UnityManager : UnityAdsLoadDelegate {
    func unityAdsAdLoaded(_ placementId: String) {
        if placementId == interstitialPlacementID {
            isInterstitialReady = true
        } else if placementId == rewardedVideoPlacementID {
            isRewardedReady = true
        }
    }

    func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if placementId == self.interstitialPlacementID {
                self.loadInterstitialAd()
            } else if placementId == self.rewardedVideoPlacementID {
                self.loadRewardedAd()
            }
        }
    }
}

extension UnityManager : UnityAdsInitializationDelegate {
    func initializationComplete() {
        isInitialized = true
        loadInterstitialAd()
        loadRewardedAd()
    }

    func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
        isInitialized = false
    }
}

extension UnityManager {
    func debugUnityAdsStatus() {}

    func testLoadAds() {
        if isInitialized {
            loadInterstitialAd()
            loadRewardedAd()
        }
    }
}

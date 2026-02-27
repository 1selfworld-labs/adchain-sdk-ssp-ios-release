import UIKit
import AdchainCommon
import AdchainSspCore
import GoogleMobileAds

public class AdmobAdapter: NSObject, SspAdapter {
    public let networkName = "admob"
    private var rewardedAds: [String: RewardedAd] = [:]
    private var interstitialAds: [String: InterstitialAd] = [:]

    private static let TAG = "AdmobAdapter"

    public init(config: [String: Any]) {}

    public func loadRewardedVideo(placementId: String, adUnitId: String, callback: SspAdCallback) {
        SspLogger.d(Self.TAG, "Loading rewarded: \(adUnitId) for placement=\(placementId)")
        RewardedAd.load(with: adUnitId, request: Request()) { [weak self] ad, error in
            if let error = error {
                SspLogger.e(Self.TAG, "Rewarded load failed: \(error.localizedDescription)")
                callback.onAdFailedToLoad?(SspAdError(code: (error as NSError).code, message: error.localizedDescription))
                return
            }
            guard let ad = ad, let self = self else { return }
            self.rewardedAds[placementId] = ad
            SspLogger.d(Self.TAG, "Rewarded loaded for placement=\(placementId)")
            callback.onAdLoaded?()
        }
    }

    public func showRewardedVideo(_ viewController: UIViewController, placementId: String, callback: SspAdCallback) {
        guard let ad = rewardedAds[placementId] else {
            callback.onError?(SspAdError(code: SspAdError.codeAdNotLoaded, message: "Rewarded ad not loaded for placement: \(placementId)"))
            return
        }
        let delegate = AdmobFullScreenDelegate(
            onShown: { callback.onAdShown?() },
            onDismissed: { [weak self] in
                self?.rewardedAds.removeValue(forKey: placementId)
                callback.onAdClosed?()
            },
            onClicked: { callback.onAdClicked?() },
            onFailed: { [weak self] error in
                self?.rewardedAds.removeValue(forKey: placementId)
                callback.onError?(SspAdError(code: (error as NSError).code, message: error.localizedDescription))
            }
        )
        ad.fullScreenContentDelegate = delegate
        objc_setAssociatedObject(ad, &AssociatedKeys.delegate, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        ad.present(from: viewController) {
            let reward = ad.adReward
            SspLogger.d(Self.TAG, "Reward: \(reward.type) x\(reward.amount)")
            callback.onRewarded?(rewardType: reward.type, rewardAmount: reward.amount.intValue)
        }
    }

    public func loadInterstitial(placementId: String, adUnitId: String, callback: SspAdCallback) {
        SspLogger.d(Self.TAG, "Loading interstitial: \(adUnitId) for placement=\(placementId)")
        InterstitialAd.load(with: adUnitId, request: Request()) { [weak self] ad, error in
            if let error = error {
                SspLogger.e(Self.TAG, "Interstitial load failed: \(error.localizedDescription)")
                callback.onAdFailedToLoad?(SspAdError(code: (error as NSError).code, message: error.localizedDescription))
                return
            }
            guard let ad = ad, let self = self else { return }
            self.interstitialAds[placementId] = ad
            SspLogger.d(Self.TAG, "Interstitial loaded for placement=\(placementId)")
            callback.onAdLoaded?()
        }
    }

    public func showInterstitial(_ viewController: UIViewController, placementId: String, callback: SspAdCallback) {
        guard let ad = interstitialAds[placementId] else {
            callback.onError?(SspAdError(code: SspAdError.codeAdNotLoaded, message: "Interstitial not loaded for placement: \(placementId)"))
            return
        }
        let delegate = AdmobFullScreenDelegate(
            onShown: { callback.onAdShown?() },
            onDismissed: { [weak self] in
                self?.interstitialAds.removeValue(forKey: placementId)
                callback.onAdClosed?()
            },
            onClicked: { callback.onAdClicked?() },
            onFailed: { [weak self] error in
                self?.interstitialAds.removeValue(forKey: placementId)
                callback.onError?(SspAdError(code: (error as NSError).code, message: error.localizedDescription))
            }
        )
        ad.fullScreenContentDelegate = delegate
        objc_setAssociatedObject(ad, &AssociatedKeys.delegate, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        ad.present(from: viewController)
    }

    public func isRewardedVideoLoaded(_ placementId: String) -> Bool { rewardedAds[placementId] != nil }
    public func isInterstitialLoaded(_ placementId: String) -> Bool { interstitialAds[placementId] != nil }

    public func destroy() {
        rewardedAds.removeAll()
        interstitialAds.removeAll()
    }
}

private enum AssociatedKeys {
    static var delegate = "AdmobFullScreenDelegate"
}

private class AdmobFullScreenDelegate: NSObject, FullScreenContentDelegate {
    private let onShown: () -> Void
    private let onDismissed: () -> Void
    private let onClicked: () -> Void
    private let onFailed: (Error) -> Void

    init(onShown: @escaping () -> Void,
         onDismissed: @escaping () -> Void,
         onClicked: @escaping () -> Void,
         onFailed: @escaping (Error) -> Void) {
        self.onShown = onShown
        self.onDismissed = onDismissed
        self.onClicked = onClicked
        self.onFailed = onFailed
    }

    func adDidRecordImpression(_ ad: FullScreenPresentingAd) { onShown() }
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) { onDismissed() }
    func adDidRecordClick(_ ad: FullScreenPresentingAd) { onClicked() }
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) { onFailed(error) }
}

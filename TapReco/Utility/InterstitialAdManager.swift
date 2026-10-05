//
//  InterstitialAdManager.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2026/10/05.
//

import Foundation
import GoogleMobileAds

@MainActor
final class InterstitialAdManager: NSObject {
    static let shared = InterstitialAdManager()

    #if DEBUG
    // Google公式のテスト用広告ユニットID（開発中に本番広告をタップしないため）
    private let adUnitID = "ca-app-pub-3940256099942544/4411468910"
    #else
    private let adUnitID = "ca-app-pub-8522231452310619/3414952587"
    #endif

    /// 何回の再生につき1回広告を表示するか
    private let showInterval = 3
    private let playCountKey = "interstitialPlayCount"

    private var interstitialAd: InterstitialAd?
    private var isStarted = false
    private var isLoading = false
    private var dismissCompletion: (() -> Void)?

    private var playCount: Int {
        get { UserDefaults.standard.integer(forKey: playCountKey) }
        set { UserDefaults.standard.set(newValue, forKey: playCountKey) }
    }

    func start() {
        guard !isStarted else { return }
        isStarted = true
        MobileAds.shared.start(completionHandler: nil)
        load()
    }

    /// 再生回数をカウントし、表示タイミングであれば広告を表示してから completion を呼ぶ
    /// 広告が未ロードの場合は表示せずにすぐ completion を呼び、次の再生で表示する
    func showIfNeeded(beforePresent: () -> Void, completion: @escaping () -> Void) {
        // 広告表示中の連打は無視する
        guard dismissCompletion == nil else { return }

        playCount += 1
        guard playCount >= showInterval, let ad = interstitialAd else {
            if interstitialAd == nil {
                load()
            }
            completion()
            return
        }

        beforePresent()
        playCount = 0
        interstitialAd = nil
        dismissCompletion = completion
        ad.present(from: nil)
    }

    private func load() {
        guard isStarted, !isLoading, interstitialAd == nil else { return }
        isLoading = true
        InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, _ in
            Task { @MainActor in
                guard let self else { return }
                self.isLoading = false
                ad?.fullScreenContentDelegate = self
                self.interstitialAd = ad
            }
        }
    }

    private func finishPresentation() {
        let completion = dismissCompletion
        dismissCompletion = nil
        completion?()
        load()
    }
}

extension InterstitialAdManager: FullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            finishPresentation()
        }
    }

    nonisolated func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            finishPresentation()
        }
    }
}

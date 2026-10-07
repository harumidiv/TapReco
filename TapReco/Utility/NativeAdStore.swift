//
//  NativeAdStore.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2026/10/07.
//

import Foundation
import GoogleMobileAds

/// 録音リストに差し込むネイティブアドバンス広告を読み込んで保持する
@MainActor
final class NativeAdStore: NSObject, ObservableObject {
    #if DEBUG
    // Google公式のテスト用広告ユニットID（開発中に本番広告をタップしないため）
    private let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    #else
    private let adUnitID = "ca-app-pub-8522231452310619/8573115770"
    #endif

    /// 一度に読み込む広告の最大数（同じ広告を複数の枠で使い回さないよう、枠の数もこれが上限）
    private let maxAdCount = 3

    @Published private(set) var nativeAds: [NativeAd] = []
    private var adLoader: AdLoader?

    func loadIfNeeded() {
        guard nativeAds.isEmpty, adLoader?.isLoading != true else { return }
        let options = MultipleAdsAdLoaderOptions()
        options.numberOfAds = maxAdCount
        let loader = AdLoader(adUnitID: adUnitID,
                              rootViewController: nil,
                              adTypes: [.native],
                              options: [options])
        loader.delegate = self
        loader.load(Request())
        adLoader = loader
    }
}

extension NativeAdStore: NativeAdLoaderDelegate {
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        nativeAds.append(nativeAd)
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        // 読み込めなかった場合は広告枠を出さないだけにする
    }
}

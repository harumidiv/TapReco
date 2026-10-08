//
//  AdManager.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2026/10/05.
//

import Foundation
import GoogleMobileAds

@MainActor
final class AdManager {
    static let shared = AdManager()

    private(set) var isStarted = false

    func start() {
        guard !isStarted else { return }

        // バナーに動画広告が含まれると、SDKはデフォルトでAVAudioSessionの
        // カテゴリを変更する。録音音声の再生用に設定した.playbackを維持するため、
        // 音声セッションはアプリ側で管理する。
        MobileAds.shared.audioVideoManager.isAudioSessionApplicationManaged = true

        isStarted = true
        MobileAds.shared.start(completionHandler: nil)
    }
}

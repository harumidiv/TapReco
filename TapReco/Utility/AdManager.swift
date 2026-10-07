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
        isStarted = true
        MobileAds.shared.start(completionHandler: nil)
    }
}

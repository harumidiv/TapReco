//
//  TapRecoApp.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI
import AVFoundation

@main
struct TapRecoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = RecordStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }.onChange(of: scenePhase) { scene in
            switch scene {
            case .active:
                // アプリ起動時のマイク使用許可のダイアログ表示
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
            case .inactive:
                print("scenePhase: inactive")
            case .background:
                print("scenePhase: background")
            @unknown default: break
            }
        }
    }
}

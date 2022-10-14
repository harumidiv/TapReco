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
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            RootView(records: $store.records) {
                Task {
                    do {
                        try await RecordStore.save(records: store.records)
                    } catch {
                        errorWrapper = ErrorWrapper(error: error, guidance: "録音データの保存に失敗しました")
                    }
                }
            }
            .task {
                do {
                    store.records = try await RecordStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "録音データの読み込みに失敗しました")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                // NOP
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
        .onChange(of: scenePhase) { scene in
            switch scene {
            case .active:
                // アプリ起動時のマイク使用許可のダイアログ表示
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
            case .inactive, .background:
                store.records = store.records.compactMap{ .init(record: $0, isSelected: false)}

            @unknown default: break
            }
        }
    }
}

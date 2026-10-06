//
//  TapRecoApp.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI
import AVFoundation
import AppTrackingTransparency

@main
struct TapRecoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = RecordStore()
    @State private var errorWrapper: ErrorWrapper?
    @State private var isRequestingPermissions = false
    @State private var recordingRequestID: UUID?

    var body: some Scene {
        WindowGroup {
            RootView(records: $store.records,
                     recordingRequestID: recordingRequestID) {
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
            .onOpenURL { url in
                guard url.scheme == "tapreco", url.host == "record" else { return }
                recordingRequestID = UUID()
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
                guard !isRequestingPermissions else { return }
                isRequestingPermissions = true
                Task {
                    await requestPermissions()
                    isRequestingPermissions = false
                }
            case .inactive, .background:
                store.records = store.records.compactMap{ .init(record: $0, isSelected: false)}

            @unknown default: break
            }
        }
    }

    /// アプリ起動時の許可ダイアログを重ならないよう順番に表示し、最後に広告SDKを開始する
    private func requestPermissions() async {
        _ = await AVCaptureDevice.requestAccess(for: .audio)
        await LocationManager.shared.requestPermission()
        // ATTはアプリがアクティブでないとダイアログが出ないため、直前のダイアログが閉じるのを待つ
        while UIApplication.shared.applicationState != .active {
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        _ = await ATTrackingManager.requestTrackingAuthorization()
        // ATTの結果を反映させるため、広告の読み込みは許可ダイアログの後に行う
        InterstitialAdManager.shared.start()
    }
}

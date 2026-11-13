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
    @StateObject private var store = RecordStore.shared
    @State private var errorWrapper: ErrorWrapper?
    @State private var isRequestingPermissions = false

    var body: some Scene {
        WindowGroup {
            Group {
#if DEBUG
                if let scene = ProcessInfo.processInfo.environment["TAPRECO_SCREENSHOT_SCENE"] {
                    StoreScreenshotScene(scene: scene)
                } else {
                    appContent
                }
#else
                appContent
#endif
            }
        }
        .onChange(of: scenePhase) { scene in
#if DEBUG
            guard ProcessInfo.processInfo.environment["TAPRECO_SCREENSHOT_SCENE"] == nil else { return }
#endif
            handleScenePhase(scene)
        }
    }

    private var appContent: some View {
        RootView(records: $store.records) {
            Task {
                do {
                    try await store.save()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "録音データの保存に失敗しました")
                }
            }
        }
        .task {
            do {
                try await store.loadIfNeeded()
            } catch {
                errorWrapper = ErrorWrapper(error: error, guidance: "録音データの読み込みに失敗しました")
            }
        }
        .onReceive(RecordingController.shared.failures) { failure in
            guard case .saveFailed(let error) = failure else { return }
            errorWrapper = ErrorWrapper(error: error, guidance: "録音データの保存に失敗しました")
        }
        .onOpenURL { url in
            guard url.scheme == "tapreco", url.host == "record" else { return }
            RecordingController.shared.requestStart()
        }
        .sheet(item: $errorWrapper, onDismiss: {}) { wrapper in
            ErrorView(errorWrapper: wrapper)
        }
    }

    private func handleScenePhase(_ scene: ScenePhase) {
        switch scene {
        case .active:
            guard !isRequestingPermissions else { return }
            isRequestingPermissions = true
            Task {
                await requestPermissions()
                isRequestingPermissions = false
            }
        case .inactive, .background:
            store.records = store.records.compactMap { .init(record: $0, isSelected: false) }
        @unknown default:
            break
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
        AdManager.shared.start()
    }
}

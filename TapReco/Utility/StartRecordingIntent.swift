//
//  StartRecordingIntent.swift
//  TapReco
//

import AppIntents

/// ショートカットアプリやSiriから、アプリを開いてすぐに録音を開始する
struct StartRecordingIntent: AppIntent {
    static var title: LocalizedStringResource = "録音を開始"
    static var description = IntentDescription("TapRecoを開いて、すぐに録音を開始します。")
    // バックグラウンドからは録音を開始できないため、アプリを前面に出してから録音する
    static var openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        RecordingController.shared.requestStart()
        return .result()
    }
}

struct TapRecoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartRecordingIntent(),
            phrases: [
                "\(.applicationName)で録音を開始",
                "\(.applicationName)で録音"
            ]
        )
    }
}

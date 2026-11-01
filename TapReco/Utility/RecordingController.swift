//
//  RecordingController.swift
//  TapReco
//

import Combine
import Foundation

enum RecordingFailure {
    /// 電話着信など復帰不可能な割り込みで録音を中止した
    case interrupted
    /// 録音データの一覧への保存に失敗した
    case saveFailed(Error)
}

/// 録音の開始・停止と録音データの保存を行う。
/// 画面を表示していない状態（ウィジェットなど）からも録音できるよう、Viewから独立させている。
@MainActor
final class RecordingController: ObservableObject {
    static let shared = RecordingController()

    @Published private(set) var isRecording = false
    let failures = PassthroughSubject<RecordingFailure, Never>()

    private let audioRecorder = AudioRecorderImpl()
    private var cancellables = Set<AnyCancellable>()

    private init() {
        audioRecorder.$isInterruptedNonResumably
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cancelByInterruption()
            }
            .store(in: &cancellables)
    }

    func start() throws {
        guard !isRecording else { return }
        try audioRecorder.recordStart()
        isRecording = true
    }

    func stop() {
        guard isRecording else { return }
        isRecording = false
        guard let newRecord = audioRecorder.recordStop() else { return }
        Task {
            do {
                try await RecordStore.shared.append(newRecord)
            } catch {
                failures.send(.saveFailed(error))
            }
        }
    }

    private func cancelByInterruption() {
        guard isRecording else { return }
        // ファイルを削除してから isRecording = false にする。
        // recordStop() は呼ばないため壊れたレコードは一覧に追加されない。
        audioRecorder.recordCancel()
        isRecording = false
        failures.send(.interrupted)
    }
}

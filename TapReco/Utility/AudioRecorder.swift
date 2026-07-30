//
//  AudioRecorder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

enum RecordingError: Error {
    case failedToStart
}

private final class NotificationObservation: @unchecked Sendable {
    private let token: NSObjectProtocol

    init(token: NSObjectProtocol) {
        self.token = token
    }

    deinit {
        NotificationCenter.default.removeObserver(token)
    }
}

@MainActor
final class AudioRecorderImpl: NSObject, ObservableObject {
    // 復帰不可能な割り込み（電話着信など）が発生したことをRootViewへ通知する
    @Published private(set) var isInterruptedNonResumably = false

    private var audioRecorder: AVAudioRecorder?
    private var currentRecordingTitle: String?
    private var interruptionObserver: NotificationObservation?

    override init() {
        super.init()
        let token = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] notification in
            guard let info = notification.userInfo,
                  let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
            let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
            Task { @MainActor [weak self] in
                self?.handleInterruption(typeValue: typeValue, optionsValue: optionsValue)
            }
        }
        interruptionObserver = NotificationObservation(token: token)
    }
}

// MARK: - Public Interface

extension AudioRecorderImpl {
    func recordStart() throws {
        isInterruptedNonResumably = false

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP])
        try session.setActive(true)

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320020,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]

        let title = Date().toString(format: .tapRecorYear) + ".m4a"
        currentRecordingTitle = title

        // setActive後に失敗した場合はセッションを確実に解放する
        do {
            let recorder = try AVAudioRecorder(url: createURL(title: title), settings: settings)
            recorder.delegate = self
            recorder.prepareToRecord()
            guard recorder.record() else {
                throw RecordingError.failedToStart
            }
            audioRecorder = recorder
        } catch {
            try? session.setActive(false, options: .notifyOthersOnDeactivation)
            try? FileManager.default.removeItem(at: createURL(title: title))
            currentRecordingTitle = nil
            throw error
        }
    }

    func recordStop() -> RecordData? {
        guard let recorder = audioRecorder, let title = currentRecordingTitle else {
            return nil
        }
        recorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        audioRecorder = nil
        currentRecordingTitle = nil

        let filePath = createURL(title: title).path
        return RecordData(
            title: getTitle(),
            recordDate: title.components(separatedBy: "+").first ?? title,
            fileName: title,
            fileSize: getFileSize(filePath: filePath),
            recordTime: getPlaybackTime(filePath: filePath)
        )
    }

    // 割り込みなどで録音失敗した場合の後始末。ファイルを削除し一覧には追加しない。
    func recordCancel() {
        guard let recorder = audioRecorder, let title = currentRecordingTitle else { return }
        recorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        try? FileManager.default.removeItem(at: createURL(title: title))
        audioRecorder = nil
        currentRecordingTitle = nil
    }
}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorderImpl: AVAudioRecorderDelegate {
    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let recorderID = ObjectIdentifier(recorder)
        Task { @MainActor [weak self] in
            // 古いレコーダーや recordCancel 後の遅延コールバックは無視する
            guard let self,
                  let currentRecorder = audioRecorder,
                  ObjectIdentifier(currentRecorder) == recorderID else { return }
            if !flag {
                isInterruptedNonResumably = true
            }
        }
    }

    nonisolated func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        let recorderID = ObjectIdentifier(recorder)
        Task { @MainActor [weak self] in
            guard let self,
                  let currentRecorder = audioRecorder,
                  ObjectIdentifier(currentRecorder) == recorderID else { return }
            isInterruptedNonResumably = true
        }
    }
}

// MARK: - Private

private extension AudioRecorderImpl {
    func handleInterruption(typeValue: UInt, optionsValue: UInt) {
        // 録音中でなければ再生中などの割り込みなので処理しない
        guard audioRecorder != nil else { return }
        guard let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            audioRecorder?.pause()
        case .ended:
            if AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume) {
                // setActive と record の両方が成功した場合のみ録音再開とみなす
                let activated = (try? AVAudioSession.sharedInstance().setActive(true)) != nil
                let resumed = activated && (audioRecorder?.record() ?? false)
                if !resumed {
                    isInterruptedNonResumably = true
                }
            } else {
                isInterruptedNonResumably = true
            }
        @unknown default:
            break
        }
    }

    func createURL(title: String) -> URL {
        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        return directory.appendingPathComponent(title)
    }

    func getTitle() -> String {
        LocationManager.shared.address ?? "新規作成"
    }

    func getFileSize(filePath: String) -> String {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: filePath),
              let bytes = attrs[.size] as? Int64 else { return "" }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useBytes, .useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }

    func getPlaybackTime(filePath: String) -> String {
        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath)) else { return "" }
        guard player.duration.isFinite,
              player.duration >= 0,
              player.duration <= Double(Int.max) else { return "" }
        let duration = Int(player.duration)
        let min = duration / 60
        let sec = duration % 60
        return min > 60 ? "1時間以上" : String(format: "%02d:%02d", min, sec)
    }
}

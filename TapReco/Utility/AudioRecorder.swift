//
//  AudioRecorder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation
import RealmSwift

protocol AudioRecoder: AVAudioRecorderDelegate, ObservableObject {
    func recordStart()
    func recordStop() -> RecordData
}

final class AudioRecorderImpl: NSObject {
    private var audioRecorder: AVAudioRecorder!
    private var currentRecordingTitle: String?

    private func createURL(title: String) -> URL{
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent(title)

        return filePath
    }
}

extension AudioRecorderImpl: AudioRecoder {
    func recordStart() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker])
        try! session.setActive(true)
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320020,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        currentRecordingTitle = Date().toString(format: .tapRecorYear) + ".m4a"
        audioRecorder = try! AVAudioRecorder(url: createURL(title: currentRecordingTitle!), settings: settings)
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func recordStop() -> RecordData {
        audioRecorder.stop()

        let filePath = NSHomeDirectory() + "/Documents/" + currentRecordingTitle!

        let fileSize: String = getFileSize(filePath: filePath)
        let playbackTime: String = getPlaybackTime(filePath: filePath)
        let recordingDate: String = currentRecordingTitle!.components(separatedBy: "+").first!
        let title: String = "My録音"
        return RecordData(title: title,
                          recordDate: recordingDate,
                          fileName: currentRecordingTitle ?? "",
                          fileSize: fileSize,
                          fileLength: playbackTime)
    }

}

// MARK: - Private Method
private extension AudioRecorderImpl {
    func getFileSize(filePath: String) -> String {
        let fileAttributes = try! FileManager.default.attributesOfItem(atPath: filePath)

        if let bytes = fileAttributes[.size] as? Int64 {
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useKB, .useMB, .useBytes, .useAll]
            bcf.countStyle = .file
            return bcf.string(fromByteCount: bytes)
        }
        return ""
    }
    
    func getPlaybackTime(filePath: String) -> String {
        let audioUrl = URL(fileURLWithPath: filePath)
        let audioPlayer: AVAudioPlayer = try! AVAudioPlayer(contentsOf: audioUrl)
        
        let duration = Int(audioPlayer.duration)
        let min = duration / 60
        let sec = duration % 60
        
        let minString = min >= 10 ? min.description : "0" + min.description
        let secString = sec >= 10 ? sec.description : "0" + sec.description
        
        return min > 60 ? "1時間以上" : minString + ":" + secString
    }
}

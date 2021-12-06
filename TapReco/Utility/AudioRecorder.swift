//
//  AudioRecorder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

protocol AudioRecoder: AVAudioRecorderDelegate, ObservableObject {
    func recordStart()
    func recordStop()
}
 
final class AudioRecorderImpl: NSObject {
    private var audioRecorder: AVAudioRecorder!
    
    private func createURL() -> URL{
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let recordTitle: String = Date().toString(format: .tapRecorYear) + ".m4a"
        let filePath = documentPath.appendingPathComponent(recordTitle)

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
        
        audioRecorder = try! AVAudioRecorder(url: createURL(), settings: settings)
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func recordStop()  {
        audioRecorder.stop()
    }
        
}

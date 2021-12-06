//
//  AudioRecorder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

protocol AudioRecoder: AVAudioRecorderDelegate, ObservableObject {
    func record()
    func recordStop()
}
 
final class AudioRecorderImpl: NSObject {
    private var audioRecorder: AVAudioRecorder!
    
    private func getURL() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sound.m4a")
    }
}

extension AudioRecorderImpl: AudioRecoder {
    // TODO 再生するurlを引数でもらってくる必要がある
    func record() {
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
        
        audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func recordStop()  {
        audioRecorder.stop()
    }
        
}

//
//  AudioRecorder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

protocol RecorderDelegate: AVAudioRecorderDelegate {
    func record()
    func recordStop() -> Data?
    func playStart()
    func playStop()
}
 
final class AudioRecorder: NSObject {
    private var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    private func getURL() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sound.m4a")
    }
}

extension AudioRecorder: RecorderDelegate {
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
    
    func recordStop() -> Data? {
        audioRecorder.stop()
        let data = try? Data(contentsOf: getURL())
        return data
    }
    
    func playStart() {
        audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
        audioPlayer.volume = 1.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func playStop() {
        audioPlayer.stop()
    }
    
}

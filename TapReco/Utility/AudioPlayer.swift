//
//  AudioPlayer.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

protocol AudioPlayer {
    func playStart(fileName: String)
    func playStop()
}

final class AudioPlayerImpl: NSObject {
    var audioPlayer: AVAudioPlayer!
        
    private func getURL(fileName: String) -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }
}

extension AudioPlayerImpl: AudioPlayer {
    func playStart(fileName: String) {
        audioPlayer = try! AVAudioPlayer(contentsOf: getURL(fileName: fileName))
        audioPlayer.volume = 1.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func playStop() {
        audioPlayer.stop()
    }
}

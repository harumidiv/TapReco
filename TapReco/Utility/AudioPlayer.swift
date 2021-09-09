//
//  AudioPlayer.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

protocol AudioPlayer: ObservableObject{
    func playStart()
    func playStop()
}

class AudioPlayerImpl: NSObject {
    var audioPlayer: AVAudioPlayer!
        
    private func getURL() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("sound.m4a")
    }
}

extension AudioPlayerImpl: AudioPlayer {
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

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
        audioPlayer = try? AVAudioPlayer(contentsOf: getURL(fileName: fileName))
        audioPlayer.volume = 1.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    func reStart(fileName: String) {
        let currentTime = audioPlayer.currentTime
        if currentTime == audioPlayer.duration || currentTime == 0 {
            playStart(fileName: fileName)
        } else {
            audioPlayer.play()
        }
    }
    
    func playStop() {
        audioPlayer.stop()
    }


    /// 15秒再生時間をスキップさせる
    /// - Returns: 再生が末尾まで到達しているか
    func skipFifteenSeconds() -> Bool {
        let currentTime = audioPlayer.currentTime
        let timeDiff = audioPlayer.duration - currentTime
        audioPlayer.stop()
        let isAbleToSkip = timeDiff > 15
        if isAbleToSkip {
            audioPlayer.currentTime += 15
            audioPlayer.play()
        } else {
            audioPlayer.currentTime = audioPlayer.duration
        }
        return !isAbleToSkip

    }

    func rewindFifteenSeconds() {
        let currentTime = audioPlayer.currentTime
        audioPlayer.stop()
        if currentTime > 15 {
            audioPlayer.currentTime -= 15
        } else {
            audioPlayer.currentTime = 0
        }
        audioPlayer.play()
    }
}

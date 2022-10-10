//
//  AudioPlayer.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

final class AudioPlayer: NSObject, ObservableObject {
    @Published var displayTime: Double = .zero
    @Published var displayCurrentTime: String = ""
    @Published var displaytimeLeft: String = ""
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    private var audioPlayer: AVAudioPlayer!
    var playComplete: (()->Void)?
    /// ファイルの総再生時間
    var duration: Double {
        Double(audioPlayer.duration)
    }

    /// ファイルの現在の再生時間
    var currentTime: Double {
        Double(audioPlayer.currentTime)
    }

    /// 初期化
    func setup(fileName: String) {
        self.audioPlayer = nil
        self.audioPlayer = try! AVAudioPlayer(contentsOf: getURL(fileName: fileName))
        self.audioPlayer.volume = 1.0
        self.audioPlayer.delegate = self

        playStart()
    }

    /// 再生途中から再度再生に切り替えを行う
    /// - Parameter fileName: 再生するファイルのパス
    func reStart() {
        let currentTime = audioPlayer.currentTime
        if currentTime == audioPlayer.duration || currentTime == 0 {
            playStart()
        } else {
            audioPlayer.play()
        }
    }

    /// 再生を停止する
    func playStop() {
        audioPlayer.stop()
    }

    /// 再生時間を15秒先にスキップする
    /// - Returns: 再生時間が末尾まで到達しているか否か
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

    /// 再生時間を15秒巻き戻す
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

    func changeSliderValue() {
        playStop()
    }

    func stopSliderValue() {
        audioPlayer?.currentTime = displayTime
        reStart()
    }
}

// MARK: - PrivateMethod
extension AudioPlayer {
    private func getURL(fileName: String) -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }

    /// 0秒からの再生
    private func playStart() {
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playComplete?()
        print("再生完了")
    }
}

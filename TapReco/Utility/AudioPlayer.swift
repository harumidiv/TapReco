//
//  AudioPlayer.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation

final class AudioPlayerImpl: ObservableObject {
    @Published var displayTime: Double = .zero
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var audioPlayer: AVAudioPlayer!

    private func getURL(fileName: String) -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }

}

//extension AudioPlayerImpl: AudioPlayer {
extension AudioPlayerImpl {

    /// 初期化
    /// - Parameter filePath: 再生するファイルのpath
    convenience init(fileName: String) {
        self.init()
        self.audioPlayer = try! AVAudioPlayer(contentsOf: getURL(fileName: fileName))
        self.audioPlayer.volume = 1.0
    }

    /// ファイルの総再生時間
    var duration: Double {
        Double(audioPlayer.duration)
    }

    /// ファイルの現在の再生時間
    var currentTime: Double {
        Double(audioPlayer.currentTime)
    }

    /// - Parameter fileName: 再生するファイルのパス
    func playStart(fileName: String) {
        audioPlayer = try? AVAudioPlayer(contentsOf: getURL(fileName: fileName))
        audioPlayer.volume = 1.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    /// 再生途中から再度再生に切り替えを行う
    /// - Parameter fileName: 再生するファイルのパス
    func reStart(fileName: String) {
        let currentTime = audioPlayer.currentTime
        if currentTime == audioPlayer.duration || currentTime == 0 {
            playStart(fileName: fileName)
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
}

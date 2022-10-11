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

    func setCurrentTime(time: Double) {
        audioPlayer.currentTime = TimeInterval(time)
    }

    /// スライダーに変更が開始された
    func changeSliderValue() {
        playStop()
    }

    /// スライダーの変更が停止された
    func stopSliderValue() {
        audioPlayer?.currentTime = displayTime
        reStart()
    }
}

// MARK: - PrivateMethod
extension AudioPlayer {
    func getURL(fileName: String) -> URL{
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





// ----------------------------------------------------------------

//class audioSettings: ObservableObject {
//
//    var audioPlayer: AVAudioPlayer?
//    var playing = false
//    @Published var playValue: TimeInterval = 0.0
//    var playerDuration: TimeInterval = 146
//    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//
//    func playSound(sound: String, type: String) {
//        if let path = Bundle.main.path(forResource: sound, ofType: type) {
//            do {
//                if playing == false {
//                    if (audioPlayer == nil) {
//
//
//                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
//                        audioPlayer?.prepareToPlay()
//
//                        audioPlayer?.play()
//                        playing = true
//                    }
//
//                }
//                if playing == false {
//
//                    audioPlayer?.play()
//                    playing = true
//                }
//
//
//            } catch {
//                print("Could not find and play the sound file.")
//            }
//        }
//
//    }
//
//    func stopSound() {
//        //   if playing == true {
//        audioPlayer?.stop()
//        audioPlayer = nil
//        playing = false
//        playValue = 0.0
//        //   }
//    }
//
//    func pauseSound() {
//        if playing == true {
//            audioPlayer?.pause()
//            playing = false
//        }
//    }
//
//    func changeSliderValue() {
//        if playing == true {
//            pauseSound()
//            audioPlayer?.currentTime = playValue
//
//        }
//
//        if playing == false {
//            audioPlayer?.play()
//            playing = true
//        }
//    }
//}
//
//struct myExperienceFearChunk: View {
//    @ObservedObject var audiosettings = audioSettings()
//    @State private var playButton: Image = Image(systemName: "play.circle")
//
//    var body: some View {
//
//        VStack {
//            Slider(value: $audiosettings.playValue, in: TimeInterval(0.0)...audiosettings.playerDuration, onEditingChanged: { _ in
//                self.audiosettings.changeSliderValue()
//            })
//            .onReceive(audiosettings.timer) { _ in
//
//                if self.audiosettings.playing {
//                    if let currentTime = self.audiosettings.audioPlayer?.currentTime {
//                        self.audiosettings.playValue = currentTime
//
//                        if currentTime == TimeInterval(0.0) {
//                            self.audiosettings.playing = false
//                        }
//                    }
//
//                }
//                else {
//                    self.audiosettings.playing = false
//                    self.audiosettings.timer.upstream.connect().cancel()
//                }
//            }
//        }
//    }
//}

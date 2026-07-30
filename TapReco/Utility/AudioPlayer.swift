//
//  AudioPlayer.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation
import Combine

final class AudioPlayer: NSObject, ObservableObject {
    @Published var displayTime: Double = .zero
    @Published var displayCurrentTime: String = ""
    @Published var displaytimeLeft: String = ""
    @Published var updateValue: Int = 0

    private var cancellable: AnyCancellable?
    private var audioPlayer: AVAudioPlayer?
    var playComplete: (() -> Void)?

    var duration: Double {
        audioPlayer?.duration ?? 0
    }

    var currentTime: Double {
        audioPlayer?.currentTime ?? 0
    }

    @discardableResult
    func setup(fileName: String) -> Bool {
        guard let player = try? AVAudioPlayer(contentsOf: getURL(fileName: fileName)) else {
            return false
        }
        player.volume = 1.0
        player.delegate = self

        let previousPlayer = audioPlayer
        audioPlayer = player
        guard player.prepareToPlay(), player.play() else {
            audioPlayer = previousPlayer
            return false
        }

        resetTimer()
        previousPlayer?.stop()
        setTimer()
        return true
    }

    @discardableResult
    func reStart() -> Bool {
        guard let player = audioPlayer else { return false }
        let current = player.currentTime
        if current == player.duration || current == 0 {
            return playStart()
        } else {
            guard player.play() else { return false }
            setTimer()
            return true
        }
    }

    func playStop() {
        resetTimer()
        audioPlayer?.stop()
    }

    func skipFifteenSeconds() -> Bool {
        guard let player = audioPlayer else { return true }
        let current = player.currentTime
        let timeDiff = player.duration - current
        player.stop()
        let isAbleToSkip = timeDiff > 15
        if isAbleToSkip {
            player.currentTime += 15
            guard player.play() else {
                resetTimer()
                return true
            }
        } else {
            player.currentTime = player.duration
            resetTimer()
        }
        return !isAbleToSkip
    }

    @discardableResult
    func rewindFifteenSeconds() -> Bool {
        guard let player = audioPlayer else { return false }
        let current = player.currentTime
        player.stop()
        player.currentTime = current > 15 ? current - 15 : 0
        return reStart()
    }

    func setCurrentTime(time: Double) {
        audioPlayer?.currentTime = TimeInterval(time)
    }

    func changeSliderValue() {
        playStop()
    }

    @discardableResult
    func stopSliderValue() -> Bool {
        audioPlayer?.currentTime = displayTime
        return reStart()
    }
}

// MARK: - PrivateMethod
extension AudioPlayer {
    func getURL(fileName: String) -> URL {
        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        return directory.appendingPathComponent(fileName)
    }

    private func playStart() -> Bool {
        guard let player = audioPlayer else { return false }
        guard player.prepareToPlay(), player.play() else {
            resetTimer()
            return false
        }
        setTimer()
        return true
    }

    private func setTimer() {
        resetTimer()
        cancellable = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateValue += 1
            }
    }

    private func resetTimer() {
        updateValue = 0
        cancellable?.cancel()
        cancellable = nil
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard audioPlayer === player else { return }
        resetTimer()
        playComplete?()
    }
}

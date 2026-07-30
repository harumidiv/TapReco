//
//  AudioPlayer.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/05.
//

import AVFoundation
import Combine

@MainActor
final class AudioPlayer: NSObject, ObservableObject {
    @Published var displayTime: Double = .zero
    @Published var displayCurrentTime: String = ""
    @Published var displaytimeLeft: String = ""
    @Published var updateValue: Int = 0

    private var cancellable: AnyCancellable?
    private var audioPlayer: AVAudioPlayer?
    var playComplete: (() -> Void)?

    var duration: Double {
        guard let duration = audioPlayer?.duration,
              duration.isFinite,
              duration >= 0 else { return 0 }
        return duration
    }

    var currentTime: Double {
        guard let currentTime = audioPlayer?.currentTime,
              currentTime.isFinite,
              currentTime >= 0 else { return 0 }
        return min(currentTime, duration)
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
        guard player.prepareToPlay(),
              player.duration.isFinite,
              player.duration >= 0,
              player.play() else {
            audioPlayer = previousPlayer
            return false
        }

        resetTimer()
        previousPlayer?.stop()
        displayTime = 0
        displayCurrentTime = "00:00"
        displaytimeLeft = formattedTime(player.duration)
        setTimer()
        return true
    }

    @discardableResult
    func reStart() -> Bool {
        guard let player = audioPlayer else { return false }
        let current = currentTime
        if current >= duration || current == 0 {
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
        let current = currentTime
        let totalDuration = duration
        let timeDiff = totalDuration - current
        player.stop()
        let isAbleToSkip = timeDiff > 15
        if isAbleToSkip {
            player.currentTime = min(current + 15, totalDuration)
            guard player.play() else {
                resetTimer()
                return true
            }
        } else {
            player.currentTime = totalDuration
            resetTimer()
        }
        return !isAbleToSkip
    }

    @discardableResult
    func rewindFifteenSeconds() -> Bool {
        guard let player = audioPlayer else { return false }
        let current = currentTime
        player.stop()
        player.currentTime = current > 15 ? current - 15 : 0
        return reStart()
    }

    func setCurrentTime(time: Double) {
        guard time.isFinite, time >= 0, let audioPlayer else { return }
        audioPlayer.currentTime = min(time, duration)
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
        guard player.prepareToPlay(),
              player.duration.isFinite,
              player.duration >= 0,
              player.play() else {
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

    private func formattedTime(_ time: Double) -> String {
        guard time.isFinite,
              time >= 0,
              time <= Double(Int.max) else { return "00:00" }
        let seconds = Int(time)
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let playerID = ObjectIdentifier(player)
        Task { @MainActor [weak self] in
            guard let self,
                  let currentPlayer = audioPlayer,
                  ObjectIdentifier(currentPlayer) == playerID else { return }
            resetTimer()
            playComplete?()
        }
    }
}

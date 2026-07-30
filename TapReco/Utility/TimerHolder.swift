//
//  TimerHolder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/12.
//

import SwiftUI
import Combine

@MainActor
final class TimerHolder: ObservableObject {
    @Published var timerText: String = "00:00:00"
    private var timerCancellable: AnyCancellable?
    private var startedAt: Date?
    
    func start() {
        startedAt = Date()
        timerText = "00:00:00"
        resumeDisplayUpdates()
    }

    func pauseDisplayUpdates() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func resumeDisplayUpdates() {
        guard startedAt != nil, timerCancellable == nil else { return }
        updateTimerText()
        timerCancellable = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimerText()
            }
    }
    
    func stop() {
        pauseDisplayUpdates()
        startedAt = nil
    }

    private func updateTimerText() {
        guard let startedAt else { return }
        let elapsedTime = max(Date().timeIntervalSince(startedAt), 0)
        guard elapsedTime.isFinite,
              elapsedTime <= Double(Int.max) / 100 else {
            timerText = "00:00:00"
            return
        }

        let centiseconds = Int(elapsedTime * 100)
        let milliSecond = centiseconds % 100
        let second = (centiseconds / 100) % 60
        let minutes = centiseconds / 6_000
        timerText = String(format: "%02d:%02d:%02d", minutes, second, milliSecond)
    }
}

//
//  TimerHolder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/12.
//

import SwiftUI
import Combine

final class TimerHolder: ObservableObject {
    @Published var timerText: String = "00:00:00"
    private var timer: Timer?
    private var elapsedTime: CGFloat = 0

    deinit {
        timer?.invalidate()
    }
    
    func start() {
        timer?.invalidate()
        elapsedTime = 0
        timerText = "00:00:00"
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self else { return }

            elapsedTime += 0.01
            let milliSecond = Int(elapsedTime * 100) % 100
            let second = Int(elapsedTime) % 60
            let minutes = Int(elapsedTime / 60)
            
            timerText = String(format: "%02d:%02d:%02d", minutes, second, milliSecond)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}

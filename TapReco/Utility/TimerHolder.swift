//
//  TimerHolder.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/12.
//

import SwiftUI
import Combine

class TimerHolder : ObservableObject {
    @Published var timer : Timer!
    @Published var timerText: String = "00:00:00"
    private var elapsedTime: CGFloat = 0
    
    func start() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
            _ in
            
            self.elapsedTime += 0.01
            let milliSecond = Int(self.elapsedTime * 100) % 100
            let second = Int(self.elapsedTime) % 60
            let minutes = Int(self.elapsedTime / 60)
            
            self.timerText = String(format: "%02d:%02d:%02d", minutes, second, milliSecond)
        }
    }
    
    func stop() {
        timer.invalidate()
        timer = nil
    }
}

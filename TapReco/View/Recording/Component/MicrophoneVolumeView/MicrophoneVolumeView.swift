//
//  MicrophoneVolumeView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/07.
//

import SwiftUI

private struct BarConfig {
    let baseRatio: Double
    let peakRatio: Double
    let speed: Double
    let phase: Double
}

// 左半分の設定。外側から中央に向かって高くなる山型プロファイル
private let halfConfigs: [BarConfig] = [
    BarConfig(baseRatio: 0.08, peakRatio: 0.25, speed: 1.3, phase: 0),
    BarConfig(baseRatio: 0.10, peakRatio: 0.40, speed: 0.9, phase: .pi / 6),
    BarConfig(baseRatio: 0.12, peakRatio: 0.55, speed: 1.2, phase: .pi / 3),
    BarConfig(baseRatio: 0.14, peakRatio: 0.65, speed: 0.8, phase: .pi / 2),
    BarConfig(baseRatio: 0.14, peakRatio: 0.72, speed: 1.4, phase: 2 * .pi / 3),
    BarConfig(baseRatio: 0.12, peakRatio: 0.76, speed: 1.0, phase: 5 * .pi / 6),
]

// 左右対称に展開（右側は位相をπずらして独立感を出す）
private let allBars: [BarConfig] = halfConfigs + halfConfigs.reversed().map {
    BarConfig(baseRatio: $0.baseRatio, peakRatio: $0.peakRatio,
              speed: $0.speed, phase: $0.phase + .pi)
}

private struct EqualizerCanvas: View {
    let volume: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let vol = Double(volume)
                let barCount = allBars.count
                let barWidth = size.width / CGFloat(barCount)
                let barFill = barWidth * 0.60
                let maxH = size.height * 0.90

                for (i, bar) in allBars.enumerated() {
                    let shimmer = sin(t * bar.speed * .pi * 2 + bar.phase)
                    let baseH  = bar.baseRatio * maxH * (1 + 0.25 * shimmer)
                    let peakH  = bar.peakRatio * maxH * vol * (1 + 0.15 * shimmer)
                    let h = min(max(4, baseH + peakH), maxH)

                    let x = CGFloat(i) * barWidth + (barWidth - barFill) / 2
                    let rect = CGRect(x: x, y: size.height - h, width: barFill, height: h)
                    let path = Path(roundedRect: rect, cornerRadius: barFill / 2)

                    // 下から上へ：フェードグリーン → グリーン → レッド（VUメーター風）
                    context.fill(path, with: .linearGradient(
                        Gradient(stops: [
                            .init(color: AppColor.statusOK.opacity(0.45), location: 0),
                            .init(color: AppColor.statusOK,               location: 0.5),
                            .init(color: AppColor.statusError,            location: 1.0),
                        ]),
                        startPoint: CGPoint(x: x, y: size.height),
                        endPoint:   CGPoint(x: x, y: size.height - h)
                    ))
                }
            }
        }
    }
}

struct MicrophoneVolumeView: View {
    @StateObject private var manager = MicrophoneLebelManager()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        EqualizerCanvas(volume: manager.volume)
            .task(id: scenePhase) {
                guard scenePhase == .active else {
                    manager.stopUpdatingVolume()
                    return
                }
                // 遅延を追加しないとHaptic FeedBackが発火しない
                do {
                    try await Task.sleep(nanoseconds: 500_000_000)
                } catch {
                    return
                }
                guard !Task.isCancelled else { return }
                manager.startUpdatingVolume()
            }
            .onDisappear {
                manager.stopUpdatingVolume()
            }
    }
}

struct MicrophoneVolumeView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneVolumeView()
            .frame(width: 300, height: 200)
            .preferredColorScheme(.dark)
    }
}

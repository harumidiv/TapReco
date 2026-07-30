//
//  MicrophoneLebelManager.swift
//  ViewHeightSizeChange
//
//  Created by 佐川 晴海 on 2021/09/06.
//

import SwiftUI
import AVFoundation
import AudioToolbox
import Combine


func AudioQueueInputCallback(inUserData: UnsafeMutableRawPointer?, inAQ: AudioQueueRef, inBuffer: AudioQueueBufferRef, inSrartTime: UnsafePointer<AudioTimeStamp>, inNumberPacketDescriptions: UInt32, inPacketDescs: UnsafePointer<AudioStreamPacketDescription>?) {
    // NOP
}

private final class AudioQueueResource: @unchecked Sendable {
    let queue: AudioQueueRef

    init(queue: AudioQueueRef) {
        self.queue = queue
    }

    deinit {
        AudioQueueStop(queue, true)
        AudioQueueDispose(queue, true)
    }
}

@MainActor
final class MicrophoneLebelManager: ObservableObject {
    @Published var volume: CGFloat = 0

    private var queueResource: AudioQueueResource?
    private var levelCancellable: AnyCancellable?
    
    func startUpdatingVolume() {
        stopUpdatingVolume()

        // 録音データを記録するフォーマット
        var dataFormat = AudioStreamBasicDescription(
            mSampleRate: 44100.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: AudioFormatFlags(kLinearPCMFormatFlagIsBigEndian |
                                            kLinearPCMFormatFlagIsSignedInteger |
                                            kLinearPCMFormatFlagIsPacked),
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0)
        
        // 新しい録音オーディオキューオブジェクトを作成
        var newQueue: AudioQueueRef?
        let creationStatus = AudioQueueNewInput(
            &dataFormat,
            AudioQueueInputCallback,
            nil,
            .none,
            .none,
            0,
            &newQueue
        )
        guard creationStatus == noErr, let newQueue else { return }
        
        var enabledLevelMeter: UInt32 = 1
        // オーディオキューのプロパティ値を設定
        let meteringStatus = AudioQueueSetProperty(
            newQueue,
            kAudioQueueProperty_EnableLevelMetering,
            &enabledLevelMeter,
            UInt32(MemoryLayout<UInt32>.size)
        )
        guard meteringStatus == noErr else {
            AudioQueueDispose(newQueue, true)
            return
        }

        // オーディオの再生または録音の開始
        let startStatus = AudioQueueStart(newQueue, nil)
        guard startStatus == noErr else {
            AudioQueueDispose(newQueue, true)
            return
        }
        queueResource = AudioQueueResource(queue: newQueue)

        levelCancellable = Timer.publish(every: 1 / 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.detectVolume()
            }
    }
    
    func stopUpdatingVolume() {
        levelCancellable?.cancel()
        levelCancellable = nil

        guard queueResource != nil else {
            volume = 0
            return
        }
        queueResource = nil
        volume = 0
    }
    
    private func detectVolume() {
        guard let queue = queueResource?.queue else { return }
        var levelMeter = AudioQueueLevelMeterState()
        var propertySize = UInt32(MemoryLayout<AudioQueueLevelMeterState>.size)
        
        let status = AudioQueueGetProperty(
            queue,
            kAudioQueueProperty_CurrentLevelMeterDB,
            &levelMeter,
            &propertySize)
        // 起動直後など一時的な失敗はスキップし、タイマーは継続する
        guard status == noErr else { return }

        let minVol: CGFloat = -50
        let maxVol: CGFloat = 0
        // min: -60, max: -0 くらいが手元の環境では取れたのでそっちの方が綺麗に動く
        let normalizationValue = (CGFloat(levelMeter.mAveragePower) - minVol) / (maxVol - minVol)

        withAnimation(.spring(response: 0.15, dampingFraction: 0.75)) {
            volume = min(max(normalizationValue, 0), 1)
        }
    }
}

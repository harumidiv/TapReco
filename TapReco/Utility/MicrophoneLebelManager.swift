//
//  MicrophoneLebelManager.swift
//  ViewHeightSizeChange
//
//  Created by 佐川 晴海 on 2021/09/06.
//

import Foundation
import AVFoundation
import AudioToolbox


func AudioQueueInputCallback(inUserData: UnsafeMutableRawPointer?, inAQ: AudioQueueRef, inBuffer: AudioQueueBufferRef, inSrartTime: UnsafePointer<AudioTimeStamp>, inNumberPacketDescriptions: UInt32, inPacketDescs: UnsafePointer<AudioStreamPacketDescription>?) {
    // NOP
}

final class MicrophoneLebelManager: ObservableObject {
    @Published var volume: CGFloat = 0

    private var queue: AudioQueueRef?
    private var recordingTimer: Timer?

    deinit {
        recordingTimer?.invalidate()
        if let queue {
            AudioQueueStop(queue, true)
            AudioQueueDispose(queue, true)
        }
    }
    
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
        queue = newQueue
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) {
            [weak self] timer in
            self?.detectVolume(timer: timer)
        }
        recordingTimer?.fire()
    }
    
    func stopUpdatingVolume() {
        recordingTimer?.invalidate()
        recordingTimer = nil

        guard let queue else {
            volume = 0
            return
        }
        self.queue = nil
        AudioQueueStop(queue, true)
        AudioQueueDispose(queue, true)
        volume = 0
    }
    
    private func detectVolume(timer: Timer) {
        guard let queue else {
            timer.invalidate()
            return
        }
        var levelMeter = AudioQueueLevelMeterState()
        var propertySize = UInt32(MemoryLayout<AudioQueueLevelMeterState>.size)
        
        let status = AudioQueueGetProperty(
            queue,
            kAudioQueueProperty_CurrentLevelMeterDB,
            &levelMeter,
            &propertySize)
        guard status == noErr else {
            stopUpdatingVolume()
            return
        }
        
        let minVol: CGFloat = -50
        let maxVol: CGFloat = 0
        // min: -60, max: -0 くらいが手元の環境では取れたのでそっちの方が綺麗に動く
        let normalizationValue = (CGFloat(levelMeter.mAveragePower) - minVol) / (maxVol - minVol)
        
        volume = min(max(normalizationValue, 0), 1)
    }
}

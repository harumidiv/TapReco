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

class MicrophoneLebelManager: ObservableObject {
    @Published var volume: CGFloat = 0

    var queue: AudioQueueRef!
    var recordingTimer: Timer!
    
    func startUpdatingVolume() {
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
        AudioQueueNewInput(&dataFormat,
                           AudioQueueInputCallback,
                           UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                           .none,
                           .none,
                           0,
                           &queue)
        
        // オーディオの再生または録音の開始
        AudioQueueStart(self.queue, nil)
        
        var enabledLevelMeter: UInt32 = 1
        // オーディオキューのプロパティ値を設定
        AudioQueueSetProperty(self.queue,
                              kAudioQueueProperty_EnableLevelMetering,
                              &enabledLevelMeter,
                              UInt32(MemoryLayout<UInt32>.size))
        
        self.recordingTimer = Timer.scheduledTimer(timeInterval: 1 / 60,
                                                   target: self,
                                                   selector: #selector(self.detectVolume(timer:)),
                                                   userInfo: nil,
                                                   repeats: true)
        self.recordingTimer?.fire()
    }
    
    func stopUpdatingVolume() {
        // Finish observation
        
        self.recordingTimer.invalidate()
        self.recordingTimer = nil
        AudioQueueFlush(self.queue)
        AudioQueueStop(self.queue, false)
        AudioQueueDispose(self.queue, true)
    }
    
    @objc private func detectVolume(timer: Timer) {
        // オーディオキューの現在のレベル情報の
        var levelMeter = AudioQueueLevelMeterState()
        var propertySize = UInt32(MemoryLayout<AudioQueueLevelMeterState>.size)
        
        AudioQueueGetProperty(
            self.queue,
            kAudioQueueProperty_CurrentLevelMeterDB,
            &levelMeter,
            &propertySize)
        
        let minVol: CGFloat = -160
        let maxVol: CGFloat = 0
        // min: -60, max: -0 くらいが手元の環境では取れたのでそっちの方が綺麗に動く
        let normalizationValue = (CGFloat(levelMeter.mAveragePower) - minVol) / (maxVol - minVol)
        
        self.volume = normalizationValue
    }
}

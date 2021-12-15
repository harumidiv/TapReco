//
//  StandbyPresenter.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import Foundation
import AVFoundation

protocol StandbyPresenter {
    func isMicrophoneAuthorizationApproved() -> Bool
}

final class StandbyPresenterImpl: StandbyPresenter {
    func isMicrophoneAuthorizationApproved() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .authorized:
            return true
        default:
            return false
        }
    }
}

//
//  StandbyPresenter.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import Foundation
import AVFoundation
import SwiftUI

final class StandbyPresenterImpl: ObservableObject {
    enum Inputs {
        case didTapRecording
        case didTapRecordListButton
    }
    
    @Published var isShowRecordList = false
    @Published var isShowAlertDialog = false
    
    var isAutholized: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    func apply(inputs: Inputs) {
        switch inputs {
        case .didTapRecording:
            
            if !isAutholized {
                isShowAlertDialog = true
            }
        case .didTapRecordListButton:
            isShowRecordList = true
        }
    }
    
    func alertBuilder() -> Alert {
        return Alert(
            title: Text("マイクへのアクセス許可がありません"),
            message: Text("[設定]に移動して、権限を許可してください"),
            primaryButton: .cancel(Text("キャンセル")),
            secondaryButton: .default(Text("設定"), action: {
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
    }
    
}

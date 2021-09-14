//
//  StandbyView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI
import AVFoundation

struct StandbyView: View {
    @Binding var isRecording: Bool
    
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .foregroundColor(Color("tp_gray"))
            .onTapGesture {
                if !isMicrophoneAuthorizationApproved() {
                    // TODO ダイアログなどを表示してユーザに提示する必要がある、設定に飛ばすのが良い？
                    print("ダイアログを出す")
                    return
                }
                isRecording = true
            }
        VStack {
            Text("Voice memo")
                .font(.largeTitle)
            LottieAnimationView(name: "microphone", loopMode: .loop)
                .frame(width: 300, height: 300)
                .onTapGesture {}
                .allowsHitTesting(false)
            Text("画面をタップで録音開始")
                .font(.body)
        }
    }
    
    private func isMicrophoneAuthorizationApproved() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .authorized:
            return true
        default:
            return false
        }
    }
}

struct StandbyView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyView(isRecording: .constant(false))
    }
}


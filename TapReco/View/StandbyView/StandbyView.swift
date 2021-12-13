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
    @State var isPresentedRecordListView = false
    
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
            .ignoresSafeArea()
        VStack {
            Image("home")
                .resizable() //TODO指定の仕方がわかったら直す
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height * 0.8)
                .onTapGesture {}
                .allowsHitTesting(false)
                .padding(EdgeInsets(
                                top: 16,
                                leading: 8,
                                bottom: 16,
                                trailing: 8
                            ))
            Button(action: {
                
                // TODO SlideToUnlockが解除されたタイミングでフラグを切り替える
                self.isPresentedRecordListView.toggle()
            }) {
                Text("TODO スライドボタンに置き換える")
            }
            .fullScreenCover(isPresented: $isPresentedRecordListView) {
                RecordListView(isPresentedRecordListView: $isPresentedRecordListView)
            }
            .frame(width: 300, height: 50)
            .border(Color.red, width: 10)
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


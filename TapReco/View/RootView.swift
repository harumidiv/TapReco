//
//  RootView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI
import Combine

struct RootView: View {
    // MARK: - Augument
    @Binding var records: [RecordData]
    let saveAction: ()->Void

    // MARK: - Property
    // バックグラウンドに移動しようとすると停止してエラーになるので次回アクティブになった時にエラーのスナックバーをダ表示する
    @State private var isNeedDisplayErrorSnackBar: Bool = false
    @State private var isRecording: Bool = false
    @State private var isShowSuccessSnackBar = false
    @State private var isShowFailureSnackBar = false
    // UserDefaultの値を参照して出すかのフラグの値が入るようにする
    @State private var isShowIntoView: Bool = UserStrage.isNeedDisplayIntro
    private let audioRecorder = AudioRecorderImpl()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            if isRecording {
                RecordingView(isRecording: $isRecording,
                              isShowSuccessSnackBar: $isShowSuccessSnackBar)
                .defersSystemGestures(on: .bottom)
            } else {
                StandbyView(saveAction: saveAction,
                            records: $records,
                            isRecording: $isRecording)
                .blur(radius: isShowIntoView ? 2.0 : 0.0)
                if isShowIntoView {
                    IntroView(isShowIntoView: $isShowIntoView)
                }
            }
        }
        .popup(isPresented: isShowSuccessSnackBar,
                content: SnackBarSuccessView.init)
        .popup(isPresented: isShowFailureSnackBar,
               content: SnackBarFailureView.init)
        .onChange(of: isRecording) { isRecording in
            if isRecording {
                let queue = DispatchQueue.global(qos: .userInitiated)
                queue.async {
                    audioRecorder.recordStart()
                    TimerHolder().start()
                }
                
            } else {
                guard let newRecord = audioRecorder.recordStop() else {
                    isNeedDisplayErrorSnackBar = true
                    return
                }
                records.append(newRecord)
                saveAction()
            }
        }
        .onChange(of: scenePhase) { scene in
            if scene == .active && isNeedDisplayErrorSnackBar {
                isNeedDisplayErrorSnackBar = false
                isShowFailureSnackBar = true
                Task {
                    // 2秒後にスナックバーを消す
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    isShowFailureSnackBar = false
                }
            }

            if scene == .inactive || scene == .background {
                withAnimation() {
                    isRecording = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(records: .constant(RecordData.sampleData), saveAction: {})
    }
}

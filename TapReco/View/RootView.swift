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
    @State private var isRecording: Bool = false
    // UserDefaultの値を参照して出すかのフラグの値が入るようにする
    @State private var isShowIntoView: Bool = UserStrage.isNeedDisplayIntro
    private let audioRecorder = AudioRecorderImpl()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            if isRecording {
                RecordingView(isRecording: $isRecording)
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
        .onChange(of: isRecording) { isRecording in
            if isRecording {
                let queue = DispatchQueue.global(qos: .userInitiated)
                queue.async {
                    audioRecorder.recordStart()
                    TimerHolder().start()
                }
                
            } else {
                guard let newRecord = audioRecorder.recordStop() else {
                    //レコードの保存に失敗
                    return
                }
                records.append(newRecord)
                saveAction()
            }
        }
        .onChange(of: scenePhase) {  scene in
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

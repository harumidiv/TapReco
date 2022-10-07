//
//  RootView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI
import Combine

struct RootView: View {
    @Binding var records: [RecordData]
    let saveAction: ()->Void
    
    @State var isRecording:Bool = false
    private let audioRecorder = AudioRecorderImpl()
    
    var body: some View {
        ZStack {
            if isRecording {
                RecordingView(isRecording: $isRecording)
            } else {
                StandbyView(records: $records, isRecording: $isRecording)
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
                let newRecord = audioRecorder.recordStop()
                records.append(newRecord)
                saveAction()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(records: .constant(RecordData.sampleData), saveAction: {})
    }
}

//
//  RootView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI
import Combine

struct RootView: View {    
    @State var isRecording:Bool = false
    @StateObject private var audioRecorder = AudioRecorderImpl()
    
    var body: some View {
        ZStack {
            if !isRecording {
                StandbyView(isRecording: $isRecording)
            } else {
                RecordingView(isRecording: $isRecording)
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
                audioRecorder.recordStop()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

//
//  ContentView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI

struct ContentView: View {
    let audioRecorder: AudioRecorder = AudioRecorder()
    var body: some View {
        VStack {
            Button("録画開始") {
                self.audioRecorder.record()
            }.padding(.bottom, 10.0)
            Button("録画停止") {
                _ = self.audioRecorder.recordStop()
            }.padding(.bottom, 10.0)
            Button("再生開始") {
                self.audioRecorder.playStart()
            }.padding(.bottom, 10.0)
            Button("再生停止") {
                self.audioRecorder.playStop()
            }.padding(.bottom, 10.0)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

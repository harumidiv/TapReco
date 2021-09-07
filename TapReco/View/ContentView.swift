//
//  ContentView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI

struct ContentView: View {
    let audioRecorder: AudioRecoder = AudioRecorderImpl()
    let audioPlayer: AudioPlayer = AudioPlayerImpl()
    
    @State var isRecording: Bool = false
    
    var body: some View {
        VStack {
            if !isRecording {
                Button("録画開始") {
                    self.audioRecorder.record()
                    isRecording = true
                }.padding(.bottom, 10.0)
            } else {
                HStack {
                    Button("録画停止") {
                        _ = self.audioRecorder.recordStop()
                        isRecording = false
                    }.padding(.bottom, 10.0)
                    MicrophoneVolumeView()
                }
            }
            
            Button("再生開始") {
                self.audioPlayer.playStart()
            }.padding(.bottom, 10.0)
            Button("再生停止") {
                self.audioPlayer.playStop()
            }.padding(.bottom, 10.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

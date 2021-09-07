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
        if !isRecording {
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .foregroundColor(.orange)
                    .onTapGesture {
                        if !isRecording {
                            self.audioRecorder.record()
                            isRecording = true
                        }
                    }
                
                Image(systemName: "star")
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.green)
                    .onTapGesture { /*NOP*/ }
                    .allowsTightening(false)
                // TODO ここは半モーダルViewに移行する
//                VStack {
//                    Button("再生開始") {
//                        self.audioPlayer.playStart()
//                    }.padding(.bottom, 10.0)
//                    Button("再生停止") {
//                        self.audioPlayer.playStop()
//                    }.padding(.bottom, 10.0)
//                }
            }
        } else {
            HStack {
                Button("録画停止") {
                    _ = self.audioRecorder.recordStop()
                    isRecording = false
                }.padding(.bottom, 10.0)
                MicrophoneVolumeView()
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

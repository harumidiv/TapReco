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
                    .foregroundColor(.gray)
                    .onTapGesture {
                        if !isRecording {
                            self.audioRecorder.record()
                            isRecording = true
                        }
                    }
                VStack {
                    Text("Voice memo")
                        .font(.largeTitle)
                    LottieAnimationView(name: "microphone", loopMode: .loop)
                        .frame(width: 300, height: 300)
                        .onTapGesture {}
                        .allowsHitTesting(false)
                }
            }
        } else {
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .foregroundColor(.gray)
                    .onTapGesture {}
                    .allowsTightening(false)
                VStack {
                    Text("Voice memo")
                        .font(.largeTitle)
                    MicrophoneVolumeView()
                        .frame(width: 300, height: 300, alignment: .center)
                        .border(Color.red, width: 1)
                    Button("録画停止") {
                        _ = self.audioRecorder.recordStop()
                        isRecording = false
                    }.frame(width: 200, height: 50, alignment: .center)
                    .background(Color.black)
                    .padding(10)
                    Text("スライドして録音停止")
                        .font(.body)
                    
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

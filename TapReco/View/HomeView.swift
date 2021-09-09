//
//  HomeView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var audioRecorder = AudioRecorderImpl()
    @StateObject private var audioPlayer = AudioPlayerImpl()
    
    @State var isRecording:Bool = false
    
    var body: some View {
        ZStack {
            if !isRecording {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isRecording = true
                    }
                VStack {
                    Text("Voice memo")
                        .font(.largeTitle)
                    LottieAnimationView(name: "microphone", loopMode: .loop)
                        .frame(width: 300, height: 300)
                        .onTapGesture {}
                        .allowsHitTesting(false)
                }
            } else {
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
                    Text("00:00:00")
                        .font(.largeTitle)
                    SlideToStopActionView(isRecording: $isRecording)
                        .frame(width: 200, height: 50)
                        .padding(10)
                    Text("スライドして録音停止")
                        .font(.body)
                    
                }
            }
        }.onChange(of: isRecording) { isRecording in
            if isRecording {
                audioRecorder.record()
            } else {
                audioRecorder.recordStop()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

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
    
    @State var rectangleHeight: CGFloat = 100
    
    var body: some View {
        let microPhoneLebelCapture = MicrophoneLebelCapture(delegate: self)
        HStack {
            VStack {
                Button("録画開始") {
                    self.audioRecorder.record()
                }.padding(.bottom, 10.0)
                Button("録画停止") {
                    _ = self.audioRecorder.recordStop()
                }.padding(.bottom, 10.0)
                Button("再生開始") {
                    self.audioPlayer.playStart()
                }.padding(.bottom, 10.0)
                Button("再生停止") {
                    self.audioPlayer.playStop()
                }.padding(.bottom, 10.0)
            }
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 10, height: rectangleHeight)
        }.onAppear() {
            microPhoneLebelCapture.startUpdatingVolume()
        }.onDisappear() {
            microPhoneLebelCapture.stopUpdatingVolume()
        }
    }
}

extension ContentView: MicrophonePowerDelegate {
    func didUpdatePowerLebel(value: CGFloat) {
        rectangleHeight = 100
        rectangleHeight = rectangleHeight + rectangleHeight * value
        print(value)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

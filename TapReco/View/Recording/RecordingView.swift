//
//  RecordingView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI

struct RecordingView: View {
    @Binding var isRecording: Bool
    @StateObject private var timerHolder = TimerHolder()
    
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .foregroundColor(Color("tp_gray"))
            .ignoresSafeArea()
            .onTapGesture {}
            .allowsTightening(false)
        VStack(spacing: 0) {
            MicrophoneVolumeView()
                .frame(width: 300, height: 200, alignment: .center)
            Text(timerHolder.timerText)
                .font(.custom("Avenir", size: 40))
            SlideSideActionView(isRecording: $isRecording,
                                  timerHolder: timerHolder)
                .frame(width: 240, height: 62)
                .padding(.init(top: 62, leading: 0, bottom: 20, trailing: 0))
            Text("スライドで録音停止")
                .foregroundColor(.white)
                .font(.headline)
        }
        .onAppear{
            timerHolder.start()
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(isRecording: .constant(false))
    }
}

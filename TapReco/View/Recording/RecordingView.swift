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
            .onTapGesture {}
            .allowsTightening(false)
        VStack {
            MicrophoneVolumeView()
                .frame(width: 300, height: 200, alignment: .center)
            Text(timerHolder.timerText)
                .font(.custom("Avenir", size: 50))
            SlideSideActionView(isRecording: $isRecording,
                                  timerHolder: timerHolder)
                .frame(width: 276, height: 85)
                .padding(10)
            Text("スライドで録音停止")
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

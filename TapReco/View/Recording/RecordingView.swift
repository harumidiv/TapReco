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
            Text("Voice memo")
                .font(.largeTitle)
            MicrophoneVolumeView()
                .frame(width: 300, height: 200, alignment: .center)
            Text(timerHolder.timerText)
                .font(.custom("Avenir", size: 50))
            SlideToStopActionView(isRecording: $isRecording,
                                  timerHolder: timerHolder)
                .frame(width: 250, height: 50)
                .padding(10)
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

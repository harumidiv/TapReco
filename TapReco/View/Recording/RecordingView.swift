//
//  RecordingView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI

struct RecordingView: View {
    @Binding var isRecording: Bool
    
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
            Text("00:00:00")
                .font(.largeTitle)
                .padding(20)
            SlideToStopActionView(isRecording: $isRecording)
                .frame(width: 250, height: 50)
                .padding(10)
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(isRecording: .constant(false))
    }
}

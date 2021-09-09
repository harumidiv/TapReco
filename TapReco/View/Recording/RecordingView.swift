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
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(isRecording: .constant(false))
    }
}

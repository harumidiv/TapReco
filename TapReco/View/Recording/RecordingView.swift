//
//  RecordingView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI

struct RecordingView: View {
    @Binding var isRecording: Bool
    @Binding var isShowSuccessSnackBar: Bool
    @StateObject private var timerHolder = TimerHolder()
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .foregroundColor(AppColor.background)
                .ignoresSafeArea()
                .onTapGesture {}
                .allowsTightening(false)
            VStack(spacing: 0) {
                MicrophoneVolumeView()
                    .frame(width: 300, height: 200, alignment: .center)
                    .padding()
                Text(timerHolder.timerText)
                    .font(.custom("Avenir", size:42))
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.textLightGray)
                    .padding(.top, 43)
                SlideSideActionView(isRecording: $isRecording,
                                    isShowSuccessSnackBar: $isShowSuccessSnackBar,
                                    timerHolder: timerHolder)
                .frame(width: 300, height: 58)
                .padding(.top, 137)
            }
        }
        .onAppear{
            timerHolder.start()
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(isRecording: .constant(false),
                      isShowSuccessSnackBar: .constant(false))
            .preferredColorScheme(.light)
        RecordingView(isRecording: .constant(false),
                      isShowSuccessSnackBar: .constant(false))
            .preferredColorScheme(.dark)
    }
}

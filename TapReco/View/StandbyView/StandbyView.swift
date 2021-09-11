//
//  StandbyView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI

struct StandbyView: View {
    @Binding var isRecording: Bool
    
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .foregroundColor(Color("tp_gray"))
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
    }
}

struct StandbyView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyView(isRecording: .constant(false))
    }
}


//
//  MicrophoneVolumeView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/07.
//

import SwiftUI

struct MicrophoneVolumeView: View {
    @State var rectangleHeight: CGFloat = 100
    @ObservedObject var microphoneLebelManager = MicrophoneLebelManager()
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 10, height: rectangleHeight + rectangleHeight * microphoneLebelManager.volume)
        }
        .onAppear() {
            microphoneLebelManager.startUpdatingVolume()
        }.onDisappear() {
            microphoneLebelManager.stopUpdatingVolume()
        }
    }
}


struct MicrophoneVolumeView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneVolumeView()
    }
}

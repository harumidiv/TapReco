//
//  MicrophoneVolumeView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/07.
//

import SwiftUI

struct MicrophoneVolumeView: View {
    let height: CGFloat = 100
    @StateObject private var manager = MicrophoneLebelManager()
    
    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(.black)
                .frame(width: 10, height: height + height * manager.volume)
            WaveView(manager: manager,
                     topViewHeight: 50,
                     BottomViewHeight: 100).frame(width: 10)
            Rectangle()
                .foregroundColor(.black)
                .frame(width: 10, height: height + height * manager.volume)
                // paddingで位置を調整することが可能
                .padding(10)
            Rectangle()
                .foregroundColor(.black)
                .frame(width: 10, height: height + height * manager.volume)
            Rectangle()
                .foregroundColor(.black)
                .frame(width: 10, height: height + height * manager.volume)
        }
        .onAppear() {
            manager.startUpdatingVolume()
        }.onDisappear() {
            manager.stopUpdatingVolume()
        }
    }
}


struct MicrophoneVolumeView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneVolumeView()
    }
}

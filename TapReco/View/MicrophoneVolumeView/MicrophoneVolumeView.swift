//
//  MicrophoneVolumeView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/07.
//

import SwiftUI

struct MicrophoneVolumeView: View {
    let height: CGFloat = 30
    let width: CGFloat = 5
    @StateObject private var manager = MicrophoneLebelManager()
    
    var body: some View {
        HStack {
            Group {
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 50,
                         BottomViewHeight: 30,
                         topViewColor: .black,
                         bottomViewColor: .black)
                    .frame(width: width)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
                    .offset(x: 0, y: -10)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 50,
                         BottomViewHeight: 30,
                         topViewColor: .black,
                         bottomViewColor: .black)
                    .frame(width: width)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: width,
                           height: height + height * manager.volume)
                    .offset(x: 0, y: 10)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 50,
                         BottomViewHeight: 30,
                         topViewColor: .green,
                         bottomViewColor: .yellow)
                    .frame(width: width)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 50,
                         BottomViewHeight: 30,
                         topViewColor: .red,
                         bottomViewColor: .green,
                         margin: 0)
                    .frame(width: width)
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: width,
                           height: height + height * manager.volume)
            }
            Group {
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: width,
                           height: height + height * manager.volume)
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: width,
                           height: height + height * manager.volume)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 50,
                         BottomViewHeight: 30,
                         topViewColor: .red,
                         bottomViewColor: .green)
                    .frame(width: width)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 50,
                         BottomViewHeight: 30,
                         topViewColor: .black,
                         bottomViewColor: .black)
                    .frame(width: width)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
                    .offset(x: 0, y: -10)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 50,
                         BottomViewHeight: 30,
                         topViewColor: .black,
                         bottomViewColor: .black)
                    .frame(width: width)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: width,
                           height: height + height * manager.volume)
            }
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

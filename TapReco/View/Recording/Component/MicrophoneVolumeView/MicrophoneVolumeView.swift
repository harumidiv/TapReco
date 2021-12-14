//
//  MicrophoneVolumeView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/07.
//

import SwiftUI

struct MicrophoneVolumeView: View {
    let width: CGFloat = 4
    let padding: CGFloat = 6
    let weight: CGFloat = 2
    @StateObject private var manager = MicrophoneLebelManager()
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Group {
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 45,
                         topViewColor: Color("tp_dark_gray"),
                         bottomViewColor: Color("tp_dark_gray"),
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: -2)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(45 + (45 * manager.volume) * weight))
                    .padding(padding)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(30 + (30 * manager.volume) * weight))
                    .padding(padding)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(20 + (20 * manager.volume) * weight))
                    .offset(x: 0, y: -10.0)
                    .padding(padding)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 32,
                         topViewColor: Color("tp_dark_gray"),
                         bottomViewColor: Color("tp_dark_gray"),
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: -2)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(45 + (45 * manager.volume) * weight))
                    .padding(padding)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_yellow"))
                    .frame(width: width,
                           height: abs(30 + (30 * manager.volume) * weight))
                    .offset(y: 11)
                    .padding(padding)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 20,
                         BottomViewHeight: 20,
                         topViewColor: Color("tp_green"),
                         bottomViewColor: Color("tp_yellow"),
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 7)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 45,
                         topViewColor: Color("tp_red"),
                         bottomViewColor: Color("tp_green"),
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 7)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_green"))
                    .frame(width: width,
                           height: abs(45 + (45 * manager.volume) * weight))
                    .padding(padding)
            }
            Group {
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_yellow"))
                    .frame(width: width,
                           height: abs(30 + (30 * manager.volume) * weight))
                    .padding(padding)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_yellow"))
                    .frame(width: width,
                           height: abs(20 + (20 * manager.volume) * weight))
                    .padding(padding)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 45,
                         topViewColor: Color("tp_red"),
                         bottomViewColor: Color("tp_green"),
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 2)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(35 + (35 * manager.volume) * weight))
                    .padding(padding)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 22,
                         topViewColor: Color("tp_dark_gray"),
                         bottomViewColor: Color("tp_dark_gray"),
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 6)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(20 + (20 * manager.volume) * weight))
                    .offset(y: -10)
                    .padding(padding)
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 33,
                         topViewColor: Color("tp_dark_gray"),
                         bottomViewColor: Color("tp_dark_gray"),
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 3)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(37 + (37 * manager.volume) * weight))
                    .padding(padding)
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(Color("tp_dark_gray"))
                    .frame(width: width,
                           height: abs(30 + (30 * manager.volume) * weight))
                    .padding(padding)
            }
        }
        .onAppear() {
            // 遅延を追加しなしとHaptic HeedBackが発火しない
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                manager.startUpdatingVolume()
            }
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

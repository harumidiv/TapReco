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
                // １
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 45,
                         topViewColor: AppColor.iconGray,
                         bottomViewColor: AppColor.iconGray,
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: -2)
                // 2
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.iconGray)
                    .frame(width: width,
                           height: abs(45 + (45 * manager.volume) * weight))
                    .padding(padding)
                // 3
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.iconGray)
                    .frame(width: width,
                           height: abs(30 + (30 * manager.volume) * weight))
                    .padding(padding)
                // 4
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusOK)
                    .frame(width: width,
                           height: abs(20 + (20 * manager.volume) * weight))
                    .offset(x: 0, y: -10.0)
                    .padding(padding)

                //5
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 32,
                         topViewColor: AppColor.statusError,
                         bottomViewColor: AppColor.statusOK,
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: -2)
                // 6
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusError)
                    .frame(width: width,
                           height: abs(45 + (45 * manager.volume) * weight))
                    .padding(padding)
                // 7
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusOK)
                    .frame(width: width,
                           height: abs(30 + (30 * manager.volume) * weight))
                    .offset(y: 11)
                    .padding(padding)
                // 8
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 20,
                         BottomViewHeight: 20,
                         topViewColor: AppColor.statusText,
                         bottomViewColor: AppColor.statusOK,
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 7)
                // 9
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 45,
                         topViewColor: AppColor.statusError,
                         bottomViewColor: AppColor.statusText,
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 7)
                // 10
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusText)
                    .frame(width: width,
                           height: abs(45 + (45 * manager.volume) * weight))
                    .padding(padding)
            }
            Group {
                // 11
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusOK)
                    .frame(width: width,
                           height: abs(30 + (30 * manager.volume) * weight))
                    .padding(padding)
                // 12
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusOK)
                    .frame(width: width,
                           height: abs(20 + (20 * manager.volume) * weight))
                    .padding(padding)
                // 13
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 45,
                         topViewColor: AppColor.statusError,
                         bottomViewColor: AppColor.statusText,
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 2)
                // 14
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusOK)
                    .frame(width: width,
                           height: abs(35 + (35 * manager.volume) * weight))
                    .padding(padding)
                // 15
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 22,
                         topViewColor: AppColor.statusOK,
                         bottomViewColor: AppColor.statusError,
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 6)
                // 16
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.statusError)
                    .frame(width: width,
                           height: abs(20 + (20 * manager.volume) * weight))
                    .offset(y: -10)
                    .padding(padding)
                // 17
                WaveView(manager: manager,
                         width: width,
                         topViewHeight: 30,
                         BottomViewHeight: 33,
                         topViewColor: AppColor.iconGray,
                         bottomViewColor: AppColor.iconGray,
                         weight: weight)
                    .frame(width: width)
                    .padding(padding)
                    .offset(y: 3)
                // 18
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.iconGray)
                    .frame(width: width,
                           height: abs(37 + (37 * manager.volume) * weight))
                    .padding(padding)
                // 19
                RoundedRectangle(cornerRadius: width / 2)
                    .foregroundColor(AppColor.iconGray)
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
            .preferredColorScheme(.dark)
    }
}

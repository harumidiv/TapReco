//
//  MicrophoneVolumeRightView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/12.
//

import SwiftUI

struct MicrophoneVolumeRightView: View {
    @ObservedObject var manager: MicrophoneLebelManager
    let width: CGFloat
    let padding: CGFloat
    let weight: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            // 11
            RoundedRectangle(cornerRadius: width / 2)
                .foregroundColor(AppColor.statusOK)
                .frame(width: width,
                       height: calculateHeight(value: 30))
                .padding(padding)
            // 12
            RoundedRectangle(cornerRadius: width / 2)
                .foregroundColor(AppColor.statusOK)
                .frame(width: width,
                       height: calculateHeight(value: 20))
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
                       height: calculateHeight(value: 35))
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
                       height: calculateHeight(value: 20))
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
                       height: calculateHeight(value: 37))
                .padding(padding)
            // 19
            RoundedRectangle(cornerRadius: width / 2)
                .foregroundColor(AppColor.iconGray)
                .frame(width: width,
                       height: calculateHeight(value: 30))
                .padding(padding)
        }
    }
    func calculateHeight(value: Double) -> Double {
        abs(value + (value * manager.volume) * weight)
    }
}

struct MicrophoneVolumeRightView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneVolumeRightView(manager: MicrophoneLebelManager(),
                                  width: 4,
                                  padding: 6,
                                  weight: 2)
    }
}

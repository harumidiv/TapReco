//
//  MicrophoneVolumeLeftView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/12.
//

import SwiftUI

struct MicrophoneVolumeLeftView: View {
    @ObservedObject var manager: MicrophoneLebelManager
    let width: CGFloat
    let padding: CGFloat
    let weight: CGFloat

    var body: some View {
        HStack(spacing: 0) {
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
                       height: calculateHeight(value: 45))
                .padding(padding)
            // 3
            RoundedRectangle(cornerRadius: width / 2)
                .foregroundColor(AppColor.iconGray)
                .frame(width: width,
                       height: calculateHeight(value: 30))
                .padding(padding)
            // 4
            RoundedRectangle(cornerRadius: width / 2)
                .foregroundColor(AppColor.statusOK)
                .frame(width: width,
                       height: calculateHeight(value: 20))
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
                       height: calculateHeight(value: 45))
                .padding(padding)
            // 7
            RoundedRectangle(cornerRadius: width / 2)
                .foregroundColor(AppColor.statusOK)
                .frame(width: width,
                       height: calculateHeight(value: 30))
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
                       height: calculateHeight(value: 45))
                .padding(padding)
        }
    }

    func calculateHeight(value: Double) -> Double {
        abs(value + (value * manager.volume) * weight)
    }
}

struct MicrophoneVolumeLeftView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneVolumeLeftView(manager: MicrophoneLebelManager(), width: 4, padding: 6, weight: 2)
    }
}

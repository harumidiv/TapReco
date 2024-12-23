//
//  SelectView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/11.
//

import SwiftUI

enum SelectType: String {
    case date = "日付"
    case recordTime = "録音時間"
    case fileSize = "ファイルサイズ"
}

struct SelectView: View {
    let isSelected: Bool
    let selectType: SelectType
    let selectHandler: ()->Void

    var body: some View {
        Button(action: {
            selectHandler()
        }) {
            if isSelected {
                Label(selectType.rawValue, image: "radio_on")
                    .foregroundColor(AppColor.textLightGray)
            } else {
                Label(selectType.rawValue, image: "radio_off")
                    .foregroundColor(AppColor.textLightGray)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            SelectView(isSelected: true,
                       selectType: .date,
                       selectHandler: {})
            SelectView(isSelected: false,
                       selectType: .recordTime,
                       selectHandler: {})
        }
        .preferredColorScheme(.light)

        VStack(alignment: .leading) {
            SelectView(isSelected: true,
                       selectType: .date,
                       selectHandler: {})
            SelectView(isSelected: false,
                       selectType: .recordTime,
                       selectHandler: {})
        }
        .preferredColorScheme(.dark)
    }
}

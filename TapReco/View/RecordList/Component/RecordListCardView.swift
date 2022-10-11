//
//  RecordListCardView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import SwiftUI


struct RecordListCardView: View {
    var record: RecordData
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading){
                Text(record.title)
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColor.textLightGray)
                Text(record.recordDate)
                    .font(Font.system(size: 13, weight: .semibold))
                    .foregroundColor(AppColor.textGray)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text(record.recordTime)
                    .font(Font.system(size: 15, weight: .medium))
                    .foregroundColor(AppColor.textLightGray)
                Text(record.fileSize)
                    .font(Font.system(size: 13, weight: .regular))
                    .foregroundColor(AppColor.textGray)
            }
            Button(action: {
                // TODO 編集用のダイアログを開けるようにする共通のやつを使う　https://qiita.com/motokiohkubo/items/26a6cd23a301c61b1138
            }) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(Font.system(size: 24, weight: .bold))
                    .frame(width: 28, height: 28)
                    .foregroundColor(AppColor.textGray)
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(8)

    }
}

struct RecordListCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxGray)
            .fixedSize(horizontal: false, vertical: true)
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxBlack)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .preferredColorScheme(.light)

        VStack {
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxGray)
            .fixedSize(horizontal: false, vertical: true)
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxBlack)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

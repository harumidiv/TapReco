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
                    .font(.title2)
                    .foregroundColor(AppColor.textLightGray)
                Text(record.recordDate)
                    .font(.caption)
                    .foregroundColor(AppColor.textGray)
            }
            Spacer()
            VStack(alignment: .trailing){
                Text(record.recordTime)
                    .font(.body)
                    .foregroundColor(AppColor.textLightGray)
                Text(record.fileSize)
                    .font(.caption)
                    .foregroundColor(AppColor.textGray)
            }
            Button(action: {

            }) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(Font.system(size: 24, weight: .bold))
                    .frame(width: 35, height: 35)
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

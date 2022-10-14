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
    let editAction: (_ id: UUID)->Void
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2){
                    Text(record.title)
                        .font(Font.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColor.textLightGray)
                    Text(record.recordDate)
                        .font(Font.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColor.textGray)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2){
                    Text(record.recordTime)
                        .font(Font.system(size: 15, weight: .medium))
                        .foregroundColor(AppColor.textLightGray)
                    Text(record.fileSize)
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundColor(AppColor.textGray)
                }
                Button(action: {
                    editAction(record.id)
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
}

struct RecordListCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxGray,
                               editAction: {id in})
            .fixedSize(horizontal: false, vertical: true)
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxBlack,
                               editAction: {id in})
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .preferredColorScheme(.light)

        VStack {
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxGray,
                               editAction: {id in})
            .fixedSize(horizontal: false, vertical: true)
            RecordListCardView(record: RecordData.sampleData[0],
                               backgroundColor: AppColor.boxBlack,
                               editAction: {id in})
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

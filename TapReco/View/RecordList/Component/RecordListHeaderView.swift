//
//  RecordListHeaderView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/08.
//

import SwiftUI

struct RecordListHeaderView: View {
    @Binding var isShowRecordList: Bool
    @Binding var records: [RecordData]

    @Binding var searchText: String
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("録音履歴")
                    .font(.largeTitle)
                    .foregroundColor(AppColor.textLightGray)
                Spacer()
                Button(action: {
                    records = records.compactMap{ .init(record: $0, isSelected: false)}
                    isShowRecordList = false
                }){
                    Image(systemName: "xmark")
                        .font(Font.system(size: 24, weight: .bold))
                        .foregroundColor(AppColor.textLightGray)
                }
            }
            .padding(.horizontal, 30)
            HStack {
                Image(systemName: "doc")
                    .foregroundColor(AppColor.iconGray)
                Text("\(records.count)")
                    .foregroundColor(AppColor.textGray)
                Spacer()
                Button(action: {
                    // sortの処理
                }){
                    Image(systemName: "slider.horizontal.3")
                        .font(Font.system(size: 24, weight: .regular))
                        .foregroundColor(AppColor.iconGray)
                }
            }
            .padding(.horizontal, 30)
            SearchBarView(text: $searchText)
        }
    }
}

struct RecordListSectionHeadaerView_Previews: PreviewProvider {
    static var previews: some View {
            RecordListHeaderView(isShowRecordList: .constant(false),
                                 records: .constant(RecordData.sampleData),
                                 searchText: .constant(""))
                .fixedSize(horizontal: false, vertical: true)
                .preferredColorScheme(.light)
            RecordListHeaderView(isShowRecordList: .constant(false),
                                 records: .constant(RecordData.sampleData),
                                 searchText: .constant("hogehoge"))
                .fixedSize(horizontal: false, vertical: true)
                .preferredColorScheme(.dark)
    }
}

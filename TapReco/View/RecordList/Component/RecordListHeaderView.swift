//
//  RecordListHeaderView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/08.
//

import SwiftUI

struct RecordListHeaderView: View {
    @Binding var isShowRecordList: Bool
    @Binding var isShowSortView: Bool
    var displayRecords: [RecordData]
    @Binding var searchText: String
    var closeAction: ()->Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("録音履歴")
                    .font(Font.system(size: 22, weight: .bold))
                Spacer()
                Button(action: {
                    closeAction()
                }){
                    Image(systemName:"xmark")
                        .font(Font.system(size: 24, weight: .regular))
                        .foregroundColor(AppColor.iconGray)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)

            HStack {
                Image(systemName: "doc")
                    .foregroundColor(AppColor.iconGray)
                Text("\(displayRecords.count)")
                    .foregroundColor(AppColor.textGray)
                Spacer()
                Button(action: {
                    isShowSortView = true
                }){
                    Image(systemName: "slider.horizontal.3")
                        .font(Font.system(size: 24, weight: .regular))
                        .foregroundColor(AppColor.iconGray)
                }
            }
            .padding(.horizontal, 24)

            SearchBarView(text: $searchText)
                .cornerRadius(16)
                .padding()
        }
        .padding(.top, 14)
    }
}

struct RecordListSectionHeadaerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListHeaderView(isShowRecordList: .constant(false),
                             isShowSortView: .constant(false),
                             displayRecords: RecordData.sampleData,
                             searchText: .constant(""),
                             closeAction: {})
        .fixedSize(horizontal: false, vertical: true)
        .preferredColorScheme(.light)
        .background(.purple)
        RecordListHeaderView(isShowRecordList: .constant(false),
                             isShowSortView: .constant(false),
                             displayRecords: RecordData.sampleData,
                             searchText: .constant("hogehoge"),
                             closeAction: {})
        .fixedSize(horizontal: false, vertical: true)
        .preferredColorScheme(.dark)
    }
}

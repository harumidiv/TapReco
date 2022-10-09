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

    @State var searchText: String = ""
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("録音履歴")
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    records = records.compactMap{ .init(record: $0, isSelected: false)}
                    isShowRecordList = false
                }){
                    Image("icon_close")
                }
            }
            .padding(.horizontal, 30)
            HStack {
                Text("録音ファイル数 \(records.count)")
                Spacer()
                Button(action: {
                    // 何の処理が走る？
                }){
                    Image("pull_down")
                }
            }
            .padding(.horizontal, 30)

            TextField("検索", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.init(top: 0, leading: 24, bottom: 20, trailing: 24))
        }
    }
}

struct RecordListSectionHeadaerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListHeaderView(isShowRecordList: .constant(false), records: .constant(RecordData.sampleData))
            .background(.orange)
            .fixedSize(horizontal: false, vertical: true)
    }
}

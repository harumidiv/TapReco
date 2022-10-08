//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI

struct RecordListView: View {
    @Binding var isShowRecordList: Bool
    @Binding var records: [RecordData]
    
    var body: some View {
        VStack(spacing: 0) {
            RecordListHeaderView(isPresentedRecordListView: $isShowRecordList,
                                 records: $records)
                .background(Color.yellow)
            List {
                ForEach($records) { $record in
                    if record.isSelected {
                        RecordCardPlayView(record: $record)
                    } else {
                        Button(action: {
                            setSelectedState(record: record)
                        }){
                            RecordListCardView(record: $record)
                        }
                        .listRowBackground(Color.green)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
    }
}

private extension RecordListView {
    // 対象のセルを選択状態にする
    func setSelectedState(record: RecordData) {
        self.records = records.compactMap{
            if $0.id == record.id {
                return RecordData(title: $0.title,
                                  recordDate: $0.recordDate,
                                  fileName: $0.fileName,
                                  fileSize: $0.fileSize,
                                  fileLength: $0.fileLength,
                                  isSelected: true)
            } else {
                return RecordData(title: $0.title,
                                  recordDate: $0.recordDate,
                                  fileName: $0.fileName,
                                  fileSize: $0.fileSize,
                                  fileLength: $0.fileLength,
                                  isSelected: false)
            }
        }
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(isShowRecordList: .constant(false), records: .constant(RecordData.sampleData))
    }
}

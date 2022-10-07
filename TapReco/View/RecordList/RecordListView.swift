//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI
import RealmSwift

struct RecordListView: View {
    @Binding var isShowRecordList: Bool
    @Binding var records: [RecordData]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RecordListHeaderView(isPresentedRecordListView: $isShowRecordList)
                    .background(Color.yellow)
                List {
                    ForEach(records) { record in
                        if record.isSelected {
                            RecordListPlayCell(viewModel: .init(title: record.title,
                                                                recordDate: record.recordDate,
                                                                fileLength: record.fileLength,
                                                                fileSize: record.fileSize,
                                                                fileName: record.fileName))
                            .listRowBackground(Color.red)
                        } else {
                            
                            Button(action: {
                                setSelectedState(record: record)
                            }){
                                RecordListCellView(viewModel: .init(title: record.title,
                                                                    recordDate: record.recordDate,
                                                                    fileLength: record.fileLength,
                                                                    fileSize: record.fileSize))
                            }
                            .listRowBackground(Color.green)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
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

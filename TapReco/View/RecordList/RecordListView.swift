//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI

struct RecordListView: View {
    let saveAction: ()->Void
    @Binding var isShowRecordList: Bool
    @Binding var records: [RecordData]

    private var selectedIndex: Int {
        records.firstIndex(where: { $0.isSelected })!
    }

    private var playRecord: RecordData {
        records[selectedIndex]
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RecordListHeaderView(isShowRecordList: $isShowRecordList,
                                     records: $records)
                List {
                    ForEach($records) { $record in
                        if record.isSelected {
                            RecordListCardView(record: $record,backgroundColor: AppColor.boxBlack)
                                .listRowBackground(AppColor.background)
                        } else {
                            Button(action: {
                                setSelectedState(record: record)
                            }){
                                RecordListCardView(record: $record, backgroundColor: AppColor.boxGray)
                            }
                            .listRowBackground(AppColor.background)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }

            if records.contains(where: { $0.isSelected == true }) {
                VStack(spacing: 0) {
                    Spacer()
                    RecordListPlayerView(saveAction: saveAction,
                                         records: $records,
                                         audioPlayer: AudioPlayerImpl(fileName: playRecord.fileName))
                }
                .ignoresSafeArea(edges: [.top])
            }
        }
        .background(AppColor.background)
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
        RecordListView(saveAction: {},
                       isShowRecordList: .constant(false),
                       records: .constant(RecordData.sampleData))
    }
}

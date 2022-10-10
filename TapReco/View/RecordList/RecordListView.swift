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
    @StateObject var audioPlayer: AudioPlayer = AudioPlayer()

    @State private var searchText: String = ""

    private var displyList: [RecordData] {
        if searchText.isEmpty { return records }
        return records.filter{ $0.title.contains(searchText)}
    }

    private var selectedIndex: Int {
        records.firstIndex(where: { $0.isSelected })!
    }

    private var playRecord: RecordData {
        print("fileNems: \(records[selectedIndex].fileName)")
        return records[selectedIndex]
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RecordListHeaderView(isShowRecordList: $isShowRecordList,
                                     records: $records,
                                     searchText: $searchText)
                List {
                    ForEach(displyList) { record in
                        if record.isSelected {
                            RecordListCardView(record: record,backgroundColor: AppColor.boxBlack)
                                .listRowBackground(AppColor.background)
                        } else {
                            Button(action: {
                                setSelectedState(selectRecord: record)
                                audioPlayer.setup(fileName: playRecord.fileName)
                            }){
                                RecordListCardView(record: record, backgroundColor: AppColor.boxGray)
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
                                         audioPlayer: audioPlayer)
                }
                .ignoresSafeArea(edges: [.top])
            }
        }
        .background(AppColor.background)
    }
}

private extension RecordListView {
    // 対象のセルを選択状態にする
    func setSelectedState(selectRecord: RecordData) {
        self.records = records.compactMap{
            let isSelected = $0.id == selectRecord.id
            return RecordData(record: $0, isSelected: isSelected)
        }
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(saveAction: {},
                       isShowRecordList: .constant(false),
                       records: .constant(RecordData.sampleData))
            .preferredColorScheme(.light)
        RecordListView(saveAction: {},
                       isShowRecordList: .constant(false),
                       records: .constant(RecordData.sampleData))
            .preferredColorScheme(.dark)
    }
}

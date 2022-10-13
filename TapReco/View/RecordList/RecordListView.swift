//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI

struct RecordListView: View {
    // MARK: Augument
    let saveAction: ()->Void
    @Binding var isShowRecordList: Bool
    @Binding var records: [RecordData]
    
    // MARK: - Property
    @StateObject var audioPlayer: AudioPlayer = AudioPlayer()
    @State private var isPlaying: Bool = false
    @State private var searchText: String = ""
    @State private var sortType: SortType = .dateNew
    @State private var isShowSortView: Bool = false

    @State private var displayRecords: [RecordData] = []

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RecordListHeaderView(isShowRecordList: $isShowRecordList,
                                     isShowSortView: $isShowSortView,
                                     displayRecords: displayRecords,
                                     searchText: $searchText) {
                    if displayRecords.contains(where: { $0.isSelected == true }) {
                        audioPlayer.playStop()
                    }
                    isShowRecordList = false
                }
                List {
                    ForEach(displayRecords) { record in
                        if record.isSelected {
                            RecordListCardView(record: record,
                                               backgroundColor: AppColor.boxBlack,
                                               editComplete: {title,id in
                                updateTitle(title: title, id: id)
                            })
                            .listRowBackground(AppColor.background)
                        } else {
                            Button(action: {
                                setSelectedState(selectRecord: record)
                                isPlaying = true
                                audioPlayer.setup(fileName: record.fileName)
                            }){
                                RecordListCardView(record: record,
                                                   backgroundColor: AppColor.boxGray,
                                                   editComplete: {title,id in
                                    updateTitle(title: title, id: id)
                                })
                            }
                            .listRowBackground(AppColor.background)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
            }
            .blur(radius: isShowSortView ? 2.0 : 0.0)
            
            if displayRecords.contains(where: { $0.isSelected == true }) {
                VStack(spacing: 0) {
                    Spacer()
                    RecordListPlayerView(saveAction: saveAction,
                                         isPlaying: $isPlaying,
                                         record: $displayRecords.filter{$0.isSelected.wrappedValue == true}.first!,
                                         audioPlayer: audioPlayer){record in
                        audioPlayer.playStop()
                        let selectedIndex = records.firstIndex(where: { $0.id == record.id })!
                        // 大元のデータを削除してデータ更新をかける
                        records.remove(at: selectedIndex)
                        saveAction()
                    }
                }
                .ignoresSafeArea(edges: [.top])
                .blur(radius: isShowSortView ? 2.0 : 0.0)
            }
            
            if isShowSortView {
                SortView(isShowSortView: $isShowSortView, sortType: $sortType)
            }
        }
        .background(AppColor.background)
        .onAppear{
            displayRecords = getDisplayRecord()
        }
    }
}

private extension RecordListView {
    func getDisplayRecord() -> [RecordData] {
        func stringToInt(text: String) -> Int64 {
            let splitNumber = (text.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
            return Int64(splitNumber.joined())!
        }

        let sortRrcord: [RecordData]
        switch sortType {
        case .dateNew:
            sortRrcord = records.sorted(by: { lRecord, rRecord -> Bool in
                return stringToInt(text: lRecord.recordDate) > stringToInt(text: rRecord.recordDate)
            })
        case .dateOld:
            sortRrcord = records.sorted(by: { lRecord, rRecord -> Bool in
                return stringToInt(text: lRecord.recordDate) < stringToInt(text: rRecord.recordDate)
            })
        case .recordTimeLong:
            sortRrcord = records.sorted(by: { lRecord, rRecord -> Bool in
                return stringToInt(text: lRecord.recordTime) > stringToInt(text: rRecord.recordTime)
            })
        case .recordTimeShort:
            sortRrcord = records.sorted(by: { lRecord, rRecord -> Bool in
                return stringToInt(text: lRecord.recordTime) < stringToInt(text: rRecord.recordTime)
            })

        case .fileSizeLarge:
            sortRrcord = records.sorted(by: { lRecord, rRecord -> Bool in
                return stringToInt(text: lRecord.fileSize) > stringToInt(text: rRecord.fileSize)
            })

        case .fileSizeSmall:
            sortRrcord = records.sorted(by: { lRecord, rRecord -> Bool in
                return stringToInt(text: lRecord.fileSize) < stringToInt(text: rRecord.fileSize)
            })
        }

        if searchText.isEmpty { return sortRrcord }
        return sortRrcord.filter{ $0.title.contains(searchText)}
    }

    func updateTitle(title: String, id: UUID) {
        self.records = records.compactMap{
            if $0.id != id { return $0 }
            return .init(record: $0, editTitle: title)
        }
        saveAction()
    }
    
    // 対象のセルを選択状態にする
    func setSelectedState(selectRecord: RecordData) {
        self.displayRecords = displayRecords.compactMap{
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

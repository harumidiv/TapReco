//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI
import RealmSwift

struct RecordListView: View {
    struct ViewModel {
        var recordList: [RecordData]
    }
    struct RecordData {
        let title: String
        let recordDate: String
        let fileName:String
        let fileSize: String
        let fileLength: String
        var isSelected: Bool = false
    }
    
    @State private var viewModel: ViewModel?
    @Binding var isPresentedRecordListView: Bool
    
    var body: some View {
        ZStack {
            if let viewModel = viewModel {
                VStack(spacing: 0) {
                    RecordListHeaderView(isPresentedRecordListView: $isPresentedRecordListView)
                        .background(Color.yellow)
                    List {
                        ForEach(0..<viewModel.recordList.count) { index in
                            if viewModel.recordList[index].isSelected {
                                let record = viewModel.recordList[index]
                                RecordListPlayCell(viewModel: .init(title: record.title,
                                                                    recordDate: record.recordDate,
                                                                    fileLength: record.fileLength,
                                                                    fileSize: record.fileSize,
                                                                    fileName: record.fileName))
                                    .listRowBackground(Color.yellow)
                                
                                // TODO再生できるようにする
//                                audioPlayer.playStart(fileName: viewModel.recordList[index].fileName)
                                
                            } else {
                                Button(action: {
                                    // すでに選択済みのセルを元の状態に戻す
                                    viewModel.recordList.indices.forEach { self.viewModel?.recordList[$0].isSelected = false }
                                    self.viewModel?.recordList[index].isSelected = true
                                }){
                                    let vm = viewModel.recordList[index]
                                    RecordListCellView(viewModel: .init(title: vm.title,
                                                                        recordDate: vm.recordDate,
                                                                        fileLength: vm.fileLength,
                                                                        fileSize: vm.fileSize))
                                }
                                .listRowBackground(Color.yellow)
                            }
                        }
                    }
                    
                    .listStyle(PlainListStyle())
                }
            } else {
                // TODO インジケータと読み込み中の形のレイアウトを作成する
                Text("loading中")
            }
        }
        .onAppear{
            fetchRecordList()
        }
    }
    
    private func fetchRecordList() {
        
        let realm = try! Realm()
        let results = realm.objects(RecordingInfo.self)
        print(results)
        let recordList: [RecordData] = results.compactMap{
            return RecordData(title: $0.title,
                              recordDate: $0.dateText,
                              fileName: $0.fileName,
                              fileSize: $0.fileSize,
                              fileLength: $0.playTime)
        }
        
        self.viewModel = .init(recordList: recordList)
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(isPresentedRecordListView: .constant(false))
    }
}

//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI

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
    
    @StateObject private var audioPlayer = AudioPlayerImpl()
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
                                RecordListPlayCell()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                fetchRecordList()
            }
            print("onAppear")
        }
    }
    
    private func fetchRecordList() {
        let documentPath = NSHomeDirectory() + "/Documents"
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: documentPath) else {
            return
        }
        
        let recordList: [RecordData] = fileNames.compactMap{
            return RecordData(title: $0,
                              recordDate: "2月3日 23:57",
                              fileName: $0,
                              fileSize: "3.5MB",
                              fileLength: "03:05")
        }
        
        self.viewModel = .init(recordList: recordList)
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(isPresentedRecordListView: .constant(false))
    }
}

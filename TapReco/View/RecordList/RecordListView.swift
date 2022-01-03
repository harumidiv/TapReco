//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI

struct RecordListView: View {
    @StateObject private var audioPlayer = AudioPlayerImpl()
    @Binding var isPresentedRecordListView: Bool
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                RecordListHeaderView(isPresentedRecordListView: $isPresentedRecordListView)
                List {
                    ForEach(0..<recordList().count) { index in
                        Button(action: {
                            audioPlayer.playStart(fileName: recordList()[index])
                        }){
                            RecordListCellView(viewModel: .init(title: recordList()[index]))
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    private func recordList() -> [String] {
        let documentPath = NSHomeDirectory() + "/Documents"
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: documentPath) else {
            return []
        }
        
        return fileNames
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(isPresentedRecordListView: .constant(false))
    }
}

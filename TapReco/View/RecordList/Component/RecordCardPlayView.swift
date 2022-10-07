//
//  RecordListPlayCell.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/01/19.
//

import SwiftUI

struct RecordCardPlayView: View {
    struct ViewModel {
        let title: String
        let recordDate: String
        let fileLength: String
        let fileSize: String
        let fileName: String
        
    }
    
    let viewModel: ViewModel
    
    @State private var currentValue: Double = 0.3
    @StateObject private var audioPlayer = AudioPlayerImpl()
    
    var body: some View {
        ZStack {
            VStack {
                RecordCardView(viewModel: .init(title: viewModel.title,
                                                    recordDate: viewModel.recordDate,
                                                    fileLength: viewModel.fileLength,
                                                    fileSize: viewModel.fileSize))
                Slider(value: $currentValue,
                       in: 0...1)
                HStack{
                    Image("prev_fifteen")
                        .onTapGesture {
                            print("15秒前に戻る処理")
                        }
                    Image("play_icon")
                        .onTapGesture {
                            print("再生停止処理: \(viewModel.fileName)")
                            audioPlayer.playStart(fileName: viewModel.fileName)
                        }
                    Image("after_fifteen")
                        .onTapGesture {
                            print("15秒先に進む処理")
                        }
                }
            }
        }
    }
}

struct RecordListPlayCell_Previews: PreviewProvider {
    static var previews: some View {
        RecordCardPlayView(viewModel: .init(title: "title",
                                            recordDate: "date",
                                            fileLength: "length",
                                            fileSize: "size",
                                            fileName: "fileName"))
    }
}

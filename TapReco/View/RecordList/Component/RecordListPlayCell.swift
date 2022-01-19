//
//  RecordListPlayCell.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/01/19.
//

import SwiftUI

struct RecordListPlayCell: View {
    @State private var currentValue: Double = 0.3
    
    var body: some View {
        ZStack {
//            Color.yellow
//                .ignoresSafeArea()
            VStack {
                RecordListCellView(viewModel: .init(title: "title",
                                                    recordDate: "recordData",
                                                    fileLength: "fileLength",
                                                    fileSize: "fileSize"))
                Slider(value: $currentValue,
                       in: 0...1)
                HStack{
                    Image("prev_fifteen")
                        .onTapGesture {
                            print("15秒前に戻る処理")
                        }
                    Image("play_icon")
                        .onTapGesture {
                            print("再生停止処理")
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
        RecordListPlayCell()
    }
}

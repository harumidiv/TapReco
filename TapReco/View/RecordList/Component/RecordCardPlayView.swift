//
//  RecordListPlayCell.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/01/19.
//

import SwiftUI

struct RecordCardPlayView: View {
    @Binding var record: RecordData
    
    @State private var currentValue: Double = 0.3
    private let audioPlayer = AudioPlayerImpl()
    
    var body: some View {
        ZStack {
            VStack {
                RecordCardView(record: $record)
                Slider(value: $currentValue,
                       in: 0...1)
                HStack{
                    Image("prev_fifteen")
                        .onTapGesture {
                            print("15秒前に戻る処理")
                        }
                    Image("play_icon")
                        .onTapGesture {
                            print("再生停止処理: \(record.fileName)")
                            audioPlayer.playStart(fileName: record.fileName)
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
        RecordCardPlayView(record: .constant(RecordData.sampleData[0]))
            .background(.red)
            .fixedSize(horizontal: false, vertical: true)
    }
}

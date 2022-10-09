//
//  RecordListPlayerView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/09.
//

import SwiftUI

struct RecordListPlayerView: View {
    let saveAction: ()->Void
    @Binding var records: [RecordData]
    @State private var currentValue: Double = 0.3
    @State private var isShowActivityView: Bool = false

    private let audioPlayer = AudioPlayerImpl()


    private var selectedIndex: Int {
        records.firstIndex(where: { $0.isSelected })!
    }

    private var playRecord: RecordData {
        records[selectedIndex]
    }

    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 1)
            Slider(value: $currentValue,
                   in: 0...1)
            HStack {
                Text("01:00")
                    .font(.caption)
                Spacer()
                Text(("36:44"))
                    .font(.caption)
            }
            .padding(.horizontal, 30)


            HStack{
                Image(systemName: "square.and.arrow.up")
                    .onTapGesture {
                        isShowActivityView = true
                    }
                    .sheet(isPresented: $isShowActivityView) {
                        ActivityViewController(activityItems: [])
                    }
                Spacer()
                Image("prev_fifteen")
                    .onTapGesture {
                        print("15秒前に戻る処理")
                    }
                Image("play_icon")
                    .onTapGesture {
                        print("再生ボタンタップ")
                        audioPlayer.playStart(fileName: records[0].fileName)
                    }
                Image("after_fifteen")
                    .onTapGesture {
                        print("15秒先に進む処理")
                    }
                Spacer()
                Image(systemName: "trash")
                    .onTapGesture {
                        records.remove(at: selectedIndex)
                        saveAction()
                    }
            }
            .padding(.horizontal, 30)
        }
        .background(.green)
    }
}

struct RecordListPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListPlayerView(saveAction: {}, records: .constant(RecordData.sampleData))
    }
}

//
//  RecordListPlayerView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/09.
//

import SwiftUI

struct RecordListPlayerView: View {
    // MARK: - Argument
    let saveAction: ()->Void
    @Binding var records: [RecordData]

    // MARK: - Property
    @State private var currentValue: Double = 0.3
    @State private var isShowActivityView: Bool = false
    @State private var isPlaying: Bool = true

    @Environment(\.scenePhase) private var scenePhase
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
                        audioPlayer.rewindFifteenSeconds()
                        print("15秒前に戻る処理")
                    }
                ZStack {
                    // 再生停止が切り替わると画像サイズが違いでがたつくので固定している
                    Rectangle()
                        .fill(.clear)
                        .frame(width:60, height: 60)
                    if isPlaying {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 50, weight: .light))
                            .onTapGesture {
                                print("停止ボタンタップ")
                                isPlaying.toggle()
                                audioPlayer.playStop()
                            }
                    } else {
                        Image(systemName: "play.fill")
                            .font(.system(size: 50, weight: .light))
                            .onTapGesture {
                                print("再生ボタンタップ")
                                isPlaying.toggle()
                                audioPlayer.reStart(fileName: playRecord.fileName)
                            }
                    }
                }
                Image("after_fifteen")
                    .onTapGesture {
                        print("15秒先に進む処理")
                        if audioPlayer.skipFifteenSeconds() {
                            isPlaying = false
                        }
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
        .onAppear {
            print("Viewが描画された")
            audioPlayer.playStart(fileName: playRecord.fileName)
        }
    }
}

struct RecordListPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListPlayerView(saveAction: {}, records: .constant(RecordData.sampleData))
    }
}

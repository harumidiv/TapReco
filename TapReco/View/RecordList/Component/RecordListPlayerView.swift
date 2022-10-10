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
    @ObservedObject var audioPlayer: AudioPlayerImpl

    // MARK: - Property
    @State private var currentValue: Double = 0
    @State private var isShowActivityView: Bool = false
    @State private var isPlaying: Bool = true

    @Environment(\.scenePhase) private var scenePhase

    private var selectedIndex: Int {
        records.firstIndex(where: { $0.isSelected })!
    }

    private var playRecord: RecordData {
        records[selectedIndex]
    }

    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(AppColor.iconGray)
                .frame(height: 1)
            Slider(value: $audioPlayer.displayTime,
                   in: 0.0...audioPlayer.duration)
            .onReceive(audioPlayer.timer) { _ in
                audioPlayer.displayTime = audioPlayer.currentTime
                audioPlayer.displayCurrentTime = convertTimeToDisplayString(time: audioPlayer.currentTime)
                let timeLeft = audioPlayer.duration - audioPlayer.currentTime
                audioPlayer.displaytimeLeft = convertTimeToDisplayString(time: timeLeft)
            }
            HStack {
                Text(audioPlayer.displayCurrentTime)
                    .foregroundColor(AppColor.textLightGray)
                    .font(.caption)
                Spacer()
                Text(audioPlayer.displaytimeLeft)
                    .foregroundColor(AppColor.textLightGray)
                    .font(.caption)
            }
            .padding(.horizontal, 30)

            HStack{
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        isShowActivityView = true
                    }
                    .sheet(isPresented: $isShowActivityView) {
                        ActivityViewController(activityItems: [])
                    }
                Spacer()
                Image(systemName: "gobackward.15")
                    .font(Font.system(size: 24, weight: .regular))
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        audioPlayer.rewindFifteenSeconds()
                        print("15秒前に戻る処理")
                    }
                StartStopView(isPlaying: $isPlaying, audioPlayer: audioPlayer)
                Image(systemName: "goforward.15")
                    .font(Font.system(size: 24, weight: .regular))
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        print("15秒先に進む処理")
                        if audioPlayer.skipFifteenSeconds() {
                            isPlaying = false
                        }
                    }
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        records.remove(at: selectedIndex)
                        saveAction()
                    }
            }
            .padding(.horizontal, 30)
        }
        .background(AppColor.background)
    }

    private func convertTimeToDisplayString(time: Double) -> String {
        let time = Int(time)
        let minute = time / 60
        let seconds = time % 60

        return "\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
    }
}

struct RecordListPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListPlayerView(saveAction: {},
                             records: .constant(RecordData.sampleData),
                             audioPlayer: AudioPlayerImpl())
    }
}

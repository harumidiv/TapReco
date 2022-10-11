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
    @ObservedObject var audioPlayer: AudioPlayer

    // MARK: - Property
    @State private var currentValue: Double = 0
    @State private var isShowActivityView: Bool = false
    @State private var isPlaying: Bool = true
    @State var isSliderChanged: Bool = false

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
                .padding(.bottom)
            Slider(value: $audioPlayer.displayTime,
                   in: 0.0...audioPlayer.duration, onEditingChanged: {isChanging in
                self.isSliderChanged = isChanging
                isChanging ? audioPlayer.changeSliderValue() : audioPlayer.stopSliderValue()
                isPlaying = !isChanging
            })
            .accentColor(AppColor.iconLightGray)
            .padding(.horizontal)
            .onReceive(audioPlayer.timer) { _ in
                if !isSliderChanged {
                    audioPlayer.displayTime = audioPlayer.currentTime
                } else {
                    audioPlayer.setCurrentTime(time: audioPlayer.displayTime)
                }
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
                        audioPlayer.playStop()
                        isShowActivityView = true
                        isPlaying = false
                    }
                    .sheet(isPresented: $isShowActivityView) {
                        let recordFileURL: URL = audioPlayer.getURL(fileName: playRecord.fileName)
                        ActivityViewController(activityItems: [recordFileURL])
                    }
                Spacer()
                Image(systemName: "gobackward.15")
                    .font(Font.system(size: 24, weight: .regular))
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        isPlaying = true
                        audioPlayer.rewindFifteenSeconds()
                    }
                StartStopView(isPlaying: $isPlaying, audioPlayer: audioPlayer)
                Image(systemName: "goforward.15")
                    .font(Font.system(size: 24, weight: .regular))
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        isPlaying = true
                        if audioPlayer.skipFifteenSeconds() {
                            // 末尾まできていたらストップする
                            isPlaying = false
                            audioPlayer.setCurrentTime(time: 0)
                        }
                    }
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        audioPlayer.playStop()
                        records.remove(at: selectedIndex)
                        saveAction()
                    }
            }
            .padding(.horizontal, 30)
        }
        .background(AppColor.background)
        .onAppear {
            audioPlayer.playComplete = {
                isPlaying.toggle()
            }
        }
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
                             audioPlayer: AudioPlayer())
    }
}

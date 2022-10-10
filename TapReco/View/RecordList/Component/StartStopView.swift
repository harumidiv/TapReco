//
//  StartStopView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/09.
//

import SwiftUI

struct StartStopView: View {
    @Binding var isPlaying: Bool
    @ObservedObject var audioPlayer: AudioPlayer

    var body: some View {
        ZStack {
            // 再生停止が切り替わると画像サイズが違いでがたつくので固定している
            Rectangle()
                .fill(.clear)
                .frame(width:60, height: 60)
            if isPlaying {
                Image(systemName: "stop.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        print("停止ボタンタップ")
                        isPlaying.toggle()
                        audioPlayer.playStop()
                    }
            } else {
                Image(systemName: "play.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColor.iconLightGray)
                    .onTapGesture {
                        print("再生ボタンタップ")
                        isPlaying.toggle()
                        audioPlayer.reStart()
                    }
            }
        }
    }
}

struct StartStopView_Previews: PreviewProvider {
    static var previews: some View {
        StartStopView(isPlaying: .constant(true), audioPlayer: AudioPlayer())
    }
}

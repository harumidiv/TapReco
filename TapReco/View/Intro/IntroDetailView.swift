//
//  IntroDetailView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/08.
//

import SwiftUI

struct IntroDetailView: View {
    let title: String
    let image: String
    let subTitle: String
    let description: String
    let needDisplayButton: Bool

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Image("")
                .resizable()
                .frame(width: 250, height: 250)
                .background(.red)
            VStack {
                HStack {
                    Text(subTitle)
                        .font(.headline)
                    Spacer()
                }
                Text(description)
                    .font(.caption)
            }
            .padding(.horizontal)

            if needDisplayButton {
                Button("Taprecoをはじめる", action: {})
                    .padding()
            }
        }
    }
}

struct IntroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // ボタン表示あり
        IntroDetailView(title: "Taprecoでできること", image: "", subTitle: "ワンタッチですぐ録音", description: "録音ボタンが大きいからポケットの中でも感覚的に録音を始められます。停止ボタンはスライド式だから、操作ミスはありません。あなたの使い方次第で、防犯や音声メモ、可能性は無限大 !", needDisplayButton: true)
        // ボタン表示なし
        IntroDetailView(title: "Taprecoでできること", image: "", subTitle: "ワンタッチですぐ録音", description: "録音ボタンが大きいからポケットの中でも感覚的に録音を始められます。停止ボタンはスライド式だから、操作ミスはありません。あなたの使い方次第で、防犯や音声メモ、可能性は無限大 !", needDisplayButton: false)
    }
}

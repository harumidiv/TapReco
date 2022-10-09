//
//  IntroView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/08.
//

import SwiftUI

struct IntroView: View {
    @Binding var isShowIntoView: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .ignoresSafeArea()
                // 背景にあるViewをタップできなくする
                .contentShape(Rectangle())
                
            VStack {
                TabView {
                    IntroDetailView(title: "Taprecoでできること",
                                    image: "",
                                    subTitle: "ワンタッチですぐ録音",
                                    description: "録音ボタンが大きいからポケットの中でも感覚的に録音を始められます。停止ボタンはスライド式だから、操作ミスはありません。あなたの使い方次第で、防犯や音声メモ、可能性は無限大 !",
                                    needDisplayButton: false,
                                    isShowIntoView: $isShowIntoView)
                    IntroDetailView(title: "Taprecoでできること",
                                    image: "",
                                    subTitle: "ワンタッチですぐ録音",
                                    description: "",
                                    needDisplayButton: true,
                                    isShowIntoView: $isShowIntoView)
                }
                .tabViewStyle(PageTabViewStyle.init(indexDisplayMode: .always))
                .background(Color.green)
                .edgesIgnoringSafeArea(.all)
            }
            .cornerRadius(16)
            .padding()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(isShowIntoView: .constant(true))
    }
}
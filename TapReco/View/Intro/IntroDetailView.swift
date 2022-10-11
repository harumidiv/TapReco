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
    let description: String
    let needDisplayButton: Bool

    @Binding var isShowIntoView: Bool

    var body: some View {
        VStack(spacing: 0) {
            Image("intro_title")
                .padding(.horizontal, 43)
                .padding(.top, 46)
            Image(image)
                .padding(40)

            if needDisplayButton {
                Button("Taprecoをはじめる", action: {
                    UserStrage.isNeedDisplayIntro = false
                    isShowIntoView = false
                })
                .padding()
            } else {
                VStack(spacing: 6) {
                    Text(title)
                        .font(Font.system(size: 20, weight: .bold))
                    Text(description)
                        .font(Font.system(size: 14, weight: .regular))
                }
                .padding(.horizontal)
            }
            Spacer()
        }
    }
}

struct IntroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // ボタン表示あり
        IntroDetailView(title: "ワンタッチですぐ録音",
                        image: "intro_01",
                        description: "画面全体が録音開始ボタンです!",
                        needDisplayButton: false,
                        isShowIntoView: .constant(true))
        // ボタン表示なし
        IntroDetailView(title: "Taprecoでできること",
                        image: "intro_02",
                        description: "ワンタッチですぐ録音!", needDisplayButton: false,
                        isShowIntoView: .constant(true))
    }
}

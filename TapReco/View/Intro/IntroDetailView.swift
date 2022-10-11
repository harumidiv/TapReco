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
                .padding(.top, 40)

            if needDisplayButton {
                Button(action: {
                    UserStrage.isNeedDisplayIntro = false
                    isShowIntoView = false
                }) {
                    ZStack {
                        Text("たぷれこを始める！")
                            .font(Font.system(size: 16, weight: .bold))
                            .foregroundColor(AppColor.introWhite)
                    }

                }
                .frame(width: 288, height: 44)
                .background(AppColor.introBlack)
                .cornerRadius(6)
                .padding(.top, 70)
            } else {
                VStack(spacing: 6) {
                    Text(title)
                        .font(Font.system(size: 20, weight: .bold))
                        .foregroundColor(AppColor.introBlack)
                    Text(description)
                        .font(Font.system(size: 14, weight: .regular))
                        .foregroundColor(AppColor.introBlack)
                }
                .padding(.top, 40)
                .padding(.horizontal)
            }
            Spacer()
        }
    }
}

struct IntroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // ボタン表示ありなし
        IntroDetailView(title: "ワンタッチですぐ録音",
                        image: "intro_01",
                        description: "画面全体が録音開始ボタンです!",
                        needDisplayButton: false,
                        isShowIntoView: .constant(true))
        // ボタン表示あり
        IntroDetailView(title: "",
                        image: "intro_03",
                        description: "",
                        needDisplayButton: true,
                        isShowIntoView: .constant(true))
    }
}

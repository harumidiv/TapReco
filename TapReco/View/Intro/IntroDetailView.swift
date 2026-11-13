//
//  IntroDetailView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/08.
//

import SwiftUI

struct IntroDetailView: View {
    let title: LocalizedStringKey
    let image: String
    let description: LocalizedStringKey
    let needDisplayButton: Bool

    @Binding var isShowIntoView: Bool
    @Environment(\.locale) private var locale

    var body: some View {
        VStack(spacing: 0) {
            Group {
                if locale.identifier.hasPrefix("ja") {
                    Image("intro_title")
                } else {
                    HStack(alignment: .top) {
                        Text("たぷれこ")
                            .font(.system(size: 34, weight: .heavy))
                        Spacer()
                        Text(verbatim: "• • •")
                            .foregroundColor(.red)
                    }
                    .foregroundColor(AppColor.introBlack)
                    .frame(width: 238.5, height: 50.743286, alignment: .topLeading)
                }
            }
            .padding(.horizontal, 43)
            .padding(.top, 46)
            Group {
                if image == "intro_03" && !locale.identifier.hasPrefix("ja") {
                    localizedSummary
                } else {
                    Image(image)
                }
            }
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .font(Font.system(size: 20, weight: .bold))
                        .foregroundColor(AppColor.introBlack)
                    Text(description)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: 14, weight: .regular))
                        .foregroundColor(AppColor.introBlack)

                }
                .padding(.top, 40)
                .padding(.horizontal)
            }
            Spacer()
        }
    }

    private var localizedSummary: some View {
        VStack(spacing: 22) {
            summaryRow("1", title: "画面を見ずに録音できる！", detail: "緊急時でもすぐに録音できます。")
            summaryRow("2", title: "ミスのない録音停止ボタン", detail: "ポケットの中でも誤って録音停止しません。")
        }
        .frame(width: 255, height: 190)
    }

    private func summaryRow(_ number: String, title: LocalizedStringKey, detail: LocalizedStringKey) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(verbatim: number)
                .font(.system(size: 80, weight: .regular))
                .frame(width: 45)
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.system(size: 14, weight: .bold))
                Text(detail).font(.system(size: 14)).foregroundColor(.gray)
            }
            .lineLimit(3)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(AppColor.introBlack)
        .frame(height: 84)
    }
}

struct IntroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // ボタン表示ありなし
        IntroDetailView(title: "ワンタッチですぐ録音",
                        image: "intro_01",
                        description: "画面全体が録音開始ボタンです!\n2行目テスト",
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

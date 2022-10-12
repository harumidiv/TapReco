//
//  IntroView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/08.
//

import SwiftUI

struct IntroView: View {
    @Binding var isShowIntoView: Bool

    init(isShowIntoView: Binding<Bool>) {
        self._isShowIntoView = isShowIntoView
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "intro_black")
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(named: "intro_light_gray")
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(AppColor.background)
                .ignoresSafeArea()
                // 背景にあるViewをタップできなくする
                .contentShape(Rectangle())
                
            VStack(spacing: 0) {
                TabView {
                    IntroDetailView(title: "ワンタッチですぐ録音!",
                                    image: "intro_01",
                                    description: "画面全体が録音開始ボタンです",
                                    needDisplayButton: false,
                                    isShowIntoView: $isShowIntoView)
                    IntroDetailView(title: "ミスのない録音停止ボタン",
                                    image: "intro_02",
                                    description: "ミスタッチがないように、\n録音停止ボタンはスライド式!",
                                    needDisplayButton: false,
                                    isShowIntoView: $isShowIntoView)
                    IntroDetailView(title: "",
                                    image: "intro_03",
                                    description: "",
                                    needDisplayButton: true,
                                    isShowIntoView: $isShowIntoView)
                }
                .frame(height: 570)
                .tabViewStyle(PageTabViewStyle.init(indexDisplayMode: .always))
                .background(AppColor.introWhite)
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

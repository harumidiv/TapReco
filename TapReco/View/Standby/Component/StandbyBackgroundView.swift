//
//  StandbyBackgroundView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/07.
//

import SwiftUI

struct StandbyBackgroundView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(AppColor.background)
                .ignoresSafeArea()
            Image("wakusen")
                .resizable()
                .scaledToFill()
                // 画面比率が異なる端末(iPhone Duoなど)で画像が画面外まで広がらないよう画面サイズに収める
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .cornerRadius(16)
                .padding()
                .opacity(0.4)
            VStack(spacing: 18) {
                Image("icon_microphone")
                Image("description")
            }
        }
    }
}

struct StandbyBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyBackgroundView()
            .preferredColorScheme(.light)
        StandbyBackgroundView()
            .preferredColorScheme(.dark)
    }
}

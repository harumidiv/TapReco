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
                .cornerRadius(16)
                .padding()
            VStack(spacing: 18) {
                Image("icon_microphone")
                Text("タップして録音開始")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.textLightGray)
            }
        }
    }
}

struct StandbyBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyBackgroundView()
    }
}

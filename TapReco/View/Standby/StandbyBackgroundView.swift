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
                .foregroundColor(Color("tp_gray"))
                .ignoresSafeArea()
            Image("wakusen")
                .resizable()
                .scaledToFill()
        }
    }
}

struct StandbyBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyBackgroundView()
    }
}

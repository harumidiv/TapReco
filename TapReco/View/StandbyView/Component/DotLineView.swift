//
//  DotLineView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/14.
//

import SwiftUI

struct DotLineView: View {
    var body: some View {
        ZStack {
            // TODO 画像を差し替える
            Image("home")
                .resizable()
                .frame(width: .infinity, height: .infinity, alignment: .center)
                .ignoresSafeArea()
            VStack {
                Image("sample")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                Text("画面をタップして録音開始")
            }
        }
    }
}

struct DotLineView_Previews: PreviewProvider {
    static var previews: some View {
        DotLineView()
    }
}


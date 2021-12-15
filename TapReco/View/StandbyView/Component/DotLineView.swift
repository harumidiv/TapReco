//
//  DotLineView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/14.
//

import SwiftUI

struct DotLineView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // TODO 画像を差し替える
                Image("wakusen")
                    .resizable()
                    .frame(width:  geometry.size.width, height:  geometry.size.height, alignment: .center)
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
}

struct DotLineView_Previews: PreviewProvider {
    static var previews: some View {
        DotLineView()
    }
}


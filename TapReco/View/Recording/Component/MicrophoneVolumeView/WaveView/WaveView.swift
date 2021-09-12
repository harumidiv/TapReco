//
//  WaveView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/08.
//

import SwiftUI

struct WaveView: View {
    @ObservedObject var manager: MicrophoneLebelManager
    
    let width: CGFloat
    let topViewHeight: CGFloat
    let BottomViewHeight: CGFloat
    let topViewColor: Color
    let bottomViewColor: Color
    let weight: CGFloat
    
    private let margin: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            let halfHeiht = geometry.size.height / 2
            RoundedRectangle(cornerRadius: width / 2)
                .frame(width: width,
                       height: abs(topViewHeight + (topViewHeight * manager.volume) * weight))
                .foregroundColor(topViewColor)
                .offset(x: 0,
                        y: halfHeiht - margin - topViewHeight - (topViewHeight * manager.volume) * weight)
            RoundedRectangle(cornerRadius: width / 2)
                .frame(width: width,
                       height: abs(BottomViewHeight + (BottomViewHeight * manager.volume) * weight))
                .foregroundColor(bottomViewColor)
                .offset(x: 0,
                        y: halfHeiht + margin)
        }
    }
}

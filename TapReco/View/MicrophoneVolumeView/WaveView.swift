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
    
    var margin: CGFloat = 5
    
    var body: some View {
        GeometryReader { geometry in
            let halfHeiht = geometry.size.height / 2
            
            Rectangle()
                .frame(width: width,
                       height: topViewHeight + (topViewHeight * manager.volume))
                .foregroundColor(.red)
                .offset(x: 0,
                        y: halfHeiht - margin - topViewHeight - (topViewHeight * manager.volume))
            Rectangle()
                .frame(width: width,
                       height: BottomViewHeight + (BottomViewHeight * manager.volume))
                .foregroundColor(.blue)
                .offset(x: 0,
                        y: halfHeiht + margin)
        }
    }
}

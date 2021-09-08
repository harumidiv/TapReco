//
//  WaveView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/08.
//

import SwiftUI

struct WaveView: View {
    @ObservedObject var manager: MicrophoneLebelManager
    
    let topViewHeight: CGFloat
    let BottomViewHeight: CGFloat
    
    private let margin: CGFloat = 5
    
    var body: some View {
        GeometryReader { geometry in
            let halfWidth = geometry.size.width / 2
            let halfHeiht = geometry.size.height / 2
            
            Rectangle()
                .frame(width: 10, height: topViewHeight + (topViewHeight * manager.volume))
                .foregroundColor(.red)
                .offset(x: halfWidth,
                        y: halfHeiht - margin - topViewHeight - (topViewHeight * manager.volume))
            Rectangle()
                .frame(width: 10, height: BottomViewHeight + (BottomViewHeight * manager.volume))
                .foregroundColor(.blue)
                .offset(x: halfWidth,
                        y: halfHeiht + margin)
        }
    }
}

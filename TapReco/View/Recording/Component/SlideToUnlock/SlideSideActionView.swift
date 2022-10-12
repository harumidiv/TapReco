//
//  SlideSideActionView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/08.
//

import UIKit
import SwiftUI

struct SlideSideActionView: UIViewRepresentable {
    @Binding var isRecording: Bool
    @Binding var isShowSnackBar: Bool
    @ObservedObject var timerHolder: TimerHolder
    
    func makeUIView(context: UIViewRepresentableContext<SlideSideActionView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let slideToActionView = SlideToActionView()
        slideToActionView.slideDidComplete = {
            timerHolder.stop()
            withAnimation() {
                isRecording = false
                isShowSnackBar = true
            }
            Task {
                // 2秒後にスナックバーを消す
                try await Task.sleep(nanoseconds: 2_000_000_000)
                isShowSnackBar = false
            }
        }
        
        
        slideToActionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slideToActionView)
        
        NSLayoutConstraint.activate([
            slideToActionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            slideToActionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

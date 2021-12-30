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
    @ObservedObject var timerHolder: TimerHolder
    
    func makeUIView(context: UIViewRepresentableContext<SlideSideActionView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let slideToActionView = SlideToActionView()
        slideToActionView.slideDidComplete = {
            timerHolder.stop()
            isRecording = false
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

//
//  SlideUPActionView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/30.
//

import UIKit
import SwiftUI

struct SlideUPActionView: UIViewRepresentable {
    @Binding var isPresentedRecordListView: Bool
    func makeUIView(context: UIViewRepresentableContext<SlideUPActionView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let slideToActionView = SlideToUPUnlockView()
        slideToActionView.slideDidComplete = {
            isPresentedRecordListView = true
            slideToActionView.resetDragPoint()
        }
        
        slideToActionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slideToActionView)
        
        NSLayoutConstraint.activate([
            slideToActionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            slideToActionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

//
//  SlideToStopActionView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/08.
//

import UIKit
import SwiftUI

struct SlideToStopActionView: UIViewRepresentable {
    var completion: () -> Void
    
    func makeUIView(context: UIViewRepresentableContext<SlideToStopActionView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let slideToActionView = SlideToActionView()
        slideToActionView.slideDidComplete = { () -> Void in
            completion()
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

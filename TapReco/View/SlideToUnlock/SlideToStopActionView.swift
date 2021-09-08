//
//  SlideToStopActionView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/08.
//

import UIKit
import SwiftUI

struct SlideToStopActionView: UIViewRepresentable {
    var slideToActionView = SlideToActionView()
    var completion: () -> Void
    
    func makeUIView(context: UIViewRepresentableContext<SlideToStopActionView>) -> UIView {
        let view = UIView(frame: .zero)
        
        slideToActionView.slideDidComplete = { () -> Void in
            completion()
        }
        
        // TODO ここを外で設定された値を引っ張ってきてcornerRadiusを設定したい
        let cornerRadius: CGFloat = 25

        slideToActionView.backgroundView.layer.cornerRadius = cornerRadius
        slideToActionView.dragAreaView.layer.cornerRadius = cornerRadius
        slideToActionView.thumnailImageView.layer.cornerRadius = cornerRadius
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

//
//  LottieAnimationView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/07.
//

import SwiftUI
import Lottie

struct LottieAnimationView: UIViewRepresentable {
    func makeUIView(context: Context) -> AnimationView {
        let view = AnimationView(name: "microphone", bundle: Bundle.main)
        view.isUserInteractionEnabled = false
        view.loopMode = .loop
        view.play { (status) in
            if status {
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                }
            }
        }

        return view
    }

    func updateUIView(_ uiView: AnimationView, context: Context) {
    }
}

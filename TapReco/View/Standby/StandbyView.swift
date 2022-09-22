//
//  StandbyView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI
import AVFoundation

struct StandbyView: View {
    @Binding var isRecording: Bool
    @ObservedObject var presenter = StandbyPresenterImpl()
    
    private let topMargin: CGFloat = 55
    private let bottomMargin: CGFloat = 32
    private let sideMargin: CGFloat = 28
    
    var body: some View {
        ZStack {
            // 背景色用のView
            Rectangle()
                .foregroundColor(Color("tp_gray"))
                .ignoresSafeArea()
            
            ZStack {
                // タップ領域用のView
                Rectangle()
                    .foregroundColor(Color("tp_gray"))
                    .onTapGesture {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.prepare()
                        impactHeavy.impactOccurred()
                        
                        if !presenter.isAutholized {
                            presenter.apply(inputs: .didTapRecording)
                            return
                        }
                        
                        isRecording = true
                    }
                    .alert(isPresented: $presenter.isShowAlertDialog,
                           content: presenter.alertBuilder)
                ZStack {
                    // TODO ここを上下のSafeArea以外の箇所までMaxで表示できるようにする
                    Image("wakusen")
                        .resizable()
                        .scaledToFill()
                    VStack(spacing: 18) {
                        Image("icon_microphone")
                        Text("タップして録音開始")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .onTapGesture {}
                .allowsHitTesting(false)
                
                GeometryReader { geometry in
                    let buttonHeight: CGFloat = 86
                    let buttonWidth: CGFloat = 205
                    let bottomMargin: CGFloat = 74
                    SlideUPActionView(isPresentedRecordListView: $presenter.isShowRecordList)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height - (bottomMargin + buttonHeight / 2))
                        .fullScreenCover(isPresented: $presenter.isShowRecordList) {
                            RecordListView(isPresentedRecordListView: $presenter.isShowRecordList)
                        }
                }
            }
        }
    }
}

struct StandbyView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyView(isRecording: .constant(false))
    }
}


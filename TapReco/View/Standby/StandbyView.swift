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
    
    private let topMargin: CGFloat = 50
    private let bottomMargin: CGFloat = 32
    private let sideMargin: CGFloat = 28
    
    var body: some View {
        let dotLineWidth = UIScreen.main.bounds.width - sideMargin * 2
        let dotLineHeight = UIScreen.main.bounds.height - (topMargin + bottomMargin)
        
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .foregroundColor(Color("tp_gray"))
                .gesture(LongPressGesture().onChanged { _ in
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.prepare()
                    impactHeavy.impactOccurred()
                    
                    if !presenter.isAutholized {
                        presenter.apply(inputs: .didTapRecording)
                        return
                    }
                    
                    isRecording = true
                })
                .ignoresSafeArea()
                .alert(isPresented: $presenter.isShowAlertDialog, content: presenter.alertBuilder)
            
            ZStack {
                Image("wakusen")
                    .resizable()
                    .frame(width: dotLineWidth, height: dotLineHeight, alignment: .center)
                    .padding(EdgeInsets(top: topMargin, leading: sideMargin, bottom: bottomMargin, trailing: sideMargin))
                VStack(spacing: 38) {
                    Image("icon_microphone")
                    Text("画面をタップして録音開始")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture {}
            .allowsHitTesting(false)
            
            GeometryReader { geometry in
                let buttonHeight: CGFloat = 86
                let buttonWidth: CGFloat = 205
                let bottomMargin: CGFloat = 74
                SlideUPActionView(isPresentedRecordListView: $presenter.isShowRecordList)
                    .frame(width: 204, height: 84)
                    .position(x: geometry.size.width / 2,
                              y: geometry.size.height - (bottomMargin + buttonHeight / 2))
                    .fullScreenCover(isPresented: $presenter.isShowRecordList) {
                        RecordListView(isPresentedRecordListView: $presenter.isShowRecordList)
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


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
    
    @StateObject private var audioRecorder = AudioRecorderImpl()
    
    private let topMargin: CGFloat = 16
    private let bottomMargin: CGFloat = 8
    private let sideMargin: CGFloat = 8
    
    @ObservedObject var presenter = StandbyPresenterImpl()
    
    var body: some View {
        let dotLineWidth = UIScreen.main.bounds.width - sideMargin * 2
        let dotLineHeight = UIScreen.main.bounds.height * 0.8 - (topMargin + bottomMargin)
        
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
        
        VStack(spacing: 0) {
            DotLineView()
                .frame(width: dotLineWidth, height: dotLineHeight, alignment: .center)
                .padding(EdgeInsets(top: topMargin, leading: sideMargin, bottom: bottomMargin, trailing: sideMargin))
                .onTapGesture {}
                .allowsHitTesting(false)
            //TODO ボタンを差し替える
            Button(action: {
                // TODO SlideToUnlockが解除されたタイミングでフラグを切り替える
                presenter.apply(inputs: .didTapRecordListButton)
            }){
                Text("TODO スライドボタンに置き換える")
                    .frame(width: dotLineWidth, height: UIScreen.main.bounds.height * 0.19, alignment: .center)
                    .border(Color.red, width: 1)
            }
            
            .fullScreenCover(isPresented: $presenter.isShowRecordList) {
                RecordListView(isPresentedRecordListView: $presenter.isShowRecordList)
            }
        }
        .onChange(of: isRecording) { isRecording in
            if isRecording {
                let queue = DispatchQueue.global(qos: .userInitiated)
                queue.async {
                    audioRecorder.recordStart()
                    TimerHolder().start()
                }
                
            } else {
                audioRecorder.recordStop()
            }
        }
    }
}

struct StandbyView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyView(isRecording: .constant(false))
    }
}


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

    var body: some View {
        ZStack {
            StandbyBackgroundView()
            StandbyTapableView{
                if !presenter.isAutholized {
                    presenter.apply(inputs: .didTapRecording)
                    return
                }

                isRecording = true
            }
            .alert(isPresented: $presenter.isShowAlertDialog,
                   content: presenter.alertBuilder)

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

struct StandbyView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyView(isRecording: .constant(false))
    }
}


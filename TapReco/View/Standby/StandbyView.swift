//
//  StandbyView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI
import AVFoundation

struct StandbyView: View {
    let saveAction: ()->Void
    @Binding var records: [RecordData]
    @Binding var isRecording: Bool
    @State var isShowRecordList = false
    @State var isShowAlertDialog = false

    // TODO 音声を制御するクラスが持っておいた方が良さそう
    var isAutholized: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)

        switch status {
        case .authorized:
            return true
        default:
            return false
        }
    }

    var body: some View {
        ZStack {
            StandbyBackgroundView()
            StandbyTapableView {
                if isAutholized {
                    isRecording = true
                } else {
                    isShowAlertDialog = true
                }
            }
            .alert(isPresented: $isShowAlertDialog, content: alertBuilder)

            GeometryReader { geometry in
                let buttonHeight: CGFloat = 100
                let buttonWidth: CGFloat = 240
                let bottomMargin: CGFloat = 74
                if records.count > 0 {

                    SlideUPActionView(isPresentedRecordListView: $isShowRecordList)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height - (bottomMargin + buttonHeight / 2))
                        .fullScreenCover(isPresented: $isShowRecordList) {
                            RecordListView(saveAction: saveAction, isShowRecordList: $isShowRecordList, records: $records)
                        }
                } else {
                    SlideUPActionView(isPresentedRecordListView: $isShowRecordList)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height - (bottomMargin + buttonHeight / 2))
                        .opacity(0.5)
                        .disabled(true)
                }
            }
        }
    }
}

    extension StandbyView {
        func alertBuilder() -> Alert {
            return Alert(
                title: Text("マイクへのアクセス許可がありません"),
                message: Text("[設定]に移動して、権限を許可してください"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .default(Text("設定"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }))
        }
    }

    struct StandbyView_Previews: PreviewProvider {
        static var previews: some View {
            StandbyView(saveAction: {}, records: .constant(RecordData.sampleData),
                        isRecording: .constant(false))
            .preferredColorScheme(.light)

            StandbyView(saveAction: {}, records: .constant(RecordData.sampleData),
                        isRecording: .constant(false))
            .preferredColorScheme(.dark)
        }
    }


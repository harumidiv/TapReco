//
//  StandbyView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/09.
//

import SwiftUI
import AVFoundation

struct StandbyView: View {
    // MARK: - Augumenet
    let saveAction: ()->Void
    @Binding var records: [RecordData]
    @Binding var isRecording: Bool
    
    // Property
    @State var isShowRecordList = false
    @State var isShowAlertDialog = false
    @State var isShowEditView = false
    
    private var isAutholized: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        return status == .authorized
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
            
            VStack {
                Spacer()
                let buttonHeight: CGFloat = 100
                let buttonWidth: CGFloat = 240
                let bottomMargin: CGFloat = 100
                SlideUPActionView(isPresentedRecordListView: $isShowRecordList)
                    .frame(width: buttonWidth, height: buttonHeight)
                    .padding(.bottom, bottomMargin)
                    .opacity(records.isEmpty ? 0.5 : 1.0)
                    .disabled(records.isEmpty)
                    .fullScreenCover(isPresented: $isShowRecordList) {
                        RecordListView(saveAction: saveAction, isShowRecordList: $isShowRecordList, records: $records)
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


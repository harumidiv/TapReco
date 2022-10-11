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

            VStack {
                Spacer()
                let buttonHeight: CGFloat = 100
                let buttonWidth: CGFloat = 240
                let bottomMargin: CGFloat = 100
                if records.count > 0 {

                    SlideUPActionView(isPresentedRecordListView: $isShowRecordList)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .padding(.bottom, bottomMargin)
                        .fullScreenCover(isPresented: $isShowRecordList) {
                            NavigationView {
                                RecordListView(saveAction: saveAction, isShowRecordList: $isShowRecordList, records: $records)
                                    .navigationTitle("録音履歴")
                                    .toolbar {
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button(action: {
                                                isShowRecordList = false
                                            }, label: {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(AppColor.textLightGray)
                                            })
                                        }
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button(action: {
                                                isShowEditView = true
                                            }, label: {
                                                Text("Edit")
                                                    .foregroundColor(AppColor.textLightGray)
                                            })
                                            .sheet(isPresented: $isShowEditView) {
                                                NavigationView {
                                                    EditView()
                                                        .toolbar {
                                                            ToolbarItem(placement: .navigationBarTrailing) {
                                                                Button(action: {
                                                                    isShowEditView = false
                                                                }, label: {
                                                                    Image(systemName: "xmark")
                                                                        .foregroundColor(AppColor.textLightGray)
                                                                })
                                                            }
                                                        }
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                } else {
                    SlideUPActionView(isPresentedRecordListView: $isShowRecordList)
                        .frame(width: buttonWidth, height: buttonHeight)
                        .padding(.bottom, bottomMargin)
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


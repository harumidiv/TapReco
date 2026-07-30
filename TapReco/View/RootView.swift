//
//  RootView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI

struct RootView: View {
    // MARK: - Augument
    @Binding var records: [RecordData]
    let saveAction: ()->Void

    // MARK: - Property
    @StateObject private var audioRecorder = AudioRecorderImpl()
    @State private var isRecording: Bool = false
    @State private var isShowSuccessSnackBar = false
    @State private var isShowFailureSnackBar = false
    // UserDefaultの値を参照して出すかのフラグの値が入るようにする
    @State private var isShowIntoView: Bool = UserStrage.isNeedDisplayIntro

    var body: some View {
        ZStack {
            if isRecording {
                RecordingView(isRecording: $isRecording,
                              isShowSuccessSnackBar: $isShowSuccessSnackBar)
                .defersSystemGestures(on: .bottom)
            } else {
                StandbyView(saveAction: saveAction,
                            records: $records,
                            isRecording: $isRecording)
                .blur(radius: isShowIntoView ? 2.0 : 0.0)
                if isShowIntoView {
                    IntroView(isShowIntoView: $isShowIntoView)
                }
            }
        }
        .popup(isPresented: isShowSuccessSnackBar,
                content: SnackBarSuccessView.init)
        .popup(isPresented: isShowFailureSnackBar,
               content: SnackBarFailureView.init)
        .onChange(of: isRecording) { newValue in
            if newValue {
                do {
                    try audioRecorder.recordStart()
                } catch {
                    isRecording = false
                    showFailureSnackBar()
                }
            } else {
                guard let newRecord = audioRecorder.recordStop() else { return }
                records.append(newRecord)
                saveAction()
            }
        }
        .onChange(of: audioRecorder.isInterruptedNonResumably) { interrupted in
            guard interrupted else { return }
            // ファイルを削除してから isRecording = false にする。
            // recordStop() が nil を返すため壊れたレコードは一覧に追加されない。
            audioRecorder.recordCancel()
            isRecording = false
            showFailureSnackBar()
        }
    }

    private func showFailureSnackBar() {
        isShowFailureSnackBar = true
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            isShowFailureSnackBar = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(records: .constant(RecordData.sampleData), saveAction: {})
    }
}

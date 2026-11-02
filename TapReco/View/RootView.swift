//
//  RootView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import SwiftUI
import AVFoundation

struct RootView: View {
    // MARK: - Augument
    @Binding var records: [RecordData]
    let saveAction: ()->Void

    // MARK: - Property
    @ObservedObject private var recordingController = RecordingController.shared
    @State private var isShowSuccessSnackBar = false
    @State private var isShowFailureSnackBar = false
    @State private var handledRecordingRequestID: UUID?
    // UserDefaultの値を参照して出すかのフラグの値が入るようにする
    @State private var isShowIntoView: Bool = UserStrage.isNeedDisplayIntro

    var body: some View {
        ZStack {
            if recordingController.isRecording {
                RecordingView(isRecording: isRecording,
                              isShowSuccessSnackBar: $isShowSuccessSnackBar)
                .defersSystemGestures(on: .bottom)
            } else {
                StandbyView(saveAction: saveAction,
                            records: $records,
                            isRecording: isRecording)
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
        .onReceive(recordingController.failures) { failure in
            guard case .interrupted = failure else { return }
            showFailureSnackBar()
        }
        .onAppear {
            handleRecordingRequest(recordingController.startRequestID)
        }
        .onChange(of: recordingController.startRequestID) { requestID in
            handleRecordingRequest(requestID)
        }
    }

    private func handleRecordingRequest(_ requestID: UUID?) {
        guard let requestID,
              requestID != handledRecordingRequestID,
              !recordingController.isRecording else { return }
        handledRecordingRequestID = requestID

        Task { @MainActor in
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized:
                startRecording()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .audio) {
                    startRecording()
                } else {
                    showFailureSnackBar()
                }
            case .denied, .restricted:
                showFailureSnackBar()
            @unknown default:
                showFailureSnackBar()
            }
        }
    }

    // 子Viewからは従来どおりBindingで録音の開始・停止を行う
    private var isRecording: Binding<Bool> {
        Binding(
            get: { recordingController.isRecording },
            set: { newValue in
                if newValue {
                    startRecording()
                } else {
                    recordingController.stop()
                }
            }
        )
    }

    private func startRecording() {
        do {
            try recordingController.start()
        } catch {
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
        RootView(records: .constant(RecordData.sampleData),
                 saveAction: {})
    }
}

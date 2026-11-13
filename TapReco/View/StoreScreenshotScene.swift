#if DEBUG
import SwiftUI
import AVFoundation

/// Deterministic fixtures used only by the store artwork capture test.
struct StoreScreenshotScene: View {
    let scene: String
    @State private var showShare = false

    private var records: [RecordData] {
        zip(["00:07", "00:02", "00:05"], ["1.4 MB", "409 KB", "1.1 MB"]).enumerated().map { index, entry in
            RecordData(title: NSLocalizedString("新規作成", comment: ""),
                       recordDate: ["2026.11.13_09:41", "2026.11.12_20:05", "2026.11.11_01:19"][index],
                       fileName: "TapReco-sample.wav", fileSize: entry.1, recordTime: entry.0)
        }
    }

    var body: some View {
        Group {
            switch scene {
            case "recording":
                RecordingView(isRecording: .constant(true), isShowSuccessSnackBar: .constant(false))
            case "list", "share":
                RecordListView(saveAction: {}, isShowRecordList: .constant(true), records: .constant(records))
                    .onAppear {
                        if scene == "share" { showShare = true }
                    }
                    .sheet(isPresented: $showShare) {
                        ActivityViewController(activityItems: [Self.sampleAudioURL])
                    }
            default:
                StandbyView(saveAction: {}, records: .constant(records), isRecording: .constant(false))
            }
        }
        .preferredColorScheme(.light)
    }

    private static var sampleAudioURL: URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("2026.11.13_09-41.wav")
        if !FileManager.default.fileExists(atPath: url.path),
           let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1),
           let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 308700) {
            buffer.frameLength = buffer.frameCapacity
            if let channel = buffer.floatChannelData?[0] {
                channel.initialize(repeating: 0, count: Int(buffer.frameLength))
            }
            if let file = try? AVAudioFile(forWriting: url, settings: format.settings) {
                try? file.write(from: buffer)
            }
        }
        return url
    }
}
#endif

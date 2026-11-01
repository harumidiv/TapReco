//
//  TapRecoWidget.swift
//  TapRecoWidget
//


import SwiftUI
import WidgetKit

private let recordingURL = URL(string: "tapreco://record")

private struct RecordingEntry: TimelineEntry {
    let date: Date
}

private struct RecordingProvider: TimelineProvider {
    func placeholder(in context: Context) -> RecordingEntry {
        RecordingEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (RecordingEntry) -> Void) {
        completion(RecordingEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RecordingEntry>) -> Void) {
        completion(Timeline(entries: [RecordingEntry(date: Date())], policy: .never))
    }
}

private struct TapRecoWidgetView: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            if isAccessory {
                // ロック画面ではシステムが背景を描画するため、背景色は付けない
                accessoryContent
                    .accessoryContainerBackground()
            } else if #available(iOSApplicationExtension 17.0, *) {
                content
                    .containerBackground(backgroundColor, for: .widget)
            } else {
                content
                    .background(backgroundColor)
            }
        }
        .widgetURL(recordingURL)
    }

    private var isAccessory: Bool {
        switch family {
        case .accessoryCircular, .accessoryRectangular, .accessoryInline:
            return true
        default:
            return false
        }
    }

    @ViewBuilder
    private var accessoryContent: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "mic.fill")
                    .font(.system(size: 24, weight: .bold))
            }
            .widgetAccentable()
        case .accessoryRectangular:
            HStack(spacing: 8) {
                ZStack {
                    AccessoryWidgetBackground()
                    Image(systemName: "mic.fill")
                        .font(.system(size: 20, weight: .bold))
                }
                .frame(width: 44, height: 44)
                .widgetAccentable()

                VStack(alignment: .leading, spacing: 2) {
                    Text("たぷれこ")
                        .font(.headline)
                    Text("タップで録音")
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        default:
            Label("タップで録音", systemImage: "mic.fill")
        }
    }

    private var content: some View {
        Group {
            if family == .systemSmall {
                VStack(spacing: 8) {
                    recordingIcon

                    Text("録音開始")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            } else {
                HStack(spacing: 16) {
                    recordingIcon

                    VStack(alignment: .leading, spacing: 4) {
                        Text("たぷれこ")
                            .font(.headline)
                        Text("タップして録音開始")
                            .font(.title3.bold())
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var recordingIcon: some View {
        ZStack {
            Circle()
                .fill(Color.red)
            Image(systemName: "mic.fill")
                .font(.system(size: family == .systemSmall ? 34 : 30, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: family == .systemSmall ? 72 : 64,
               height: family == .systemSmall ? 72 : 64)
    }

    private var backgroundColor: Color {
        Color(uiColor: .systemBackground)
    }
}

private extension View {
    @ViewBuilder
    func accessoryContainerBackground() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(.clear, for: .widget)
        } else {
            self
        }
    }
}

@main
struct TapRecoWidget: Widget {
    let kind = "TapRecoRecordingWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RecordingProvider()) { _ in
            TapRecoWidgetView()
        }
        .configurationDisplayName("すぐに録音")
        .description("ウィジェットをタップして、たぷれこで録音を開始します。")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            // ロック画面用
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
        ])
    }
}

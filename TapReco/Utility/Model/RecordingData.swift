//
//  RecordingData.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/06.
//

import Foundation

struct RecordData: Identifiable, Codable {
    let id: UUID
    let title: String
    let recordDate: String
    let fileName:String
    let fileSize: String
    let recordTime: String
    var isSelected: Bool

    init(title: String, recordDate: String, fileName: String, fileSize: String, recordTime: String, isSelected: Bool = false) {
        id = UUID()
        self.title = title
        self.recordDate = recordDate
        self.fileName = fileName
        self.fileSize = fileSize
        self.recordTime = recordTime
        self.isSelected = isSelected
    }


    /// 選択状態を切り替えるためのInitializer
    /// - Parameters:
    ///   - record: 既存のRecord
    ///   - isSelected: 選択状態
    init(record: RecordData, isSelected: Bool) {
        id = record.id
        title = record.title
        recordDate = record.recordDate
        fileName = record.fileName
        fileSize = record.fileSize
        recordTime = record.recordTime
        self.isSelected = isSelected
    }
}

// MARK: - Preview用サンプルデータ
extension RecordData {
    static let sampleData: [RecordData] =
    [
    RecordData(title: "新規録音", recordDate:  "2022.10.07_14:54", fileName: "マイ録音", fileSize: "3.5MB", recordTime: "3:15"),
    RecordData(title: "新規録音", recordDate:  "2022.10.07_14:54", fileName: "マイ録音", fileSize: "3.5MB", recordTime: "3:15"),
    RecordData(title: "新規録音", recordDate:  "2022.10.07_14:54", fileName: "マイ録音", fileSize: "3.5MB", recordTime: "3:15")
    ]
}

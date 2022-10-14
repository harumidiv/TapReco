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
    var isEditing: Bool

    init(title: String, recordDate: String, fileName: String, fileSize: String, recordTime: String, isSelected: Bool = false, isEditing:Bool = false) {
        id = UUID()
        self.title = title
        self.recordDate = recordDate
        self.fileName = fileName
        self.fileSize = fileSize
        self.recordTime = recordTime
        self.isSelected = isSelected
        self.isEditing = isEditing
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
        isEditing = record.isEditing
    }


    /// 編集中の状態に切り替えるためのInitializer
    /// - Parameters:
    ///   - record: 既存のRecordData
    ///   - isEditing: 編集状態
    init(record: RecordData, isEditing: Bool) {
        id = record.id
        title = record.title
        recordDate = record.recordDate
        fileName = record.fileName
        fileSize = record.fileSize
        recordTime = record.recordTime
        isSelected = record.isSelected
        self.isEditing = isEditing
    }

    ///  タイトルを編集するためのinitializer
    /// - Parameters:
    ///   - record: 既存のRecordData
    ///   - editTitle: ユーザによって編集されたタイトル
    init(record: RecordData, editTitle: String) {
        id = record.id
        title = editTitle
        recordDate = record.recordDate
        fileName = record.fileName
        fileSize = record.fileSize
        recordTime = record.recordTime
        isSelected = record.isSelected
        isEditing = false // 編集完了時必ずfalse状態に戻す
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

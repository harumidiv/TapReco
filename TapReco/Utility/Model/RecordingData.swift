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
    let fileLength: String
    var isSelected: Bool

    init(title: String, recordDate: String, fileName: String, fileSize: String, fileLength: String) {
        id = UUID()
        self.title = title
        self.recordDate = recordDate
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileLength = fileLength
        self.isSelected = false
    }
}

// MARK: - Preview用サンプルデータ
extension RecordData {
    static let sampleData: [RecordData] =
    [
    RecordData(title: "My録音", recordDate:  "2022/10/7", fileName: "マイ録音", fileSize: "3.5MB", fileLength: "3:15"),
    RecordData(title: "My録音", recordDate:  "2022/10/8", fileName: "マイ録音", fileSize: "3.5MB", fileLength: "3:15"),
    RecordData(title: "My録音", recordDate:  "2022/10/8", fileName: "マイ録音", fileSize: "3.5MB", fileLength: "3:15")
    ]
}

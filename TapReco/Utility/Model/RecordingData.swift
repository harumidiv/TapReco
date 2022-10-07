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

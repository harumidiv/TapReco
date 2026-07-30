//
//  RecordStore.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/06.
//

import Foundation

private actor RecordPersistence {
    static let shared = RecordPersistence()

    func load() throws -> [RecordData] {
        let fileURL = try fileURL()
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([RecordData].self, from: data)
    }

    func save(records: [RecordData]) throws -> Int {
        let data = try JSONEncoder().encode(records)
        try data.write(to: fileURL(), options: .atomic)
        return records.count
    }

    private func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("records.data")
    }
}

@MainActor
final class RecordStore: ObservableObject {
    @Published var records: [RecordData] = []

    /// 端末内部に保存している録音データを取得する
    /// - Returns: 録音データ一覧
    static func load() async throws -> [RecordData] {
        try await RecordPersistence.shared.load()
    }

    /// 新規に録音データを保存する
    /// - Parameter records: 録音データ
    /// - Returns: 成功の有無
    @discardableResult
    static func save(records: [RecordData]) async throws -> Int {
        try await RecordPersistence.shared.save(records: records)
    }
}

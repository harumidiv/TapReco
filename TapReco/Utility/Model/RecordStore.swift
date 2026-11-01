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
    static let shared = RecordStore()

    @Published var records: [RecordData] = []
    private var loadTask: Task<Void, Error>?

    private init() {}

    /// 端末内部に保存している録音データを読み込む。読み込み済みの場合は何もしない
    func loadIfNeeded() async throws {
        if let loadTask {
            return try await loadTask.value
        }
        let task = Task {
            records = try await RecordPersistence.shared.load()
        }
        loadTask = task
        do {
            try await task.value
        } catch {
            // 失敗した場合は次回呼び出し時に再読み込みする
            loadTask = nil
            throw error
        }
    }

    /// 録音データ一覧を端末内部に保存する。
    /// 読み込み前に保存すると既存のデータを上書きしてしまうため、未読み込みの場合は先に読み込む
    func save() async throws {
        try await loadIfNeeded()
        try await RecordPersistence.shared.save(records: records)
    }

    /// 新規の録音データを一覧に追加して保存する
    func append(_ record: RecordData) async throws {
        try await loadIfNeeded()
        records.append(record)
        try await save()
    }
}

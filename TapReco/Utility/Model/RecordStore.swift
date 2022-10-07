//
//  RecordStore.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/06.
//

import Foundation

final class RecordStore: ObservableObject {
    @Published var records: [RecordData] = []

    /// 端末内部に保存している録音データを取得する
    /// - Returns: 録音データ一覧
    static func load() async throws -> [RecordData] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }

    /// 新規に録音データを保存する
    /// - Parameter records: 録音データ
    /// - Returns: 成功の有無
    @discardableResult
    static func save(records: [RecordData]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: records) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let recordSaved):
                    continuation.resume(returning: recordSaved)
                }
            }
        }
    }
}

// MARK: - PriavteMethod
extension RecordStore {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("records.data")
    }

    private static func load(completion: @escaping (Result<[RecordData], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyScrums = try JSONDecoder().decode([RecordData].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyScrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private static func save(scrums: [RecordData], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(scrums)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

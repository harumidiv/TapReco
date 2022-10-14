//
//  ErrorWapper.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/14.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String

    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}

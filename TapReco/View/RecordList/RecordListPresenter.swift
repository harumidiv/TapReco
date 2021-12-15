//
//  RecordListPresenter.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import Foundation

final class RecordListPresenter: ObservableObject {
    enum Inputs {
        case didTapRecording
    }

    func apply(inputs: Inputs) {
        switch inputs {
        case .didTapRecording:
            break
        }
    }
}

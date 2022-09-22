//
//  RecordingInfo.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/09/22.
//

import Foundation
import RealmSwift

class RecordingInfo: Object {
    // タイトル
    @objc dynamic var title: String = ""
    // 録音した日付
    @objc dynamic var dateText: String = ""
    // 時間
    @objc dynamic var playTime: String = ""
    // ファイルサイズ
    @objc dynamic var fileSize: String = ""
    
    // ファイルの名(再生時にこの名前でファイルを引っ掛ける)
    @objc dynamic var fileName: String = ""
}

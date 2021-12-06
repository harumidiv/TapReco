//
//  RecordListView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/02.
//

import SwiftUI

struct RecordListView: View {
    var body: some View {
        ForEach(0..<recordListCount()) {_ in
            Text("Hello, World!")
        }
    }
    
    private func recordListCount() -> Int {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: documentPath) else {
            return 0
        }
        return fileNames.count
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView()
    }
}

//
//  RecordListHeaderView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/08.
//

import SwiftUI

struct RecordListHeaderView: View {
    @Binding var isPresentedRecordListView: Bool
    
    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            HStack {
                Spacer().frame(width: 30)
                Text("Library")
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    isPresentedRecordListView = false
                }){
                    Image("icon_close")
                }
                .frame(width: 28, height: 28)
                Spacer().frame(width: 30)
            }
            Spacer().frame(height: 30)
            HStack {
                Spacer().frame(width: 30)
                Text("録音ファイル数")
                Text("12")
                Spacer()
                Button(action: {
                    // 何の処理が走る？
                }){
                    Text("🐙")
                        .font(.largeTitle)
                }
                Spacer().frame(width: 30)
            }
            Text("TODO: SearchBarを表示させる")
        }
    }
}

struct RecordListSectionHeadaerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListHeaderView(isPresentedRecordListView: .constant(false))
    }
}

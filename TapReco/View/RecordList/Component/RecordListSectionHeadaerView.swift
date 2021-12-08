//
//  RecordListSectionHeadaerView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/08.
//

import SwiftUI

struct RecordListSectionHeadaerView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Library")
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    // 画面を閉じる
                }){
                    Image("icon_section_header")
                    
                }.background(Color.gray)
                    .frame(width: 28, height: 28)
                    .border(Color.red, width: 1)
                    .cornerRadius(14)
            }
            HStack {
                Text("録音ファイル数")
                Text("12")
                Spacer()
                Button(action: {
                    // 何の処理が走る？
                }){
                    Text("🐙")
                        .font(.largeTitle)
                }
            }
            Text("TODO: SearchBarを表示させる")
        }
    }
}

struct RecordListSectionHeadaerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListSectionHeadaerView()
    }
}

//
//  RecordCardViewx.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import SwiftUI


struct RecordCardView: View {
    @Binding var record: RecordData
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 0){
                Text(record.title)
                    .font(.title2)
                Text(record.recordDate)
                    .font(.caption)
            }
            Spacer()
            VStack{
                Text(record.fileLength)
                    .font(.body)
                Text(record.fileSize)
                    .font(.caption)
            }

            
            Image("icon_dot")
                .frame(width: 16, height: 16)
                .onTapGesture {
                    // TODO 編集画面を開く
                    print("タップされたよ")
                }
        }
        
    }
}

struct RecordCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecordCardView(record: .constant(RecordData.sampleData[0]))
            .fixedSize()
    }
}

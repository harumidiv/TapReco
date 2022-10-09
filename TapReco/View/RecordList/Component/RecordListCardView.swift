//
//  RecordListCardView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import SwiftUI


struct RecordListCardView: View {
    @Binding var record: RecordData
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading){
                    Text(record.title)
                        .font(.title2)
                    Text(record.recordDate)
                        .font(.caption)
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text(record.fileLength)
                        .font(.body)
                    Text(record.fileSize)
                        .font(.caption)
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
        }

    }
}

struct RecordListCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListCardView(record: .constant(RecordData.sampleData[0]), backgroundColor: .purple)
            .fixedSize(horizontal: false, vertical: true)
    }
}

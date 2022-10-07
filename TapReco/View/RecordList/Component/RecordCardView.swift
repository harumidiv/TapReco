//
//  RecordCardViewx.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import SwiftUI


struct RecordCardView: View {
    struct ViewModel {
        var title: String
        var recordDate: String
        var fileLength: String
        let fileSize: String
    }
    
    let viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 0){
                Text(viewModel.title)
                Text(viewModel.recordDate)
            }
            Spacer()
            VStack{
                Text(viewModel.fileLength)
                Text(viewModel.fileSize)
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
        RecordCardView(viewModel: .init(title: "hogehoge",
                                            recordDate: "2月3日 23:12",
                                            fileLength: "03:50",
                                            fileSize: "3.5MB"))
    }
}

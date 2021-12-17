//
//  RecordListCellView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/15.
//

import SwiftUI

struct RecordListCellView: View {
    struct ViewModel {
        var title: String
    }
    
    let viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 0){
                Text(viewModel.title)
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            VStack{
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }

            Image("icon_dot")
        }
        
    }
}

struct RecordListCellView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListCellView(viewModel: .init(title: "hogehoge"))
    }
}

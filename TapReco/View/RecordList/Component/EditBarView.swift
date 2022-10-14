//
//  EditBarView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/14.
//

import SwiftUI

struct EditBarView: View {
    let placeHolderText: String
    @Binding var text: String

    @FocusState private var selectState: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColor.sortBackground)
                .frame(height: 36)
            HStack(spacing: 10) {
                Spacer()
                    .frame(width: 0)
                TextField(placeHolderText, text: $text)
                    .focused($selectState)
                    .foregroundColor(AppColor.textLightGray)
            }
        }
        .onAppear{
            selectState = true
        }
    }
}

struct EditBarView_Previews: PreviewProvider {
    static var previews: some View {
        EditBarView(placeHolderText: "プレースホルダー", text: .constant(""))
            .padding()
            .background(.orange)
    }
}

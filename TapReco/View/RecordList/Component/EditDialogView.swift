//
//  EditDialogView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/14.
//

import SwiftUI

struct EditDialogView: View {
    @State private var editText: String = ""
    var body: some View {
        ZStack {
            Color.red
            VStack {
                Text("タイトル編集")
                    .font(Font.system(size: 16, weight: .bold))
                    .padding()
                TextField("プレースホルダー", text: $editText)
                    .background(AppColor.sortBackground)
                    .padding(.horizontal)

                HStack {
                    Button("キャンセル"){
                        // TODO キャンセル処理
                    }
                        .frame(width: 150)
                    Button("決定"){
                        // TODO 保存処理
                    }
                        .frame(width: 150)
                }
                .padding()
            }
            .background(AppColor.background)
            .frame(width: 300)
            .cornerRadius(16)
        }
        .ignoresSafeArea()
    }
}

struct EditDialogView_Previews: PreviewProvider {
    static var previews: some View {
        EditDialogView()
    }
}

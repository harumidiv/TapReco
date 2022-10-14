//
//  EditDialogView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/14.
//

import SwiftUI

struct EditDialogView: View {
    @Binding var isShowEditAlert: Bool
    let placeholderText: String
    var updateAction: ()->Void

    @State private var editText: String = ""
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.2)
            VStack {
                Text("タイトル編集")
                    .font(Font.system(size: 16, weight: .bold))
                    .padding()
                TextField(placeholderText, text: $editText)
                    .background(AppColor.sortBackground)
                    .padding(.horizontal)

                HStack {
                    Button("キャンセル"){
                        isShowEditAlert.toggle()
                    }
                    .frame(width: 150)
                    Button("決定"){
                        if editText.isEmpty {
                            isShowEditAlert.toggle()
                        } else {
                            updateAction()
                            isShowEditAlert.toggle()
                        }
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
        EditDialogView(isShowEditAlert: .constant(true),
                       placeholderText: "プレースホルダー"){}
    }
}

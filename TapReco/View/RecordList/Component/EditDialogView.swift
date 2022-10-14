//
//  EditDialogView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/14.
//

import SwiftUI

struct EditDialogView: View {
    enum CompleteState {
        case cancel
        case done(title: String)
    }

    let placeholderText: String
    var updateAction: (_ state: CompleteState)->Void
    @State private var editText: String = ""

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.2)
            VStack(spacing: 0) {
                Text("タイトル編集")
                    .font(Font.system(size: 16, weight: .bold))
                    .padding()

                EditBarView(placeHolderText: placeholderText,
                            text: $editText)
                    .padding(.horizontal)
                    .padding(.bottom)

                Rectangle()
                    .frame(width: 300, height: 1)
                    .foregroundColor(AppColor.sortLightGray)
                HStack(spacing: 0) {
                    Button("キャンセル"){
                        updateAction(.cancel)
                    }
                    .frame(width: 150, height: 50)

                    Rectangle()
                        .frame(width: 1, height: 50)
                        .foregroundColor(AppColor.sortLightGray)
                    Button("決定"){
                        if editText.isEmpty {
                            updateAction(.cancel)
                        } else {
                            updateAction(.done(title: editText))
                        }
                    }
                    .frame(width: 150, height: 50)
                }
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
        EditDialogView(placeholderText: "プレースホルダー"){state in}

    }
}

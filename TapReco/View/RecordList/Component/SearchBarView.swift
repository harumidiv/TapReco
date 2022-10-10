//
//  SearchBarView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/10.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColor.searchBackground)
                    .frame(height: 36)
                HStack(spacing: 6) {
                    Spacer()
                        .frame(width: 0)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("検索", text: $text)
                        .foregroundColor(AppColor.textLightGray)

                    // 検索文字が空ではない場合は、クリアボタンを表示
                    if !text.isEmpty {
                        Button {
                            text.removeAll()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 6)
                    }
                }
            }
        }
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBarView(text: .constant(""))
            SearchBarView(text: .constant("hogehoge"))
        }
        .background(.orange)
    }
}

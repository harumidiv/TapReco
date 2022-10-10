//
//  SearchBarView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/10.
//

import SwiftUI

import SwiftUI

struct SearchBarView: View {

    @Binding var text: String

    var body: some View {
        VStack {

            ZStack {
                // 背景
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 239 / 255,
                                green: 239 / 255,
                                blue: 241 / 255))
                    .frame(height: 36)

                HStack(spacing: 6) {
                    Spacer()
                        .frame(width: 0)

                    // 虫眼鏡
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    // テキストフィールド
                    TextField("Search", text: $text)

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
            .padding(.horizontal)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBarView(text: .constant(""))
            SearchBarView(text: .constant("hogehoge"))
        }
    }
}

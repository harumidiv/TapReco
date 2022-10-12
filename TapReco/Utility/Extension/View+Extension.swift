//
//  View+Extension.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/12.
//

import SwiftUI

extension View {
    // カスタムModifierのメソッド名を alertWithTextField に置き換え
    func alertWithTextField(_ text: Binding<String>,
                            isPresented: Binding<Bool>,
                            title: String?,
                            message: String?,
                            placeholderText: String) -> some View {
        self.modifier(AlertWithTextField(textFieldText: text,
                                         isPresented: isPresented,
                                         title: title,
                                         message: message,
                                         placeholderText: placeholderText))
    }
}

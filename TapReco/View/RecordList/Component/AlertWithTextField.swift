//
//  AlertWithTextField.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/12.
//

import SwiftUI

struct AlertWithTextField: ViewModifier {
    @Binding var textFieldText: String
    @Binding var isPresented: Bool

    let title: String?
    let message: String?
    let placeholderText: String

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                AlertControllerWithTextFieldContainer(textFieldText: $textFieldText,
                                                      isPresented: $isPresented,
                                                      title: title,
                                                      message: message,
                                                      placeholderText: placeholderText)
            }
        }
    }
}

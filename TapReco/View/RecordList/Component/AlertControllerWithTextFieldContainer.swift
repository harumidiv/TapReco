//
//  AlertControllerWithTextFieldContainer.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/12.
//

import UIKit
import SwiftUI

struct AlertControllerWithTextFieldContainer: UIViewControllerRepresentable {

    @Binding var textFieldText: String
    @Binding var isPresented: Bool

    let title: String?
    let message: String?
    let placeholderText: String

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    // SwiftUIから新しい情報を受け、viewControllerが更新されるタイミングで呼ばれる
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // TextFieldの追加
        alert.addTextField { textField in
            textField.placeholder = placeholderText
            textField.returnKeyType = .done
        }

        // 決定ボタンアクション
        let doneAction = UIAlertAction(title: "決定", style: .default) { _ in
            if let textField = alert.textFields?.first,
               let text = textField.text {
                textFieldText = text
            }
        }

        // キャンセルボタンアクション
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

        alert.addAction(cancelAction)
        alert.addAction(doneAction)

        DispatchQueue.main.async {
            uiViewController.present(alert, animated: true) {
                isPresented = false
            }
        }
    }
}

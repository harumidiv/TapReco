//
//  SnackBarView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/12.
//

import SwiftUI

struct SnackBarView: View {
    let state: State = .success

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            HStack {
                Image(systemName: state.imageName)
                    .font(Font.system(size: 29, weight: .regular))
                    .foregroundColor(AppColor.statusText)
                Text(state.text)
                    .font(Font.system(size: 13, weight: .bold))
                    .foregroundColor(AppColor.statusText)
                    .padding(.trailing, 10)
                Image(systemName:"xmark")
                    .font(Font.system(size: 20, weight: .regular))
                    .foregroundColor(AppColor.statusText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(state.backgroundColor)
            .cornerRadius(8)
        }
    }
}

extension SnackBarView {
    enum State {
        case success
        case error

        var text: String {
            switch self {
            case .success:
                return "録音を保存しました"
            case .error:
                return "録音に失敗しました"
            }
        }

        var imageName: String {
            switch self {
            case .success:
                return "checkmark.circle.fill"
            case .error:
                return "checkmark.circle.fill" // TODO画像がsystemImageか確認する
            }
        }

        var backgroundColor: Color {
            switch self {
            case .success:
                return AppColor.statusOK
            case .error:
                return AppColor.statusError
            }
        }
    }

}

//struct SnackBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            SnackBarView(state: .success)
//            SnackBarView(state: .error)
//        }
//    }
//}

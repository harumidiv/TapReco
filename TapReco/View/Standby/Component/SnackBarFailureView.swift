//
//  SnackBarFailureView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/12.
//

import SwiftUI

struct SnackBarFailureView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 60)
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(Font.system(size: 29, weight: .regular))
                    .foregroundColor(AppColor.statusText)
                Text("録音に失敗しました")
                    .font(Font.system(size: 13, weight: .bold))
                    .foregroundColor(AppColor.statusText)
                    .padding(.trailing, 10)
                Image(systemName:"xmark")
                    .font(Font.system(size: 20, weight: .regular))
                    .foregroundColor(AppColor.statusText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(AppColor.statusError)
            .cornerRadius(8)
        }
    }
}

struct SnackBarFailureView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SnackBarFailureView()
        }
    }
}

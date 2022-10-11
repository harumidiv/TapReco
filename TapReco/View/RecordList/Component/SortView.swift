//
//  SortView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/11.
//

import SwiftUI

enum SortType {
    case dateNew
    case dateOld
    case recordTimeLong
    case recordTimeShrt
    case fileSizeLarge
    case fileSizeSmall
}

struct SortView: View {
    @Binding var sortType: SortType

    private var selectType: SelectType {
        switch sortType {
        case .dateNew, .dateOld:
            return .date
        case .recordTimeLong, .recordTimeShrt:
            return .recordTime
        case .fileSizeLarge, .fileSizeSmall:
            return .fileSize
        }
    }

    private var isLeftSelected: Bool {
        switch sortType {
        case .dateOld, .recordTimeShrt, .fileSizeSmall:
            return true
        case .dateNew, .recordTimeLong, .fileSizeLarge:
            return false
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("並び替え")
                Spacer()
                Image(systemName: "xmark")
                    .font(Font.system(size: 18, weight: .regular))
                    .foregroundColor(AppColor.textLightGray)
            }
            .padding()
            SelectView(isSelected: (sortType == .dateNew || sortType == .dateOld),
                       selectType: .date){
                sortType = isLeftSelected ? .dateOld : .dateNew
            }
            SelectView(isSelected: (sortType == .recordTimeLong || sortType == .recordTimeShrt),
                       selectType: .recordTime){
                sortType = isLeftSelected ? .recordTimeShrt : .recordTimeLong
            }
            SelectView(isSelected: (sortType == .fileSizeLarge || sortType == .fileSizeSmall),
                       selectType: .fileSize){
                sortType = isLeftSelected ? .fileSizeSmall : .fileSizeLarge
            }

            HStack() {
                Spacer()
                Button(action: {
                    changeOrderType(isLeftButton: true)
                }) {
                    createOrderText(isLeftButton: true)
                }
                Button(action: {
                    changeOrderType(isLeftButton: false)
                }) {
                    createOrderText(isLeftButton: false)
                }
            }
            .padding([.top, .trailing])
        }
        .padding()
        .background(.red)
        .cornerRadius(16)
        .frame(width: 300)

    }
}

// MARK: - 順番の切り替え、表示
extension SortView {
    func changeOrderType(isLeftButton: Bool) {
        switch selectType {
        case .date:
            sortType = isLeftButton ? .dateOld : .dateNew

        case .recordTime:
            sortType = isLeftButton ? .recordTimeShrt : .recordTimeLong

        case .fileSize:
            sortType = isLeftButton ? .fileSizeSmall : .fileSizeLarge
        }
    }

    func createOrderText(isLeftButton: Bool) -> Text {
        let text: Text
        switch selectType {
        case .date:
            text = isLeftButton ? Text("古い順") : Text("新しい順")

        case .recordTime:
            text = isLeftButton ? Text("短い順") : Text("長い順")

        case .fileSize:
            text = isLeftButton ? Text("小さい順") : Text("大きい順")
        }

        let color: Color

        if isLeftSelected {
            color = isLeftButton ? .green : .blue

        } else {
            color = !isLeftButton ? .green : .blue
        }

        return text.foregroundColor(color)
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView(sortType: .constant(.dateNew))
    }
}

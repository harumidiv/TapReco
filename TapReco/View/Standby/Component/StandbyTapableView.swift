//
//  StandbyTapableView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/07.
//

import SwiftUI

struct StandbyTapableView: View {
    let tapAction: ()->Void

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            //foregroundColorをclearに設定するとtapが効かなくなるのでcontentShapeを入れる
            .contentShape(Rectangle())
            .onTapGesture {
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.prepare()
                impactHeavy.impactOccurred()

                tapAction()
            }
    }
}

struct StandbyTapableView_Previews: PreviewProvider {
    static var previews: some View {
        StandbyTapableView(tapAction: {})
    }
}

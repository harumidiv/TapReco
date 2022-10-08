//
//  IntroView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/08.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack {
            TabView {
                Text("タイトル１").foregroundColor(.white)
                Text("タイトル２").foregroundColor(.white)
            }
            .tabViewStyle(PageTabViewStyle.init(indexDisplayMode: .always))
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
        .cornerRadius(16)
        .padding()

    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}

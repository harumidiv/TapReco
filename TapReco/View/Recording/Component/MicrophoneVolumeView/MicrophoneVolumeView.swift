//
//  MicrophoneVolumeView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/07.
//

import SwiftUI

struct MicrophoneVolumeView: View {
    let width: CGFloat = 4
    let padding: CGFloat = 6
    let weight: CGFloat = 2
    @StateObject private var manager = MicrophoneLebelManager()

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            MicrophoneVolumeLeftView(manager: manager,
                                     width: width,
                                     padding: padding,
                                     weight: weight)
            MicrophoneVolumeRightView(manager: manager,
                                      width: width,
                                      padding: padding,
                                      weight: weight)
        }
        .onAppear() {
            // 遅延を追加しなしとHaptic HeedBackが発火しない
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                manager.startUpdatingVolume()
            }
        }.onDisappear() {
            manager.stopUpdatingVolume()
        }
    }

    func calculateHeight(value: Double) -> Double {
        abs(value + (value * manager.volume) * weight)
    }
}


struct MicrophoneVolumeView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophoneVolumeView()
            .preferredColorScheme(.dark)
    }
}

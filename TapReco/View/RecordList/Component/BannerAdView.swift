//
//  BannerAdView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2026/10/07.
//

import SwiftUI
import GoogleMobileAds

/// 画面幅に合わせたアンカー型アダプティブバナー広告
struct BannerAdView: View {
    @State private var width: CGFloat = 0

    var body: some View {
        let adSize = largeAnchoredAdaptiveBanner(width: max(width, 1))
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: adSize.size.height)
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { newWidth in
                width = newWidth
            }
            .overlay {
                if width > 0 {
                    BannerViewContainer(adSize: adSize)
                        .frame(width: adSize.size.width, height: adSize.size.height)
                }
            }
    }
}

private struct BannerViewContainer: UIViewRepresentable {
    #if DEBUG
    // Google公式のテスト用広告ユニットID（開発中に本番広告をタップしないため）
    private let adUnitID = "ca-app-pub-3940256099942544/2435281174"
    #else
    private let adUnitID = "ca-app-pub-8522231452310619/7451605798"
    #endif

    let adSize: AdSize

    func makeUIView(context: Context) -> BannerContainerView {
        BannerContainerView(adUnitID: adUnitID, adSize: adSize)
    }

    func updateUIView(_ containerView: BannerContainerView, context: Context) {
        containerView.update(adSize: adSize)
    }
}

/// レイアウトが確定する前に読み込むと枠を無視した大きさで描画されるため、
/// 実際のサイズが決まってから読み込み、はみ出した部分は切り取る
final class BannerContainerView: UIView {
    private let bannerView: BannerView
    private var loadedSize: CGSize?

    init(adUnitID: String, adSize: AdSize) {
        bannerView = BannerView(adSize: adSize)
        super.init(frame: .zero)
        clipsToBounds = true
        bannerView.adUnitID = adUnitID
        addSubview(bannerView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(adSize: AdSize) {
        guard !CGSizeEqualToSize(bannerView.adSize.size, adSize.size) else { return }
        bannerView.adSize = adSize
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = bannerView.adSize.size
        bannerView.frame = CGRect(x: (bounds.width - size.width) / 2,
                                  y: (bounds.height - size.height) / 2,
                                  width: size.width,
                                  height: size.height)
        // 画面幅が変わった場合のみ読み込み直す
        guard bounds.width > 0, loadedSize != size else { return }
        loadedSize = size
        bannerView.load(Request())
    }
}

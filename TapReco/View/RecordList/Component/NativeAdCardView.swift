//
//  NativeAdCardView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2026/10/07.
//

import SwiftUI
import GoogleMobileAds

/// 録音カードに見た目を合わせたネイティブアドバンス広告
struct NativeAdCardView: UIViewRepresentable {
    static let height: CGFloat = 176

    let nativeAd: NativeAd

    func makeUIView(context: Context) -> NativeAdContentView {
        NativeAdContentView()
    }

    func updateUIView(_ adView: NativeAdContentView, context: Context) {
        adView.configure(with: nativeAd)
    }
}

final class NativeAdContentView: NativeAdView {
    private let adBadgeLabel = UILabel()
    private let advertiserLabel = UILabel()
    private let adMediaView = MediaView()
    private let headlineLabel = UILabel()
    private let bodyLabel = UILabel()
    private let callToActionButton = UIButton(configuration: .filled())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with nativeAd: NativeAd) {
        guard self.nativeAd !== nativeAd else { return }

        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        bodyLabel.isHidden = nativeAd.body == nil
        advertiserLabel.text = nativeAd.advertiser
        advertiserLabel.isHidden = nativeAd.advertiser == nil
        callToActionButton.configuration?.title = nativeAd.callToAction
        callToActionButton.isHidden = nativeAd.callToAction == nil
        adMediaView.mediaContent = nativeAd.mediaContent

        // アセットを設定してから紐付ける必要がある
        self.nativeAd = nativeAd
    }

    private func setupViews() {
        backgroundColor = UIColor(named: "box_gray")
        layer.cornerRadius = 8
        clipsToBounds = true

        // ポリシー上、広告であることを明示するラベルが必要
        adBadgeLabel.text = "広告"
        adBadgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        adBadgeLabel.textAlignment = .center
        adBadgeLabel.textColor = UIColor(named: "box_gray")
        adBadgeLabel.backgroundColor = UIColor(named: "text_gray")
        adBadgeLabel.layer.cornerRadius = 3
        adBadgeLabel.clipsToBounds = true

        advertiserLabel.font = .systemFont(ofSize: 12, weight: .regular)
        advertiserLabel.textColor = UIColor(named: "text_gray")

        adMediaView.contentMode = .scaleAspectFill
        adMediaView.layer.cornerRadius = 6
        adMediaView.clipsToBounds = true

        headlineLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        headlineLabel.textColor = UIColor(named: "text_light_gray")
        headlineLabel.numberOfLines = 2

        bodyLabel.font = .systemFont(ofSize: 13, weight: .regular)
        bodyLabel.textColor = UIColor(named: "text_gray")
        bodyLabel.numberOfLines = 2

        callToActionButton.configuration?.baseForegroundColor = UIColor(named: "box_gray")
        callToActionButton.configuration?.baseBackgroundColor = UIColor(named: "text_light_gray")
        callToActionButton.configuration?.cornerStyle = .capsule
        callToActionButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        callToActionButton.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var attributes = $0
            attributes.font = .systemFont(ofSize: 13, weight: .bold)
            return attributes
        }
        // タップはSDKが処理するため、ボタン自体のタップは無効にする
        callToActionButton.isUserInteractionEnabled = false

        [adBadgeLabel, advertiserLabel, adMediaView, headlineLabel, bodyLabel, callToActionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            adBadgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            adBadgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            adBadgeLabel.widthAnchor.constraint(equalToConstant: 30),
            adBadgeLabel.heightAnchor.constraint(equalToConstant: 16),

            advertiserLabel.centerYAnchor.constraint(equalTo: adBadgeLabel.centerYAnchor),
            advertiserLabel.leadingAnchor.constraint(equalTo: adBadgeLabel.trailingAnchor, constant: 8),
            // 右上は SDK が AdChoices アイコンを置くので空けておく
            advertiserLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40),

            // MediaView は動画広告の再生に 120x120 以上が必要
            adMediaView.topAnchor.constraint(equalTo: adBadgeLabel.bottomAnchor, constant: 8),
            adMediaView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            adMediaView.widthAnchor.constraint(equalToConstant: 120),
            adMediaView.heightAnchor.constraint(equalToConstant: 120),

            headlineLabel.topAnchor.constraint(equalTo: adMediaView.topAnchor),
            headlineLabel.leadingAnchor.constraint(equalTo: adMediaView.trailingAnchor, constant: 12),
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

            callToActionButton.bottomAnchor.constraint(equalTo: adMediaView.bottomAnchor),
            callToActionButton.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            callToActionButton.trailingAnchor.constraint(lessThanOrEqualTo: headlineLabel.trailingAnchor),
            callToActionButton.heightAnchor.constraint(equalToConstant: 28),
        ])

        advertiserView = advertiserLabel
        mediaView = adMediaView
        headlineView = headlineLabel
        bodyView = bodyLabel
        callToActionView = callToActionButton
    }
}

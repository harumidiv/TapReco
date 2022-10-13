//
//  SlideToUPUnlockView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/12/30.
//

import UIKit

final class SlideToUPUnlockView: UIView {
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background")

        let image = UIImageView(image: .init(named: "up_slide_background"))
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        return view
    }()

    let upImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "icon_up_allow"))
    }()
    
    let slideButtonView: UIView = {
        let baseView = UIView()
        baseView.backgroundColor = UIColor(named: "box_gray")
        baseView.isUserInteractionEnabled = true

        let label = UILabel()
        label.textColor = UIColor(named: "text_light_gray")
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "録音履歴を確認"

        baseView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
        return baseView
    }()
    
    let dragAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private var bottomThumbnailViewConstraint: NSLayoutConstraint?
    private var isFinished: Bool = false
    private let bottomMargin: CGFloat = 8
    
    var slideDidComplete: (()->Void)?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    func resetDragPoint() {
        self.isFinished = false
        self.bottomThumbnailViewConstraint?.constant = -self.bottomMargin
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = 8
        backgroundView.layer.cornerRadius = 12
        dragAreaView.layer.cornerRadius = radius
        slideButtonView.layer.cornerRadius = radius
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished {
            return
        }
        let xEndingPoint = -(self.bounds.height - (slideButtonView.bounds.height + bottomMargin))
        let translatedPoint = sender.translation(in: self).y
        switch sender.state {
        case .changed:
            if translatedPoint <= xEndingPoint {
                updateThumbnailPosition(xEndingPoint)
                return
            }
            if translatedPoint >= 0 {
                updateThumbnailPosition(0)
                return
            }
            updateThumbnailPosition(translatedPoint)
        case .ended:
            if translatedPoint <= xEndingPoint {
                updateThumbnailPosition(xEndingPoint)
                isFinished = true
                slideDidComplete?()
                return
            }
            
            let animationVelocity: Double = 0.5
            UIView.animate(withDuration: animationVelocity) {
                self.bottomThumbnailViewConstraint?.constant = -self.bottomMargin
                self.layoutIfNeeded()
            }
        default:
            break
        }
    }
}

extension SlideToUPUnlockView {
    private func updateThumbnailPosition(_ x: CGFloat) {
        bottomThumbnailViewConstraint?.constant = x
        setNeedsLayout()
    }
    
    private func setupView() {
        
        self.addSubview(backgroundView)
        self.addSubview(upImageView)
        self.addSubview(dragAreaView)
        self.addSubview(slideButtonView)
        
        setupConstraint()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        slideButtonView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupConstraint() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        upImageView.translatesAutoresizingMaskIntoConstraints = false
        upImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        upImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
        upImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        upImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        dragAreaView.translatesAutoresizingMaskIntoConstraints = false
        dragAreaView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: bottomMargin).isActive = true
        dragAreaView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -bottomMargin).isActive = true
        dragAreaView.heightAnchor.constraint(equalToConstant: 44 + bottomMargin).isActive = true
        dragAreaView.bottomAnchor.constraint(equalTo: slideButtonView.bottomAnchor).isActive = true
        
        slideButtonView.translatesAutoresizingMaskIntoConstraints = false
        slideButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: bottomMargin).isActive = true
        slideButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -bottomMargin).isActive = true
        slideButtonView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        bottomThumbnailViewConstraint = slideButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomMargin)
        bottomThumbnailViewConstraint?.isActive = true
        
    }
}

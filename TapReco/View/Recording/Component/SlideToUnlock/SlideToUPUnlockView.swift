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
        
        view.backgroundColor = .darkGray
        return view
    }()
    
    let slideButtonView: UIView = {
        let baseView = UIView()
        baseView.backgroundColor = .red
        baseView.isUserInteractionEnabled = true
        
        let imageView = UIImageView(image: UIImage(named: "icon_up_allow"))
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .center
        
        let label = UILabel()
        label.text = "PLAYLIST"
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        baseView.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
        return baseView
    }()
    
    let dragAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
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
        let animationVelocity: Double = 1
        UIView.animate(withDuration: animationVelocity) {
            self.isFinished = false
            self.bottomThumbnailViewConstraint?.constant = -self.bottomMargin
            self.layoutIfNeeded()
        }
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
        let xEndingPoint = -(self.bounds.height - (slideButtonView.bounds.height))
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
        
        dragAreaView.translatesAutoresizingMaskIntoConstraints = false
        dragAreaView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        dragAreaView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        dragAreaView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        dragAreaView.bottomAnchor.constraint(equalTo: slideButtonView.bottomAnchor).isActive = true
        
        slideButtonView.translatesAutoresizingMaskIntoConstraints = false
        slideButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        slideButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        slideButtonView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        bottomThumbnailViewConstraint = slideButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomMargin)
        bottomThumbnailViewConstraint?.isActive = true
        
    }
}

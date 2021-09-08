//
//  SlideToActionView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/08.
//

import UIKit
import SwiftUI

final class SlideToActionView: UIView {
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel.init()
        label.text = "Slide to stop"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let thumnailImageView: UIImageView = {
        let view = UIImageView(image: .init(systemName: "star"))
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.contentMode = .center
        return view
    }()
    
    let dragAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private var leadingThumbnailViewConstraint: NSLayoutConstraint?
    
    // TODO この値の変更をSwiftUIに流す
    var isFinished: Bool = false
    
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
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished {
            return
        }
        let xEndingPoint = (self.bounds.width - thumnailImageView.bounds.width)
        let translatedPoint = sender.translation(in: self).x
        switch sender.state {
        case .changed:
            if translatedPoint >= xEndingPoint {
                updateThumbnailPosition(xEndingPoint)
                return
            }
            if translatedPoint <= 0 {
                updateThumbnailPosition(0)
                return
            }
            updateThumbnailPosition(translatedPoint)
        case .ended:
            if translatedPoint >= xEndingPoint {
                updateThumbnailPosition(xEndingPoint)
                isFinished = true
                return
            }
            
            let animationVelocity: Double = 0.5
            UIView.animate(withDuration: animationVelocity) {
                self.leadingThumbnailViewConstraint?.constant = 0
                self.layoutIfNeeded()
            }
        default:
            break
        }
    }
}

extension SlideToActionView {
    private func updateThumbnailPosition(_ x: CGFloat) {
        leadingThumbnailViewConstraint?.constant = x
        setNeedsLayout()
    }
    
    private func setupView() {
        
        self.addSubview(backgroundView)
        self.addSubview(dragAreaView)
        backgroundView.addSubview(textLabel)
        self.addSubview(thumnailImageView)
        
        setupConstraint()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        thumnailImageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupConstraint() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        
        dragAreaView.translatesAutoresizingMaskIntoConstraints = false
        dragAreaView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        dragAreaView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        dragAreaView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        dragAreaView.trailingAnchor.constraint(equalTo: thumnailImageView.trailingAnchor).isActive = true
        
        thumnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumnailImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumnailImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        thumnailImageView.heightAnchor.constraint(equalTo: thumnailImageView.widthAnchor).isActive = true
        leadingThumbnailViewConstraint = thumnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        leadingThumbnailViewConstraint?.isActive = true
    }
}

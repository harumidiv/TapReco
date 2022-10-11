//
//  SlideToActionView.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2021/09/08.
//

import UIKit

final class SlideToActionView: UIView {
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "slider_box")
        return view
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "スライドして録音停止"
        label.textColor = UIColor(named: "modal_background")
        return label
    }()

    let thumnailImageView: UIView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.image = UIImage(named: "icon_slidebar_start")
        view.isUserInteractionEnabled = true
        view.contentMode = .center

        let childView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        childView.isUserInteractionEnabled = true
        childView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childView)
        
        childView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        childView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        childView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return view
    }()
    
    let dragAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "slider_box")
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    let endCircleView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_slidebar_stop"))
        view.contentMode = .center
        
        return view
    }()
    
    private var leadingThumbnailViewConstraint: NSLayoutConstraint?
    private var isFinished: Bool = false
    
    private let sideMargin: CGFloat = 6
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = self.frame.height / 2
        backgroundView.layer.cornerRadius = radius
        dragAreaView.layer.cornerRadius = radius
        thumnailImageView.layer.cornerRadius = 25
        endCircleView.layer.cornerRadius = 25
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished {
            return
        }
        let xEndingPoint = (self.bounds.width - thumnailImageView.bounds.width - sideMargin)
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
                slideDidComplete?()
                return
            }
            
            let animationVelocity: Double = 0.5
            UIView.animate(withDuration: animationVelocity) {
                self.leadingThumbnailViewConstraint?.constant = self.sideMargin
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
        self.addSubview(descriptionLabel)
        self.addSubview(endCircleView)
        self.addSubview(dragAreaView)
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

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        dragAreaView.translatesAutoresizingMaskIntoConstraints = false
        dragAreaView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: sideMargin).isActive = true
        dragAreaView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: sideMargin).isActive = true
        dragAreaView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        dragAreaView.trailingAnchor.constraint(equalTo: thumnailImageView.trailingAnchor).isActive = true
        
        thumnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumnailImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        thumnailImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        thumnailImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leadingThumbnailViewConstraint = thumnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: sideMargin)
        leadingThumbnailViewConstraint?.isActive = true
        
        endCircleView.translatesAutoresizingMaskIntoConstraints = false
        endCircleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        endCircleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        endCircleView.topAnchor.constraint(equalTo: self.topAnchor, constant: sideMargin).isActive = true
        endCircleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        endCircleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -sideMargin).isActive = true
    }
}

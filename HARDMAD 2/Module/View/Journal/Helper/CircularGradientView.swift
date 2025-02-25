//
//  CircularGradientView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//


import UIKit

class CircularGradientView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let trackLayer = CAShapeLayer()
    private let animationDuration: CFTimeInterval = 2.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        startAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        startAnimation()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }

    private func setupLayers() {
        trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 24
        trackLayer.lineCap = .round
        trackLayer.lineJoin = .round
        layer.addSublayer(trackLayer)

        let lgrayCircle = UIColor(named: "lgrayCircle")

        gradientLayer.type = .conic
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            lgrayCircle ?? UIColor.gray.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)

        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = trackLayer.lineWidth
        maskLayer.lineCap = .round
        maskLayer.lineJoin = .round
        gradientLayer.mask = maskLayer

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - trackLayer.lineWidth / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = CGFloat.pi * 1.5

        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        maskLayer.path = path.cgPath
    }

    private func updateLayers() {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: (min(bounds.width, bounds.height) - trackLayer.lineWidth) / 2,
            startAngle: -.pi / 2,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )

        trackLayer.path = circularPath.cgPath
        gradientLayer.frame = bounds
        (gradientLayer.mask as? CAShapeLayer)?.path = circularPath.cgPath
    }

    private func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = animationDuration
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        gradientLayer.add(rotationAnimation, forKey: "rotation")
    }
}

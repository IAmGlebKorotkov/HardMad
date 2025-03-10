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
    private let progressLayer = CAShapeLayer()
    
    private let animationDuration: CFTimeInterval = 2.0
    private var emotionColors: [UIColor] = []

    init(frame: CGRect, emotionColors: [UIColor]) {
        self.emotionColors = emotionColors
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
        // Настройка trackLayer
        trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 24
        trackLayer.lineCap = .round
        trackLayer.lineJoin = .round
        layer.addSublayer(trackLayer)
        
        // Настройка progressLayer
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 24
        progressLayer.lineCap = .round
        progressLayer.lineJoin = .round
        layer.addSublayer(progressLayer)
        
        // Настройка gradientLayer
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
        
        // Настройка маски для gradientLayer
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = trackLayer.lineWidth
        maskLayer.lineCap = .round
        maskLayer.lineJoin = .round
        gradientLayer.mask = maskLayer

        // Обновление цветов градиента
        updateGradientColors()
    }

    private func updateLayers() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - trackLayer.lineWidth) / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = 3 * CGFloat.pi / 2

        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        trackLayer.path = circularPath.cgPath
        
        if emotionColors.count == 1 {
            let halfCirclePath = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: startAngle + CGFloat.pi,
                clockwise: true
            )
            progressLayer.path = halfCirclePath.cgPath
            progressLayer.strokeColor = emotionColors.first?.cgColor
            gradientLayer.isHidden = true
            progressLayer.isHidden = false
        } else {
            // Настройка маски для gradientLayer
            (gradientLayer.mask as? CAShapeLayer)?.path = circularPath.cgPath
            gradientLayer.isHidden = false
            progressLayer.isHidden = true
        }
        
        gradientLayer.frame = bounds
    }

    private func updateGradientColors() {
        if !emotionColors.isEmpty {
            let colorCounts = Dictionary(emotionColors.map { ($0, 1) }, uniquingKeysWith: +)
            let sortedColors = Array(colorCounts.keys)
            let counts = Array(colorCounts.values)
            let totalCount = counts.reduce(0, +)

            var colors: [CGColor] = []
            var locations: [NSNumber] = [0.0]
            var currentLocation: Double = 0.0

            for (color, count) in zip(sortedColors, counts) {
                let step = Double(count) / Double(totalCount)
                colors.append(color.cgColor)
                currentLocation += step
                locations.append(NSNumber(value: currentLocation))
            }

            // Если цвет только один, дублируем его
            if colors.count == 1 {
                colors.append(UIColor.clear.cgColor)
                locations = [0.0, 1.0]
            }

            gradientLayer.colors = colors
            gradientLayer.locations = locations
        } else {
            let lgrayCircle = UIColor(named: "lgrayCircle") ?? UIColor.gray
            gradientLayer.colors = [UIColor.clear.cgColor, lgrayCircle.cgColor]
            gradientLayer.locations = [0, 0.5, 1]
        }
    }

    private func startAnimation() {
        if emotionColors.isEmpty {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = 2 * CGFloat.pi
            rotationAnimation.duration = animationDuration
            rotationAnimation.repeatCount = .infinity
            rotationAnimation.isRemovedOnCompletion = false
            gradientLayer.add(rotationAnimation, forKey: "rotation")
        }
    }
}

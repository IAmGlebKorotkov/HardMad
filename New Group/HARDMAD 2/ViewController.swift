//
//  ViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 19.02.2025.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = AnimatedGradientView(frame: view.bounds)
        view.addSubview(gradientView)
    }
}

class AnimatedGradientView: UIView {
    
    private var gradientLayers: [CAGradientLayer] = []
    private let colors: [UIColor] = [.red, .green, .blue, .orange]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayers()
        startAnimation()
        addBlurEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayers()
        startAnimation()
        addBlurEffect()
    }
    
    private func setupGradientLayers() {
        for color in colors {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [color.withAlphaComponent(0.8).cgColor, color.withAlphaComponent(0.2).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.type = .radial
            
            // Делаем слой квадратным
            let size = max(bounds.width, bounds.height) // Размер круга
            gradientLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
            gradientLayer.position = CGPoint(x: bounds.midX, y: bounds.midY) // Центрируем
            
            // Делаем слой круглым
            gradientLayer.cornerRadius = size / 2
            gradientLayer.masksToBounds = true
            
            layer.addSublayer(gradientLayer)
            gradientLayers.append(gradientLayer)
        }
    }
    
    private func startAnimation() {
        for gradientLayer in gradientLayers {
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = CGPoint(x: bounds.midX, y: bounds.midY)
            animation.toValue = CGPoint(x: CGFloat.random(in: 0...bounds.width),
                                        y: CGFloat.random(in: 0...bounds.height))
            animation.duration = 4.0
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            gradientLayer.add(animation, forKey: nil)
        }
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

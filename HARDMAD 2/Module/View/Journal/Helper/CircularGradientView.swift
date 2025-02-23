import UIKit

class CircularGradientView: UIView {
    
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    private let trackLayer = CAShapeLayer()
    private let animationDuration: CFTimeInterval = 2.0
    
    // MARK: - Initialization
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
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    // MARK: - Layer Setup
    private func setupLayers() {
        // Настройка фонового круга
        trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 8
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        // Настройка градиентного слоя
        gradientLayer.type = .conic
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.blue.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
        
        // Маска для градиента
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineWidth = trackLayer.lineWidth
        maskLayer.lineCap = .round
        gradientLayer.mask = maskLayer
    }
    
    private func updateLayers() {
        // Рассчитываем круг с отступом
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: (min(bounds.width, bounds.height) - trackLayer.lineWidth) / 2,
            startAngle: -.pi/2,
            endAngle: 3 * .pi/2,
            clockwise: true
        )
        
        trackLayer.path = circularPath.cgPath
        gradientLayer.frame = bounds
        (gradientLayer.mask as? CAShapeLayer)?.path = circularPath.cgPath
    }
    
    // MARK: - Animation
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
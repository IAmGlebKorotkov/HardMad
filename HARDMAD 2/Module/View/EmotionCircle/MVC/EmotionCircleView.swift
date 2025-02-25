//
//  EmotionCircleView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 24.02.2025.
//

// EmotionCircleView.swift
import UIKit

protocol EmotionCircleViewDelegate: AnyObject {
    func didTapEmotionCircle(_ circle: EmotionCircleView)
}

final class EmotionCircleView: UIView {
    private let label = UILabel()
    weak var delegate: EmotionCircleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emotion: EmotionItem) {
        backgroundColor = emotion.color
        label.text = emotion.description
    }
    
    private func setupView() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
        
        label.textColor = .black
        label.font = UIFont(name: "Gwen-Trial-Bold", size: 10)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    @objc private func handleTap() {
        delegate?.didTapEmotionCircle(self)
    }
}

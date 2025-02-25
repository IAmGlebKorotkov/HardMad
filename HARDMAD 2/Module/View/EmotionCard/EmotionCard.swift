//
//  EmotionCard.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 25.02.2025.
//

import UIKit


class EmotionCardView: UIView {
    var emotionLabel: UILabel
    var dateLabel: UILabel
    private var textGradientLayer: CAGradientLayer?
    private var textMaskLayer: CATextLayer?

    init(frame: CGRect, TextColor: UIColor, text: String) {
        self.emotionLabel = UILabel()
        self.dateLabel = UILabel()
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: TextColor, text: text)
    }

    required init?(coder: NSCoder) {
        self.emotionLabel = UILabel()
        self.dateLabel = UILabel()
        super.init(coder: coder)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: .gray, text: "Default Text")
    }

    private func setupButton(buttonColor: UIColor, text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .darkGray
        
        var imageName = ""
        if buttonColor == .lblue{
            imageName = "SSad"
        }
        else if buttonColor == .lred {
            imageName = "SFlower"
        }
        else if buttonColor == .lorange {
            imageName = "SLight"
        }
        else if buttonColor == .lgreen {
            imageName = "SMithosis"
        }
        
        let image = UIImage(named: imageName)
        let ImageView = UIImageView(image: image)
        
        addSubview(ImageView)
        addSubview(emotionLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            ImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            ImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            ImageView.widthAnchor.constraint(equalToConstant: 60),
            ImageView.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            emotionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            emotionLabel.trailingAnchor.constraint(lessThanOrEqualTo: ImageView.leadingAnchor, constant: -8),
            emotionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            emotionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: ImageView.leadingAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: emotionLabel.bottomAnchor, constant: 4),
            dateLabel.heightAnchor.constraint(equalToConstant: 16)
        ])

        setupGradientText(text: text, color: buttonColor)
    }

    private func setupGradientText(text: String, color: UIColor) {
        textGradientLayer?.removeFromSuperlayer()
        textMaskLayer?.removeFromSuperlayer()

        emotionLabel.text = text
        emotionLabel.sizeToFit()

        let lighterColor = color.withAlphaComponent(0.3)

        let gradient = CAGradientLayer()
        gradient.colors = [lighterColor.cgColor, color.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = emotionLabel.bounds
        textGradientLayer = gradient

        let maskLayer = CATextLayer()
        maskLayer.string = text
        maskLayer.font = UIFont.boldSystemFont(ofSize: 16)
        maskLayer.fontSize = emotionLabel.font.pointSize
        maskLayer.foregroundColor = UIColor.black.cgColor
        maskLayer.alignmentMode = .left
        maskLayer.frame = emotionLabel.bounds
        maskLayer.contentsScale = UIScreen.main.scale
        textMaskLayer = maskLayer

        gradient.mask = maskLayer
        emotionLabel.layer.addSublayer(gradient)
    }

    func updateButton(buttonColor: UIColor, text: String) {
        setupGradientText(text: text, color: buttonColor)
        dateLabel.text = text
    }
}


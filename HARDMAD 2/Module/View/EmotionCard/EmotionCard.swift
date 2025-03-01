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
    private var contentView: UIView
    private var gradientLayer: CAGradientLayer?

    init(frame: CGRect, TextColor: UIColor, text: String) {
        self.emotionLabel = UILabel()
        self.dateLabel = UILabel()
        self.contentView = UIView()
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: TextColor, text: text)
    }

    required init?(coder: NSCoder) {
        self.emotionLabel = UILabel()
        self.dateLabel = UILabel()
        self.contentView = UIView()
        super.init(coder: coder)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: .gray, text: "Default Text")
    }

    private func setupButton(buttonColor: UIColor, text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lStaticB
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        
        var dateString = ""
        if calendar.isDateInToday(currentDate) {
            dateString = "cегодня, \(dateFormatter.string(from: currentDate))"
        } else if calendar.isDateInYesterday(currentDate) {
            dateString = "cчера, \(dateFormatter.string(from: currentDate))"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
            dateString = dateFormatter.string(from: currentDate)
        }
        
        dateLabel.text = dateString
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 14)
        
        let feelingLabel = UILabel()
        feelingLabel.text = "я чувствую"
        feelingLabel.textColor = .white
        feelingLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 20)
        
        var imageName = ""
        if buttonColor == .lblue {
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
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        // Добавляем feelingLabel, emotionLabel и imageView в contentView
        contentView.addSubview(feelingLabel)
        contentView.addSubview(emotionLabel)
        contentView.addSubview(imageView)
        
        addSubview(dateLabel)

        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        feelingLabel.translatesAutoresizingMaskIntoConstraints = false // Отключаем autoresizing mask
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        emotionLabel.numberOfLines = 0
        emotionLabel.lineBreakMode = .byWordWrapping
        emotionLabel.textColor = buttonColor
        emotionLabel.font = UIFont(name: "Gwen-Trial-Bold", size: 28)
        emotionLabel.text = text

        NSLayoutConstraint.activate([
            // Расположение dateLabel
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateLabel.heightAnchor.constraint(equalToConstant: 28),
            
            // Расположение contentView (на 40 пикселей ниже dateLabel)
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 35),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Расположение imageView внутри contentView
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Расположение feelingLabel внутри contentView
            feelingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            feelingLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -16),
            feelingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            feelingLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Расположение emotionLabel внутри contentView
            emotionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emotionLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -16),
            emotionLabel.topAnchor.constraint(equalTo: feelingLabel.bottomAnchor, constant: 8), // emotionLabel ниже feelingLabel
            emotionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        setupGradientBackground(color: buttonColor)
    }

    private func setupGradientBackground(color: UIColor) {
        gradientLayer?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.colors = [
            color.withAlphaComponent(0.3).cgColor,
            color.withAlphaComponent(0.2).cgColor,
            color.withAlphaComponent(0.1).cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = self.bounds
    }

    func updateButton(buttonColor: UIColor, text: String) {
        emotionLabel.text = text
        dateLabel.text = text
        setupGradientBackground(color: buttonColor)
    }
}

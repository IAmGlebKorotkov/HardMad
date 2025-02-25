//
//  PickButton.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 24.02.2025.
//
import UIKit

struct ColorDesc {
    let clr: UIColor
    let desc: String
}

class PickButtonView: UIView {
    let pickButton: UIButton
    var textLabel: UILabel
    var adviceLabel: UILabel // Новый лейбл для совета
    private var textGradientLayer: CAGradientLayer?
    private var textMaskLayer: CATextLayer?

    // Словарь советов для эмоций
    let adviceDict: [String: String] = [
        "Ярость": "Глубоко вдохните, отойдите на минуту",
        "Напряжение": "Попробуйте расслабляющие упражнения",
        "Возбуждение": "Используйте энергию конструктивно",
        "Восторг": "Разделите радость с близкими",
        "Зависть": "Сфокусируйтесь на своих достижениях",
        "Беспокойство": "Запишите тревожащие мысли",
        "Счастье": "Насладитесь моментом!",
        "Уверенность": "Продолжайте в том же духе!",
        "Выгорание": "Позвольте себе отдых",
        "Усталость": "Ощущение, что необходимо отдохнуть",
        "Спокойствие": "Сохраните это состояние",
        "Удовлетворение": "Отметьте свои достижения",
        "Депрессия": "Важно обратиться за поддержкой",
        "Апатия": "Попробуйте найти маленькие радости",
        "Благодарность": "Выразите её кому-то",
        "Защищенность": "Это прекрасно – цените это"
    ]

    init(frame: CGRect, buttonColor: UIColor, text: String) {
        self.pickButton = UIButton(type: .system)
        self.textLabel = UILabel()
        self.adviceLabel = UILabel()
        super.init(frame: frame)
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        setupButton(buttonColor: buttonColor, text: text)
    }

    required init?(coder: NSCoder) {
        self.pickButton = UIButton(type: .system)
        self.textLabel = UILabel()
        self.adviceLabel = UILabel()
        super.init(coder: coder)
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        setupButton(buttonColor: .gray, text: "Default Text")
    }

    private func setupButton(buttonColor: UIColor, text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .darkGray

        if let icon = UIImage(named: "Arrow Right")?.withRenderingMode(.alwaysOriginal) {
            pickButton.setImage(icon.withTintColor(.black), for: .normal)
        }
        pickButton.backgroundColor = .white
        pickButton.layer.cornerRadius = 32
        pickButton.clipsToBounds = true
        pickButton.contentHorizontalAlignment = .center
        pickButton.layer.zPosition = 1
        pickButton.translatesAutoresizingMaskIntoConstraints = false

        textLabel.text = text
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.textAlignment = .left
        textLabel.textColor = .clear
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        adviceLabel.text = getAdvice(for: text)
        adviceLabel.font = UIFont.systemFont(ofSize: 12)
        adviceLabel.textAlignment = .left
        adviceLabel.textColor = .white
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(pickButton)
        addSubview(textLabel)
        addSubview(adviceLabel)

        NSLayoutConstraint.activate([
            pickButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            pickButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            pickButton.widthAnchor.constraint(equalToConstant: 64),
            pickButton.heightAnchor.constraint(equalToConstant: 64)
        ])

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textLabel.trailingAnchor.constraint(lessThanOrEqualTo: pickButton.leadingAnchor, constant: -8),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            textLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            adviceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            adviceLabel.trailingAnchor.constraint(lessThanOrEqualTo: pickButton.leadingAnchor, constant: -8),
            adviceLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4),
            adviceLabel.heightAnchor.constraint(equalToConstant: 16)
        ])

        setupGradientText(text: text, color: buttonColor)
    }

    private func setupGradientText(text: String, color: UIColor) {
        textGradientLayer?.removeFromSuperlayer()
        textMaskLayer?.removeFromSuperlayer()

        textLabel.text = text
        textLabel.sizeToFit()

        let lighterColor = color.withAlphaComponent(0.3)

        let gradient = CAGradientLayer()
        gradient.colors = [lighterColor.cgColor, color.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = textLabel.bounds
        textGradientLayer = gradient

        let maskLayer = CATextLayer()
        maskLayer.string = text
        maskLayer.font = UIFont.boldSystemFont(ofSize: 16)
        maskLayer.fontSize = textLabel.font.pointSize
        maskLayer.foregroundColor = UIColor.black.cgColor
        maskLayer.alignmentMode = .left
        maskLayer.frame = textLabel.bounds
        maskLayer.contentsScale = UIScreen.main.scale
        textMaskLayer = maskLayer

        gradient.mask = maskLayer
        textLabel.layer.addSublayer(gradient)
    }

    func updateButton(buttonColor: UIColor, text: String) {
        setupGradientText(text: text, color: buttonColor)
        adviceLabel.text = getAdvice(for: text)
    }

    private func getAdvice(for emotion: String) -> String {
        return adviceDict[emotion] ?? "Прислушайтесь к себе"
    }
}

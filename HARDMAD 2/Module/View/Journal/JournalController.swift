//
//  File.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//
import UIKit

class JournalController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let label = UILabel()
        label.text = "Что вы сейчас\nчувствуете?"
        label.textColor = .white
        label.font = UIFont(name: "Gwen-Trial-Bold", size: 36)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.layer.zPosition = 1

        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 132)
        ])
        
        let plusButton = PlusButtonView()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)
        plusButton.layer.zPosition = 1
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 385),
            plusButton.widthAnchor.constraint(equalToConstant: 132),
            plusButton.heightAnchor.constraint(equalToConstant: 97)
        ])
        
        let circleGradient = CircularGradientView()
        circleGradient.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleGradient)
        view.sendSubviewToBack(circleGradient)
        
        NSLayoutConstraint.activate([
            circleGradient.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleGradient.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleGradient.widthAnchor.constraint(equalToConstant: 364),
            circleGradient.heightAnchor.constraint(equalToConstant: 364)
        ])
        
        let staticView = StaticButtonView()
        staticView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(staticView)
        view.sendSubviewToBack(staticView)
        
        NSLayoutConstraint.activate([
            staticView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            staticView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            staticView.widthAnchor.constraint(equalToConstant: 364),
            staticView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        if let button = plusButton.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func plusButtonTapped() {
        let emotionsViewController = EmotionViewController()
        self.navigationController?.pushViewController(emotionsViewController, animated: false)
    }
}

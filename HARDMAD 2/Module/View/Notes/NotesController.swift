//
//  NotesController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 26.02.2025.
//

import UIKit

class NotesController: UIViewController {
    var emotionColor: UIColor
    var emotionText: String
    
    var activity: [String] = ["Прием пищи", "Встреча с друзьями",
                              "Тренировка"]
    var freinds: [String] = ["Один", "Друзья", "Семья", "Коллеги", "Партнер"]
    var place: [String] = ["Дом", "Работа", "Школа", "Транспорт", "Улица"]
    
    
    init(emotionColor: UIColor, emotionText: String) {
        self.emotionColor = emotionColor
        self.emotionText = emotionText
        super.init(nibName: nil, bundle: nil)
        print("Emotion Text: \(emotionText)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        let emotionCardView = EmotionCardView(
            frame: .zero,
            TextColor: emotionColor,
            text: emotionText
        )
        
        let leftButton = LeftButtonView()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.layer.zPosition = 10
        view.addSubview(leftButton)
        view.bringSubviewToFront(leftButton)
        
        NSLayoutConstraint.activate([
            leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            leftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            leftButton.widthAnchor.constraint(equalToConstant: 40),
            leftButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let activityView = TagSelectionView(title: "что вы чувствуете?", options: activity)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
        view.bringSubviewToFront(activityView)
        
        let placeView = TagSelectionView(title: "где вы вы были?", options: place)
        placeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeView)
        view.bringSubviewToFront(placeView)
        
        let freindsView = TagSelectionView(title: "с кем вы были?", options: freinds)
        freindsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(freindsView)
        view.bringSubviewToFront(freindsView)
        
        NSLayoutConstraint.activate([
            activityView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            activityView.topAnchor.constraint(equalTo: view.topAnchor, constant: 312),
            activityView.widthAnchor.constraint(equalToConstant: 400),
            activityView.heightAnchor.constraint(equalToConstant: 148),
            
            placeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            placeView.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: 0),
            placeView.widthAnchor.constraint(equalToConstant: 400),
            placeView.heightAnchor.constraint(equalToConstant: 150),
            
            freindsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            freindsView.topAnchor.constraint(equalTo: placeView.bottomAnchor, constant: 0),
            freindsView.widthAnchor.constraint(equalToConstant: 400),
            freindsView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        if let button = leftButton.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        }
        // Добавляем EmotionCardView на экран
        self.view.addSubview(emotionCardView)
        
        // Настраиваем Auto Layout для EmotionCardView
        emotionCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emotionCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emotionCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emotionCardView.heightAnchor.constraint(equalToConstant: 158),
            emotionCardView.widthAnchor.constraint(equalToConstant: 364)
        ])
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("сохранить", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 16)
        saveButton.tintColor = .black
        saveButton.backgroundColor = .white
        saveButton.layer.cornerRadius = 28
        saveButton.clipsToBounds = true

        saveButton.contentHorizontalAlignment = .center
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.layer.zPosition = 1

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 764),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            saveButton.widthAnchor.constraint(equalToConstant: 364)
        ])
    }
    
    @objc func leftButtonTapped() {
        let emotionViewController = EmotionViewController()
        self.navigationController?.pushViewController(emotionViewController, animated: false)
    }
    
    @objc func saveButtonTapped() {
        let journalViewController = JournalController(emotionColor: emotionColor, emotionText: emotionText)
        self.navigationController?.pushViewController(journalViewController, animated: false)
    }
}

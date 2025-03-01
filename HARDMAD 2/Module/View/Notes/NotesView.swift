//
//  notesView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 25.02.2025.
//

import UIKit

class TagSelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let titleLabel = UILabel()
    private var collectionView: UICollectionView!
    
    private var options: [String] = []
    
    
    init(title: String, options: [String]) {
        super.init(frame: .zero)
        self.options = options + ["+"] // "+" всегда в конце
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {
        backgroundColor = .black
        layer.cornerRadius = 10
        
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 16)
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        
        addSubview(titleLabel)
        addSubview(collectionView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.configure(with: options[indexPath.item])
        cell.onAddNewTag = { [weak self] newTag in
            self?.addNewTag(newTag)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = options[indexPath.item]
        let font = UIFont.systemFont(ofSize: 16)
        let padding: CGFloat = 32
        
        let textSize = text.size(withAttributes: [.font: font])
        
        // Проверяем, что размер текста корректен
        guard !textSize.width.isNaN, !textSize.width.isInfinite, textSize.width > 0 else {
            return CGSize(width: 50, height: 36) // Возвращаем размер по умолчанию
        }
        
        let textWidth = textSize.width + padding
        
        return CGSize(width: min(textWidth, collectionView.frame.width - 20), height: 36)
    }
    
    // Добавление нового тега
    private func addNewTag(_ newTag: String) {
        if let lastIndex = options.lastIndex(of: "+") {
            options.insert(newTag, at: lastIndex)
            collectionView.reloadData()
        }
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin: CGFloat = 0
        var lastY: CGFloat = -1
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y != lastY {
                leftMargin = 0
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            lastY = layoutAttribute.frame.origin.y
        }
        return attributes
    }
}

class TagCell: UICollectionViewCell, UITextFieldDelegate {
    private let tagButton = UIButton(type: .system)
    private let textField = UITextField()
    private var textFieldWidthConstraint: NSLayoutConstraint!
    
    var onAddNewTag: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupTextField()
        setupTapGesture()
    }
    
    private func setupButton() {
        tagButton.layer.cornerRadius = 18
        tagButton.backgroundColor = .lStaticB
        tagButton.setTitleColor(.white, for: .normal)
        tagButton.titleLabel?.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 14)
        tagButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        contentView.addSubview(tagButton)
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupTextField() {
        textField.backgroundColor = UIColor.darkGray
        textField.textColor = .white
        textField.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 14)
        textField.layer.cornerRadius = 18
        textField.textAlignment = .center
        textField.isHidden = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textFieldWidthConstraint = textField.widthAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textFieldWidthConstraint
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapGesture.cancelsTouchesInView = false
        contentView.window?.addGestureRecognizer(tapGesture)
    }
    
    func configure(with text: String) {
        tagButton.setTitle(text, for: .normal)
    }
    
    @objc private func didTapButton() {
        if tagButton.title(for: .normal) == "+" {
            tagButton.isHidden = true
            textField.isHidden = false
            textField.becomeFirstResponder()
        }
        else{
            if tagButton.backgroundColor == .lGrayCircle{
                tagButton.backgroundColor = .lStaticB
            }
            else{
                tagButton.backgroundColor = .lGrayCircle
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        guard let text = textField.text, !text.isEmpty else {
            return
        }

        let font = textField.font ?? UIFont.systemFont(ofSize: 16)
        let textSize = text.size(withAttributes: [.font: font])
        
        guard !textSize.width.isNaN, !textSize.width.isInfinite, textSize.width > 0 else {
            return
        }
        
        let padding: CGFloat = 32
        let textWidth = textSize.width + padding
        let maxWidth = UIScreen.main.bounds.width - 40
        
        textFieldWidthConstraint.constant = min(max(50, textWidth), maxWidth)
        layoutIfNeeded()
    }
    
    @objc private func handleTapOutside() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
            saveInput()
        }
    }
    
    private func saveInput() {
        guard let text = textField.text, !text.isEmpty else {
            tagButton.isHidden = false
            textField.isHidden = true
            return
        }
        
        onAddNewTag?(text)
        tagButton.isHidden = false
        textField.isHidden = true
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveInput()
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

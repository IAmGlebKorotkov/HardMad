//
//  EmotionViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 24.02.2025.
//

import UIKit

class EmotionViewController: UIViewController, UIScrollViewDelegate {
    struct ColorDesc {
        let clr: UIColor
        let desc: String
    }
    var EmotionString = ""
    var EmotionColor: UIColor = .black
    let colors: [ColorDesc] = [
        ColorDesc(clr: .lred, desc: "Ярость"),
        ColorDesc(clr: .lred, desc: "Напряжение"),
        ColorDesc(clr: .lorange, desc: "Возбуждение"),
        ColorDesc(clr: .lorange, desc: "Восторг"),
        ColorDesc(clr: .lred, desc: "Зависть"),
        ColorDesc(clr: .lred, desc: "Беспокойство"),
        ColorDesc(clr: .lorange, desc: "Счастье"),
        ColorDesc(clr: .lorange, desc: "Уверенность"),
        ColorDesc(clr: .lblue, desc: "Выгорание"),
        ColorDesc(clr: .lblue, desc: "Усталость"),
        ColorDesc(clr: .lgreen, desc: "Спокойствие"),
        ColorDesc(clr: .lgreen, desc: "Удовлетворение"),
        ColorDesc(clr: .lblue, desc: "Депрессия"),
        ColorDesc(clr: .lblue, desc: "Апатия"),
        ColorDesc(clr: .lgreen, desc: "Благодарность"),
        ColorDesc(clr: .lgreen, desc: "Защищенность"),
    ]
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var circleViews: [[UIView]] = []
    
    private let gridSize = 4
    private let circleSize: CGFloat = 112
    private let spacing: CGFloat = 5
    private let maxScale: CGFloat = 152 / 112
    private let offsetDistance: CGFloat = 20
    
    private var pickButtonView: PickButtonView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        contentView.isUserInteractionEnabled = false
        setupScrollView()
        setupCircles()
        
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
        
        if let button = leftButton.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        }
        
        pickButtonView = PickButtonView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
                                        buttonColor: .blue,
                                        text: "Нажми меня")
        pickButtonView?.translatesAutoresizingMaskIntoConstraints = false
        pickButtonView?.layer.zPosition = 10
        view.addSubview(pickButtonView!)
        view.bringSubviewToFront(pickButtonView!)

        NSLayoutConstraint.activate([
            pickButtonView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickButtonView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 764),
            pickButtonView!.widthAnchor.constraint(equalToConstant: 384),
            pickButtonView!.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        if let button = pickButtonView?.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.addTarget(self, action: #selector(pickButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        scrollView.panGestureRecognizer.cancelsTouchesInView = false
        scrollView.backgroundColor = .black
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        let squareSize = CGFloat(gridSize) * (circleSize + spacing)
        
        let scaleFactor: CGFloat = 2.5
        let contentSize = CGSize(
            width: squareSize * scaleFactor,
            height: squareSize * scaleFactor
        )
        
        contentView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        scrollView.addSubview(contentView)
        
        scrollView.contentSize = contentSize
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let centerOffsetX = (contentSize.width - scrollView.frame.width) / 2
        let centerOffsetY = (contentSize.height - scrollView.frame.height) / 2
        scrollView.contentOffset = CGPoint(x: centerOffsetX, y: centerOffsetY)
    }
    
    private func setupCircles() {

        let squareSize = CGFloat(gridSize) * (circleSize + spacing)
        let startX = (scrollView.contentSize.width - squareSize) / 2
        let startY = (scrollView.contentSize.height - squareSize) / 2
        
        for row in 0..<gridSize {
            var rowCircles: [UIView] = []
            for col in 0..<gridSize {
                let circle = UIView()
                circle.backgroundColor = colors[row * gridSize + col].clr
                let emotionLabel = UILabel()
                emotionLabel.text = colors[row * gridSize + col].desc
                emotionLabel.textColor = .black
                emotionLabel.font = UIFont(name: "Gwen-Trial-Bold", size: 10)
                emotionLabel.textAlignment = .center
                emotionLabel.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
                emotionLabel.numberOfLines = 0
                emotionLabel.adjustsFontSizeToFitWidth = true
                
                circle.addSubview(emotionLabel)
                circle.layer.cornerRadius = circleSize / 2
                circle.clipsToBounds = true
                
                let x = startX + CGFloat(col) * (circleSize + spacing)
                let y = startY + CGFloat(row) * (circleSize + spacing)
                circle.frame = CGRect(x: x, y: y, width: circleSize, height: circleSize)
                
                // Добавляем жест нажатия
                let tap = UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:)))
                circle.addGestureRecognizer(tap)
                circle.isUserInteractionEnabled = false
                
                contentView.addSubview(circle)
                rowCircles.append(circle)
            }
            circleViews.append(rowCircles)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(
            x: scrollView.contentOffset.x + scrollView.bounds.size.width / 2,
            y: scrollView.contentOffset.y + scrollView.bounds.size.height / 2
        )
        
        var closestCircle: UIView?
        var closestRow = 0
        var closestCol = 0
        var minDistance: CGFloat = .greatestFiniteMagnitude
        
        for (row, rowCircles) in circleViews.enumerated() {
            for (col, circle) in rowCircles.enumerated() {
                let distance = distanceBetween(circle.center, centerPoint)
                if distance < minDistance {
                    minDistance = distance
                    closestCircle = circle
                    closestRow = row
                    closestCol = col
                }
            }
        }
        
        animateCircles(closestToCenter: closestCircle, row: closestRow, col: closestCol)
        
        if let closestCircle = closestCircle {
            EmotionString = colors[closestRow * gridSize + closestCol].desc
            EmotionColor = colors[closestRow * gridSize + closestCol].clr
            pickButtonView?.updateButton(
                buttonColor: EmotionColor,
                text: EmotionString
            )
        }
    }
    
    private func animateCircles(closestToCenter: UIView?, row: Int, col: Int) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            for (r, rowCircles) in self.circleViews.enumerated() {
                for (c, circle) in rowCircles.enumerated() {
                    if circle == closestToCenter {
                        circle.transform = CGAffineTransform(scaleX: self.maxScale, y: self.maxScale)
                        circle.isUserInteractionEnabled = true
                    } else if r == row || c == col { // Отдаляем круги в одной строке или колонке
                        let dx = (c == col) ? 0 : (c < col ? -self.offsetDistance : self.offsetDistance)
                        let dy = (r == row) ? 0 : (r < row ? -self.offsetDistance : self.offsetDistance)
                        
                        circle.transform = CGAffineTransform(translationX: dx, y: dy)
                        circle.isUserInteractionEnabled = false
                    } else {
                        circle.transform = .identity
                        circle.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    private func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    @objc private func circleTapped(_ sender: UITapGestureRecognizer) {
        guard let circle = sender.view else { return }
        circle.backgroundColor = .white
    }
    
    @objc func leftButtonTapped() {
        let journalController = JournalController()
        self.navigationController?.pushViewController(journalController, animated: false)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func pickButtonTapped() {
        let notesController = NotesController(
            emotionColor: EmotionColor,
            emotionText: EmotionString
        )
        self.navigationController?.pushViewController(notesController, animated: false)
    }
}

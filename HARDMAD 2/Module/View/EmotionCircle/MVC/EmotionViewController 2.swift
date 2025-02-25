//
//  EmotionViewController 2.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 24.02.2025.
//

import UIKit

final class EmotionViewController2: UIViewController, UIScrollViewDelegate, EmotionCircleViewDelegate {
    private let model = EmotionModel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var circleViews: [[EmotionCircleView]] = []
    
    private let gridSize = 4
    private let circleSize: CGFloat = 112
    private let spacing: CGFloat = 5
    private let maxScale: CGFloat = 152 / 112
    private let offsetDistance: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .clear
        setupUI()
        setupCircles()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        navigationItem.setHidesBackButton(true, animated: false)
        setupScrollView()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.backgroundColor = .black
        scrollView.frame = view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
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
            var rowCircles: [EmotionCircleView] = []
            for col in 0..<gridSize {
                guard let emotion = model.emotionAt(row: row, column: col) else { continue }
                
                let circle = EmotionCircleView(frame: CGRect(
                    x: startX + CGFloat(col) * (circleSize + spacing),
                    y: startY + CGFloat(row) * (circleSize + spacing),
                    width: circleSize,
                    height: circleSize
                ))
                
                circle.configure(with: emotion)
                circle.delegate = self
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
        
        var closestCircle: EmotionCircleView?
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
    }
    
    private func animateCircles(closestToCenter: EmotionCircleView?, row: Int, col: Int) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            for (r, rowCircles) in self.circleViews.enumerated() {
                for (c, circle) in rowCircles.enumerated() {
                    if circle == closestToCenter {
                        circle.transform = CGAffineTransform(scaleX: self.maxScale, y: self.maxScale)
                    } else if r == row || c == col {
                        let dx = (c == col) ? 0 : (c < col ? -self.offsetDistance : self.offsetDistance)
                        let dy = (r == row) ? 0 : (r < row ? -self.offsetDistance : self.offsetDistance)
                        circle.transform = CGAffineTransform(translationX: dx, y: dy)
                    } else {
                        circle.transform = .identity
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
    
    func didTapEmotionCircle(_ circle: EmotionCircleView) {
        circle.backgroundColor = .white
    }
}

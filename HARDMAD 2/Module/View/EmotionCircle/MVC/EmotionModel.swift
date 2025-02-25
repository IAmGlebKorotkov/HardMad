//
//  EmotionItem.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 24.02.2025.
//

import UIKit

// EmotionModel.swift
import UIKit

struct EmotionItem {
    let color: UIColor
    let description: String
}

final class EmotionModel {
    private(set) var emotions: [EmotionItem] = []
    private let gridSize: Int
    
    init(gridSize: Int = 4) {
        self.gridSize = gridSize
        setupEmotions()
    }
    
    private func setupEmotions() {
        emotions = [
            EmotionItem(color: .lred, description: "Ярость"),
            EmotionItem(color: .lred, description: "Напряжение"),
            EmotionItem(color: .lorange, description: "Возбуждение"),
            EmotionItem(color: .lorange, description: "Восторг"),
            EmotionItem(color: .lred, description: "Зависть"),
            EmotionItem(color: .lred, description: "Беспокойство"),
            EmotionItem(color: .lorange, description: "Счастье"),
            EmotionItem(color: .lorange, description: "Уверенность"),
            EmotionItem(color: .lblue, description: "Выгорание"),
            EmotionItem(color: .lblue, description: "Усталость"),
            EmotionItem(color: .lgreen, description: "Спокойствие"),
            EmotionItem(color: .lgreen, description: "Удовлетворение"),
            EmotionItem(color: .lblue, description: "Депрессия"),
            EmotionItem(color: .lblue, description: "Апатия"),
            EmotionItem(color: .lgreen, description: "Благодарность"),
            EmotionItem(color: .lgreen, description: "Защищенность")
        ]
    }
    
    func emotionAt(row: Int, column: Int) -> EmotionItem? {
        let index = row * gridSize + column
        guard index < emotions.count else { return nil }
        return emotions[index]
    }
}

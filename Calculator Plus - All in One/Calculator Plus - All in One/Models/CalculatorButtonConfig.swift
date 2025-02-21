import SwiftUI

struct CalculatorButtonConfig: Hashable {
    let title: String
    let color: Color
    let action: Action
    let width: ButtonWidth
    
    init(
        title: String,
        color: Color = .gray,
        action: Action = .number,
        width: ButtonWidth = .single
    ) {
        self.title = title
        self.color = color
        self.action = action
        self.width = width
    }
    
    enum Action: Hashable {
        case number
        case operation(String)
        case equals
        case clear
        case decimal
        case negate
        case percentage
        case scientific(String)
        case memoryAdd
        case memorySubtract
        case memoryRecall
        case memoryClear
        case memoryStore
        case financial(String)
    }
    
    enum ButtonWidth {
        case single
        case double
    }
} 
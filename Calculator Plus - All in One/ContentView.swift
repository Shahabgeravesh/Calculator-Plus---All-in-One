//
//  ContentView.swift
//  Calculator Plus - All in One
//
//  Created by Shahab Geravesh on 2/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    private let buttons: [[CalculatorButton.Config]] = [
        [.init(title: "C", color: .gray, action: .clear),
         .init(title: "±", color: .gray, action: .negate),
         .init(title: "%", color: .gray, action: .percentage),
         .init(title: "÷", color: .orange, action: .operation("÷"))],
        
        [.init(title: "7"), .init(title: "8"), .init(title: "9"),
         .init(title: "×", color: .orange, action: .operation("×"))],
        
        [.init(title: "4"), .init(title: "5"), .init(title: "6"),
         .init(title: "-", color: .orange, action: .operation("-"))],
        
        [.init(title: "1"), .init(title: "2"), .init(title: "3"),
         .init(title: "+", color: .orange, action: .operation("+"))],
        
        [.init(title: "0", width: .double), .init(title: "."),
         .init(title: "=", color: .orange, action: .equals)]
    ]
    
    private var scientificButtons: [[CalculatorButton.Config]] {
        [
            [.init(title: "sin", color: .blue, action: .scientific("sin")),
             .init(title: "cos", color: .blue, action: .scientific("cos")),
             .init(title: "tan", color: .blue, action: .scientific("tan"))],
            [.init(title: "√", color: .blue, action: .scientific("√")),
             .init(title: "x²", color: .blue, action: .scientific("x²")),
             .init(title: "xʸ", color: .blue, action: .operation("xʸ"))],
            [.init(title: "log", color: .blue, action: .scientific("log")),
             .init(title: "ln", color: .blue, action: .scientific("ln")),
             .init(title: "π", color: .blue, action: .scientific("π"))],
            [.init(title: "M+", color: .blue, action: .memoryAdd),
             .init(title: "M-", color: .blue, action: .memorySubtract),
             .init(title: "MR", color: .blue, action: .memoryRecall)]
        ]
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Mode Selector
            Picker("Calculator Mode", selection: $viewModel.currentMode) {
                ForEach(CalculatorMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Display
            HStack {
                Spacer()
                Text(viewModel.displayValue)
                    .font(.system(size: 64))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding()
            }
            
            // Buttons Grid
            VStack(spacing: 8) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(row, id: \.title) { config in
                            CalculatorButton(
                                title: config.title,
                                color: config.color
                            ) {
                                handleButtonPress(config)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func handleButtonPress(_ config: CalculatorButton.Config) {
        switch config.action {
        case .number:
            if let number = Int(config.title) {
                viewModel.numberPressed(number)
            }
        case .operation(let op):
            viewModel.operationPressed(op)
        case .equals:
            viewModel.calculateResult()
        case .clear:
            viewModel.clear()
        case .decimal:
            viewModel.decimal()
        case .negate:
            viewModel.negate()
        case .percentage:
            viewModel.percentage()
        case .scientific(let op):
            viewModel.performScientificOperation(op)
        case .memoryAdd:
            viewModel.memoryAdd()
        case .memorySubtract:
            viewModel.memorySubtract()
        case .memoryRecall:
            viewModel.memoryRecall()
        }
    }
}

// Helper extension for CalculatorButton configuration
extension CalculatorButton {
    struct Config: Hashable {
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
        }
        
        enum ButtonWidth {
            case single
            case double
        }
    }
}

#Preview {
    ContentView()
}

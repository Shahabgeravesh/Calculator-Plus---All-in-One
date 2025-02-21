import SwiftUI

struct StandardCalculatorView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    private let buttons: [[CalculatorButtonConfig]] = [
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
    
    var body: some View {
        VStack(spacing: 12) {
            // Display
            HStack {
                Spacer()
                Text(viewModel.displayValue)
                    .font(.system(size: 64))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding()
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Buttons
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
                            .frame(maxWidth: config.width == .double ? .infinity : nil)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func handleButtonPress(_ config: CalculatorButtonConfig) {
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
        default:
            break
        }
    }
} 
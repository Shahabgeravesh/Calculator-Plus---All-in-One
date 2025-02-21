import SwiftUI

struct ScientificCalculatorView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    private let scientificButtons: [[CalculatorButtonConfig]] = [
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
    
    var body: some View {
        StandardCalculatorView(viewModel: viewModel)
            .overlay(
                VStack {
                    ForEach(scientificButtons, id: \.self) { row in
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
                    Spacer()
                }
                .padding()
            )
    }
    
    private func handleButtonPress(_ config: CalculatorButtonConfig) {
        switch config.action {
        case .scientific(let op):
            viewModel.performScientificOperation(op)
        case .memoryAdd:
            viewModel.memoryAdd()
        case .memorySubtract:
            viewModel.memorySubtract()
        case .memoryRecall:
            viewModel.memoryRecall()
        default:
            break
        }
    }
} 
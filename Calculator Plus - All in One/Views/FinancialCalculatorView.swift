import SwiftUI

struct FinancialCalculatorView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    private let financialButtons: [[CalculatorButtonConfig]] = [
        [.init(title: "Compound\nInterest", color: Color.blue, action: .financial("compound")),
         .init(title: "Loan\nPayment", color: Color.blue, action: .financial("loan")),
         .init(title: "Simple\nInterest", color: Color.blue, action: .financial("simple"))]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Form {
                Section("Input Values") {
                    HStack {
                        Text("Principal:")
                        TextField("Amount", value: $viewModel.principal, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Interest Rate (%):")
                        TextField("Rate", value: $viewModel.rate, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Time (Years):")
                        TextField("Years", value: $viewModel.periods, format: .number)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Result") {
                    Text(viewModel.displayValue)
                        .font(.title2)
                        .bold()
                }
            }
            
            // Financial Calculator Buttons
            VStack(spacing: 8) {
                ForEach(financialButtons, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(row, id: \.title) { config in
                            CalculatorButton(
                                title: config.title,
                                color: config.color
                            ) {
                                handleFinancialCalculation(config.action)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func handleFinancialCalculation(_ action: CalculatorButtonConfig.Action) {
        if case .financial(let type) = action {
            switch type {
            case "compound":
                viewModel.calculateCompoundInterest()
            case "loan":
                viewModel.calculateLoanPayment()
            case "simple":
                viewModel.calculateSimpleInterest()
            default:
                break
            }
        }
    }
}

#Preview {
    FinancialCalculatorView(viewModel: CalculatorViewModel())
} 
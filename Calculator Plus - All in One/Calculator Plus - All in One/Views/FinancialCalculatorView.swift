import SwiftUI

struct FinancialCalculatorView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @State private var selectedCalculation = FinancialCalculationType.compound
    @State private var showingHelp = false
    @State private var calculationDetails: [String: String] = [:]
    
    private let financialButtons: [[CalculatorButtonConfig]] = [
        [.init(title: "Compound\nInterest", color: Color.blue, action: .financial("compound")),
         .init(title: "Simple\nInterest", color: Color.blue, action: .financial("simple")),
         .init(title: "Loan\nPayment", color: Color.blue, action: .financial("loan"))],
        [.init(title: "Future\nValue", color: Color.green, action: .financial("future")),
         .init(title: "Present\nValue", color: Color.green, action: .financial("present")),
         .init(title: "Annuity", color: Color.green, action: .financial("annuity"))],
        [.init(title: "ROI", color: Color.purple, action: .financial("roi")),
         .init(title: "Break\nEven", color: Color.purple, action: .financial("breakeven")),
         .init(title: "Depreciation", color: Color.purple, action: .financial("depreciation"))]
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Form {
                    Section {
                        Picker("Calculation Type", selection: $selectedCalculation) {
                            ForEach(FinancialCalculationType.allCases, id: \.self) { type in
                                Text(type.description).tag(type)
                            }
                        }
                    } header: {
                        Text("Calculation Type")
                    } footer: {
                        Text(selectedCalculation.explanation)
                            .font(.caption)
                    }
                    
                    Section("Input Values") {
                        switch selectedCalculation {
                        case .compound, .simple:
                            basicInterestInputs
                        case .loan:
                            loanInputs
                        case .futureValue, .presentValue:
                            timeValueInputs
                        case .annuity:
                            annuityInputs
                        case .roi:
                            roiInputs
                        case .breakEven:
                            breakEvenInputs
                        case .depreciation:
                            depreciationInputs
                        }
                    }
                    
                    Section("Result") {
                        FinancialResultView(
                            title: selectedCalculation.description,
                            value: viewModel.displayValue,
                            details: calculationDetails
                        )
                    }
                }
                
                // Calculator Buttons
                VStack(spacing: 4) {
                    Text("Select Calculation Type")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(financialButtons, id: \.self) { row in
                                ForEach(row, id: \.title) { config in
                                    CalculatorButton(
                                        title: config.title,
                                        color: config.color
                                    ) {
                                        handleFinancialCalculation(config.action)
                                    }
                                    .frame(width: 100)  // Fixed width for consistency
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                )
                .overlay(
                    HStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color(.systemBackground), .clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 20)
                        
                        Spacer()
                        
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, Color(.systemBackground)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 20)
                    }
                )
                
                // Scroll indicator
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Scroll for more options")
                    Image(systemName: "chevron.right")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .padding(.bottom)
            .navigationTitle("Financial Calculator")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingHelp = true }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $showingHelp) {
                FinancialHelpView(calculationType: selectedCalculation)
            }
        }
    }
    
    private var basicInterestInputs: some View {
        Group {
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
    }
    
    private var loanInputs: some View {
        Group {
            HStack {
                Text("Loan Amount:")
                TextField("Amount", value: $viewModel.principal, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Interest Rate (%):")
                TextField("Rate", value: $viewModel.rate, format: .number)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Loan Term (Years):")
                TextField("Years", value: $viewModel.periods, format: .number)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private var annuityInputs: some View {
        Group {
            HStack {
                Text("Payment Amount:")
                TextField("Amount", value: $viewModel.payment, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Interest Rate (%):")
                TextField("Rate", value: $viewModel.rate, format: .number)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Number of Payments:")
                TextField("Payments", value: $viewModel.periods, format: .number)
                    .keyboardType(.numberPad)
            }
            
            Picker("Payment Frequency", selection: $viewModel.paymentFrequency) {
                ForEach(PaymentFrequency.allCases, id: \.self) { frequency in
                    Text(frequency.rawValue).tag(frequency)
                }
            }
        }
    }
    
    private var roiInputs: some View {
        Group {
            HStack {
                Text("Initial Investment:")
                TextField("Investment", value: $viewModel.principal, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Final Value:")
                TextField("Value", value: $viewModel.finalValue, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Time Period (Years):")
                TextField("Years", value: $viewModel.periods, format: .number)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private var timeValueInputs: some View {
        Group {
            HStack {
                Text("Initial Amount:")
                TextField("Amount", value: $viewModel.principal, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Interest Rate (%):")
                TextField("Rate", value: $viewModel.rate, format: .number)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Time Period (Years):")
                TextField("Years", value: $viewModel.periods, format: .number)
                    .keyboardType(.numberPad)
            }
            
            HStack {
                Text("Future Value:")
                TextField("Value", value: $viewModel.finalValue, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
        }
    }
    
    private var breakEvenInputs: some View {
        Group {
            HStack {
                Text("Fixed Costs:")
                TextField("Costs", value: $viewModel.principal, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Price per Unit:")
                TextField("Price", value: $viewModel.finalValue, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Variable Cost per Unit:")
                TextField("Cost", value: $viewModel.rate, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
        }
    }
    
    private var depreciationInputs: some View {
        Group {
            HStack {
                Text("Initial Value:")
                TextField("Value", value: $viewModel.principal, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Salvage Value:")
                TextField("Value", value: $viewModel.finalValue, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Useful Life (Years):")
                TextField("Years", value: $viewModel.periods, format: .number)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private func handleFinancialCalculation(_ action: CalculatorButtonConfig.Action) {
        if case .financial(let type) = action {
            switch type {
            case "compound":
                viewModel.calculateCompoundInterest()
            case "simple":
                viewModel.calculateSimpleInterest()
            case "loan":
                viewModel.calculateLoanPayment()
            case "future":
                viewModel.calculateFutureValue()
            case "present":
                viewModel.calculatePresentValue()
            case "annuity":
                viewModel.calculateAnnuity()
            case "roi":
                viewModel.calculateROI()
            case "breakeven":
                viewModel.calculateBreakEven()
            case "depreciation":
                viewModel.calculateDepreciation()
            default:
                break
            }
        }
    }
}

enum FinancialCalculationType: String, CaseIterable {
    case compound
    case simple
    case loan
    case futureValue
    case presentValue
    case annuity
    case roi
    case breakEven
    case depreciation
    
    var description: String {
        switch self {
        case .compound: return "Compound Interest"
        case .simple: return "Simple Interest"
        case .loan: return "Loan Payment"
        case .futureValue: return "Future Value"
        case .presentValue: return "Present Value"
        case .annuity: return "Annuity"
        case .roi: return "Return on Investment"
        case .breakEven: return "Break Even Analysis"
        case .depreciation: return "Depreciation"
        }
    }
    
    var explanation: String {
        switch self {
        case .compound: return "Compound interest is calculated based on the principal amount, interest rate, and time period."
        case .simple: return "Simple interest is calculated based on the principal amount, interest rate, and time period."
        case .loan: return "Loan payment calculations involve the principal amount, interest rate, and loan term."
        case .futureValue: return "Future value calculations involve the initial amount, interest rate, and time period."
        case .presentValue: return "Present value calculations involve the future amount, interest rate, and time period."
        case .annuity: return "Annuity calculations involve the payment amount, interest rate, and number of payments."
        case .roi: return "Return on investment calculations involve the initial investment and final value."
        case .breakEven: return "Break even analysis involves fixed costs, price per unit, and variable cost per unit."
        case .depreciation: return "Depreciation calculations involve the initial value and salvage value."
        }
    }
}

enum PaymentFrequency: String, CaseIterable {
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case semiannual = "Semi-Annual"
    case annual = "Annual"
    
    var paymentsPerYear: Int {
        switch self {
        case .monthly: return 12
        case .quarterly: return 4
        case .semiannual: return 2
        case .annual: return 1
        }
    }
}

#Preview {
    FinancialCalculatorView(viewModel: CalculatorViewModel())
} 
import Foundation
import SwiftUI

class CalculatorViewModel: ObservableObject {
    @Published var displayValue: String = "0"
    @Published var currentMode: CalculatorMode = .standard
    @Published var showScientificFunctions: Bool = false
    @Published var rate: Double = 0.0
    @Published var periods: Int = 0
    @Published var principal: Double = 0.0
    @Published var payment: Double = 0.0
    @Published var finalValue: Double = 0.0
    @Published var paymentFrequency: PaymentFrequency = .monthly
    @Published var memory: Double = 0
    @Published var hasMemoryValue = false
    
    private var firstNumber: Double?
    private var operation: String?
    private var shouldResetDisplay = false
    private var currentNumber: String = ""
    
    // Scientific operations
    func performScientificOperation(_ operation: String) {
        guard let number = Double(displayValue) else { return }
        
        switch operation {
        case "sin":
            displayValue = "\(sin(number * .pi / 180))"
        case "cos":
            displayValue = "\(cos(number * .pi / 180))"
        case "tan":
            displayValue = "\(tan(number * .pi / 180))"
        case "√":
            displayValue = "\(sqrt(number))"
        case "x²":
            displayValue = "\(pow(number, 2))"
        case "log":
            displayValue = "\(log10(number))"
        case "ln":
            displayValue = "\(log(number))"
        case "π":
            displayValue = "\(Double.pi)"
        case "e":
            displayValue = "\(M_E)"
        default:
            break
        }
        shouldResetDisplay = true
    }
    
    func numberPressed(_ number: Int) {
        if shouldResetDisplay || displayValue == "0" {
            displayValue = "\(number)"
            shouldResetDisplay = false
        } else {
            displayValue += "\(number)"
        }
    }
    
    func operationPressed(_ operation: String) {
        if let value = Double(displayValue) {
            if firstNumber == nil {
                firstNumber = value
            } else {
                calculateResult()
            }
        }
        self.operation = operation
        shouldResetDisplay = true
    }
    
    func calculateResult() {
        guard let first = firstNumber,
              let operation = operation,
              let second = Double(displayValue) else { return }
        
        switch operation {
        case "+":
            displayValue = "\(first + second)"
        case "-":
            displayValue = "\(first - second)"
        case "×":
            displayValue = "\(first * second)"
        case "÷":
            displayValue = second != 0 ? "\(first / second)" : "Error"
        case "xʸ":
            displayValue = "\(pow(first, second))"
        default:
            break
        }
        
        firstNumber = Double(displayValue)
        shouldResetDisplay = true
    }
    
    func clear() {
        displayValue = "0"
        firstNumber = nil
        operation = nil
        shouldResetDisplay = false
    }
    
    // New functions for decimal, negation, and percentage
    func decimal() {
        if !displayValue.contains(".") {
            displayValue += "."
        }
    }
    
    func negate() {
        if let value = Double(displayValue) {
            displayValue = "\(-value)"
        }
    }
    
    func percentage() {
        if let value = Double(displayValue) {
            displayValue = "\(value / 100)"
        }
    }
    
    // Memory functions
    func memoryClear() {
        memory = 0
        hasMemoryValue = false
    }
    
    func memoryRecall() {
        if hasMemoryValue {
            displayValue = formatNumber(memory)
            shouldResetDisplay = true
        }
    }
    
    func memoryAdd() {
        if let value = Double(displayValue) {
            memory += value
            hasMemoryValue = true
            shouldResetDisplay = true
        }
    }
    
    func memorySubtract() {
        if let value = Double(displayValue) {
            memory -= value
            hasMemoryValue = true
            shouldResetDisplay = true
        }
    }
    
    func memoryStore() {
        if let value = Double(displayValue) {
            memory = value
            hasMemoryValue = true
            shouldResetDisplay = true
        }
    }
    
    // Financial calculator functions
    func calculateCompoundInterest() {
        let amount = principal * pow(1 + rate/100, Double(periods))
        displayValue = String(format: "%.2f", amount)
    }
    
    func calculateLoanPayment() {
        let monthlyRate = rate / (100 * 12)
        let numberOfPayments = Double(periods * 12)
        let payment = principal * monthlyRate * pow(1 + monthlyRate, numberOfPayments) / (pow(1 + monthlyRate, numberOfPayments) - 1)
        displayValue = String(format: "%.2f", payment)
    }
    
    func calculateSimpleInterest() {
        let interest = principal * rate * Double(periods) / 100
        displayValue = String(format: "%.2f", principal + interest)
    }
    
    func calculateFutureValue() {
        let fv = principal * pow(1 + rate/100, Double(periods))
        displayValue = String(format: "%.2f", fv)
    }
    
    func calculatePresentValue() {
        let pv = finalValue / pow(1 + rate/100, Double(periods))
        displayValue = String(format: "%.2f", pv)
    }
    
    func calculateAnnuity() {
        let r = rate / (100.0 * Double(paymentFrequency.paymentsPerYear))
        let n = Double(periods * paymentFrequency.paymentsPerYear)
        let fv = payment * (pow(1 + r, n) - 1) / r
        displayValue = String(format: "%.2f", fv)
    }
    
    func calculateROI() {
        let roi = ((finalValue - principal) / principal) * 100
        displayValue = String(format: "%.2f%%", roi)
    }
    
    func calculateBreakEven() {
        // Assuming fixed costs and unit contribution margin
        let breakEvenUnits = principal / (finalValue - rate)  // Using rate as variable cost per unit
        displayValue = String(format: "%.0f units", breakEvenUnits)
    }
    
    func calculateDepreciation() {
        // Straight-line depreciation
        let annualDepreciation = (principal - finalValue) / Double(periods)
        displayValue = String(format: "%.2f per year", annualDepreciation)
    }
    
    // Mode change function
    func modeChanged() {
        clear()
        showScientificFunctions = currentMode == .scientific
    }
    
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        
        if let formattedString = formatter.string(from: NSNumber(value: number)) {
            return formattedString
        }
        return String(number)
    }
} 
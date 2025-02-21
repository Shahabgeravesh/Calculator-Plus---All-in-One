import Foundation
import SwiftUI

class CalculatorViewModel: ObservableObject {
    @Published var displayValue: String = "0"
    @Published var currentMode: CalculatorMode = .standard
    @Published var showScientificFunctions: Bool = false
    
    private var firstNumber: Double?
    private var operation: String?
    private var shouldResetDisplay = false
    private var memory: Double = 0
    
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
    func memoryAdd() {
        if let value = Double(displayValue) {
            memory += value
        }
    }
    
    func memorySubtract() {
        if let value = Double(displayValue) {
            memory -= value
        }
    }
    
    func memoryRecall() {
        displayValue = "\(memory)"
        shouldResetDisplay = true
    }
    
    func memoryClear() {
        memory = 0
    }
} 
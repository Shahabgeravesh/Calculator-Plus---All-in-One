import Foundation

enum CalculatorError: Error, LocalizedError {
    case invalidInput
    case divisionByZero
    case negativeValue
    case overflow
    case invalidDate
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Please enter valid numbers"
        case .divisionByZero:
            return "Cannot divide by zero"
        case .negativeValue:
            return "Value cannot be negative"
        case .overflow:
            return "Result is too large to calculate"
        case .invalidDate:
            return "Please enter a valid date"
        }
    }
} 
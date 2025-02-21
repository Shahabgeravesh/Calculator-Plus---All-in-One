import Foundation

enum CalculatorMode: String, Codable, CaseIterable {
    case standard = "Standard"
    case scientific = "Scientific"
    case financial = "Financial"
    case measurement = "Measurement"
    
    var description: String { rawValue }
} 
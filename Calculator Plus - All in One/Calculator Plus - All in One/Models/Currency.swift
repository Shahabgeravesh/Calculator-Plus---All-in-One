import Foundation

enum Currency: String, CaseIterable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case cad = "CAD"
    case aud = "AUD"
    case chf = "CHF"
    case cny = "CNY"
    
    var description: String {
        switch self {
        case .usd: return "US Dollar ($)"
        case .eur: return "Euro (€)"
        case .gbp: return "British Pound (£)"
        case .jpy: return "Japanese Yen (¥)"
        case .cad: return "Canadian Dollar (C$)"
        case .aud: return "Australian Dollar (A$)"
        case .chf: return "Swiss Franc (Fr)"
        case .cny: return "Chinese Yuan (¥)"
        }
    }
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .jpy: return "¥"
        case .cad: return "C$"
        case .aud: return "A$"
        case .chf: return "Fr"
        case .cny: return "¥"
        }
    }
    
    var code: String { rawValue }
} 
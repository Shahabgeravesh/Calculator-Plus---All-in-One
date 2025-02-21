import SwiftUI

struct MeasurementCalculatorView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @State private var selectedUnit = MeasurementType.length
    @State private var fromValue = ""
    @State private var fromUnit = Unit.meters
    @State private var toUnit = Unit.feet
    
    var body: some View {
        VStack(spacing: 12) {
            Form {
                Section {
                    Picker("Measurement Type", selection: $selectedUnit) {
                        ForEach(MeasurementType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section("Convert") {
                    TextField("Value", text: $fromValue)
                        .keyboardType(.decimalPad)
                    
                    Picker("From", selection: $fromUnit) {
                        ForEach(selectedUnit.units, id: \.self) { unit in
                            Text(unit.symbol).tag(unit)
                        }
                    }
                    
                    Picker("To", selection: $toUnit) {
                        ForEach(selectedUnit.units, id: \.self) { unit in
                            Text(unit.symbol).tag(unit)
                        }
                    }
                }
                
                Section("Result") {
                    Text(calculateConversion())
                        .font(.title2)
                        .bold()
                }
            }
        }
        .onChange(of: selectedUnit) { _ in
            fromUnit = selectedUnit.defaultFromUnit
            toUnit = selectedUnit.defaultToUnit
        }
    }
    
    private func calculateConversion() -> String {
        guard let value = Double(fromValue) else { return "Enter a value" }
        
        switch selectedUnit {
        case .length:
            let meters = value * fromUnit.lengthToBase
            let result = meters / toUnit.lengthToBase
            return String(format: "%.2f %@", result, toUnit.symbol)
            
        case .weight:
            let kilograms = value * fromUnit.weightToBase
            let result = kilograms / toUnit.weightToBase
            return String(format: "%.2f %@", result, toUnit.symbol)
            
        case .temperature:
            let celsius = fromUnit.temperatureToBase(value)
            let result = toUnit.fromBaseTemperature(celsius)
            return String(format: "%.1f %@", result, toUnit.symbol)
            
        case .volume:
            let liters = value * fromUnit.volumeToBase
            let result = liters / toUnit.volumeToBase
            return String(format: "%.2f %@", result, toUnit.symbol)
        }
    }
}

enum MeasurementType: String, CaseIterable {
    case length = "Length"
    case weight = "Weight"
    case temperature = "Temperature"
    case volume = "Volume"
    
    var units: [Unit] {
        switch self {
        case .length:
            return [.meters, .kilometers, .feet, .inches, .miles, .yards]
        case .weight:
            return [.kilograms, .grams, .pounds, .ounces]
        case .temperature:
            return [.celsius, .fahrenheit, .kelvin]
        case .volume:
            return [.liters, .milliliters, .gallons, .cups, .fluidOunces]
        }
    }
    
    var defaultFromUnit: Unit {
        switch self {
        case .length: return .meters
        case .weight: return .kilograms
        case .temperature: return .celsius
        case .volume: return .liters
        }
    }
    
    var defaultToUnit: Unit {
        switch self {
        case .length: return .feet
        case .weight: return .pounds
        case .temperature: return .fahrenheit
        case .volume: return .gallons
        }
    }
}

enum Unit: String, CaseIterable {
    // Length
    case meters = "m"
    case kilometers = "km"
    case feet = "ft"
    case inches = "in"
    case miles = "mi"
    case yards = "yd"
    
    // Weight
    case kilograms = "kg"
    case grams = "g"
    case pounds = "lb"
    case ounces = "oz"
    
    // Temperature
    case celsius = "°C"
    case fahrenheit = "°F"
    case kelvin = "K"
    
    // Volume
    case liters = "L"
    case milliliters = "mL"
    case gallons = "gal"
    case cups = "cup"
    case fluidOunces = "fl oz"
    
    var symbol: String { rawValue }
    
    // Length conversions (to/from meters)
    var lengthToBase: Double {
        switch self {
        case .meters: return 1.0
        case .kilometers: return 1000.0
        case .feet: return 0.3048
        case .inches: return 0.0254
        case .miles: return 1609.34
        case .yards: return 0.9144
        default: return 1.0
        }
    }
    
    // Weight conversions (to/from kilograms)
    var weightToBase: Double {
        switch self {
        case .kilograms: return 1.0
        case .grams: return 0.001
        case .pounds: return 0.453592
        case .ounces: return 0.0283495
        default: return 1.0
        }
    }
    
    // Volume conversions (to/from liters)
    var volumeToBase: Double {
        switch self {
        case .liters: return 1.0
        case .milliliters: return 0.001
        case .gallons: return 3.78541
        case .cups: return 0.236588
        case .fluidOunces: return 0.0295735
        default: return 1.0
        }
    }
    
    // Temperature conversions
    func temperatureToBase(_ value: Double) -> Double {
        switch self {
        case .celsius: return value
        case .fahrenheit: return (value - 32) * 5/9
        case .kelvin: return value - 273.15
        default: return value
        }
    }
    
    func fromBaseTemperature(_ celsius: Double) -> Double {
        switch self {
        case .celsius: return celsius
        case .fahrenheit: return celsius * 9/5 + 32
        case .kelvin: return celsius + 273.15
        default: return celsius
        }
    }
}

#Preview {
    MeasurementCalculatorView(viewModel: CalculatorViewModel())
} 
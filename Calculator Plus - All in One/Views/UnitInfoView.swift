import SwiftUI

struct UnitInfoView: View {
    let measurementType: MeasurementType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    Text(measurementType.description)
                }
                
                Section("Available Units") {
                    ForEach(measurementType.units, id: \.self) { unit in
                        HStack {
                            Text(unit.fullName)
                            Spacer()
                            Text(unit.symbol)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Common Conversions") {
                    ForEach(measurementType.commonConversions, id: \.self) { conversion in
                        Text(conversion)
                    }
                }
            }
            .navigationTitle("\(measurementType.rawValue) Units")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

extension Unit {
    var fullName: String {
        switch self {
        // Length
        case .meters: return "Meters"
        case .kilometers: return "Kilometers"
        case .feet: return "Feet"
        case .inches: return "Inches"
        case .miles: return "Miles"
        case .yards: return "Yards"
        
        // Weight
        case .kilograms: return "Kilograms"
        case .grams: return "Grams"
        case .pounds: return "Pounds"
        case .ounces: return "Ounces"
        
        // Temperature
        case .celsius: return "Celsius"
        case .fahrenheit: return "Fahrenheit"
        case .kelvin: return "Kelvin"
        
        // Volume
        case .liters: return "Liters"
        case .milliliters: return "Milliliters"
        case .gallons: return "Gallons"
        case .cups: return "Cups"
        case .fluidOunces: return "Fluid Ounces"
        }
    }
    
    var conversionFactor: Double {
        switch self {
        case .meters, .kilograms, .liters: return 1.0
        case .kilometers: return 1000.0
        case .feet: return 0.3048
        case .inches: return 0.0254
        case .miles: return 1609.34
        case .yards: return 0.9144
        case .grams: return 0.001
        case .pounds: return 0.453592
        case .ounces: return 0.0283495
        case .milliliters: return 0.001
        case .gallons: return 3.78541
        case .cups: return 0.236588
        case .fluidOunces: return 0.0295735
        default: return 1.0
        }
    }
}

extension MeasurementType {
    var description: String {
        switch self {
        case .length:
            return "Length measurements are used to determine the distance between two points or the size of an object."
        case .weight:
            return "Weight measurements are used to determine the mass of an object."
        case .temperature:
            return "Temperature measurements are used to determine how hot or cold something is."
        case .volume:
            return "Volume measurements are used to determine the amount of space that a substance occupies."
        }
    }
    
    var commonConversions: [String] {
        switch self {
        case .length:
            return [
                "1 mile = 5280 feet",
                "1 kilometer = 1000 meters",
                "1 yard = 3 feet",
                "1 foot = 12 inches"
            ]
        case .weight:
            return [
                "1 kilogram = 1000 grams",
                "1 pound = 16 ounces",
                "1 kilogram ≈ 2.20462 pounds"
            ]
        case .temperature:
            return [
                "0°C = 32°F",
                "100°C = 212°F",
                "0°C = 273.15K"
            ]
        case .volume:
            return [
                "1 gallon = 128 fluid ounces",
                "1 liter = 1000 milliliters",
                "1 cup = 8 fluid ounces"
            ]
        }
    }
} 
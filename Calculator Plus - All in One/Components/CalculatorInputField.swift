import SwiftUI

struct CalculatorInputField: View {
    let label: String
    let placeholder: String
    var value: Binding<Double>
    var format: FloatingPointFormatStyle<Double> = .number
    var keyboardType: UIKeyboardType = .decimalPad
    var unit: String = ""
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            TextField(placeholder, value: value, format: format)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 150)
            if !unit.isEmpty {
                Text(unit)
                    .foregroundColor(.secondary)
            }
        }
    }
} 
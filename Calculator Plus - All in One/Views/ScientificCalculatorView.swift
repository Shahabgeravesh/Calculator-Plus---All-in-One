import SwiftUI

struct ScientificCalculatorView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    // Reduce columns for better fit
    private var gridColumns: Int {
        sizeClass == .regular ? 5 : 4 // Keep 4 columns for better spacing
    }
    
    // Add this property
    private var gridLayout: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: getSpacing()), count: gridColumns)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Display
                DisplayView(value: viewModel.displayValue, hasMemory: viewModel.hasMemoryValue)
                    .frame(height: geometry.size.height * 0.15) // Reduced height
                
                // Calculator Area
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: getSpacing()) {
                        // Scientific Functions Section
                        Group {
                            Text("Scientific Functions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            // Scientific Functions Grid
                            LazyVGrid(
                                columns: gridLayout,
                                spacing: getSpacing()
                            ) {
                                Group {
                                    ForEach(["sin", "cos", "tan", "π"], id: \.self) { function in
                                        ScientificButton(title: function) { 
                                            viewModel.performScientificOperation(function) 
                                        }
                                    }
                                }
                                Group {
                                    ForEach(["e", "x²", "x³", "xʸ"], id: \.self) { function in
                                        ScientificButton(title: function) { 
                                            viewModel.performScientificOperation(function) 
                                        }
                                    }
                                }
                                ScientificButton(title: "√") { viewModel.performScientificOperation("√") }
                                ScientificButton(title: "log") { viewModel.performScientificOperation("log") }
                                ScientificButton(title: "ln") { viewModel.performScientificOperation("ln") }
                                ScientificButton(title: "1/x") { viewModel.performScientificOperation("1/x") }
                            }
                        }
                        .padding(.top, getSpacing())
                        
                        // Memory Functions Section
                        Group {
                            Text("Memory")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            HStack(spacing: getSpacing()) {
                                ForEach(["MC", "MR", "M+", "M-", "MS"], id: \.self) { button in
                                    MemoryButton(title: button) {
                                        handleMemoryOperation(button)
                                    }
                                }
                            }
                        }
                        .padding(.top, getSpacing())
                        
                        // Standard Calculator Pad
                        VStack(spacing: getSpacing()) {
                            ForEach([
                                ["C", "±", "%", "÷"],
                                ["7", "8", "9", "×"],
                                ["4", "5", "6", "-"],
                                ["1", "2", "3", "+"],
                                ["0", ".", "="]
                            ], id: \.self) { row in
                                HStack(spacing: getSpacing()) {
                                    ForEach(row, id: \.self) { button in
                                        CalculatorButton(
                                            title: button,
                                            color: getButtonColor(button),
                                            width: button == "0" ? .double : .single
                                        ) {
                                            handleButtonPress(button)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, getSpacing())
                    }
                    .padding(.horizontal, getSpacing())
                    .padding(.vertical, getSpacing() * 2)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
    }
    
    struct ScientificButton: View {
        let title: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 18, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
    
    struct MemoryButton: View {
        let title: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
    
    private func getSpacing() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        switch sizeClass {
        case .regular:
            return 12
        default:
            return screenWidth > 375 ? 8 : 6 // Adjust based on device width
        }
    }
    
    private func getButtonColor(_ button: String) -> Color {
        switch button {
        case "+", "-", "×", "÷", "=": return .orange
        case "C", "±", "%": return .gray
        default: return .secondary.opacity(0.8)
        }
    }
    
    private func handleMemoryOperation(_ operation: String) {
        switch operation {
        case "MC": viewModel.memoryClear()
        case "MR": viewModel.memoryRecall()
        case "M+": viewModel.memoryAdd()
        case "M-": viewModel.memorySubtract()
        case "MS": viewModel.memoryStore()
        default: break
        }
    }
    
    private func handleButtonPress(_ button: String) {
        switch button {
        case "0"..."9": viewModel.numberPressed(Int(button)!)
        case "+", "-", "×", "÷": viewModel.operationPressed(button)
        case "=": viewModel.calculateResult()
        case "C": viewModel.clear()
        case "±": viewModel.negate()
        case "%": viewModel.percentage()
        case ".": viewModel.decimal()
        default: break
        }
    }
}

// Helper Views
struct DisplayView: View {
    let value: String
    let hasMemory: Bool
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private var fontSize: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let isLargePhone = screenHeight > 800
        
        switch sizeClass {
        case .regular:
            return 72 // iPad
        default:
            return isLargePhone ? 64 : 56 // iPhone
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            if hasMemory {
                Text("M")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.trailing, 8)
            }
            Text(value)
                .font(.system(size: fontSize, weight: .light))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color(.systemBackground))
    }
}

#Preview {
    ScientificCalculatorView(viewModel: CalculatorViewModel())
} 
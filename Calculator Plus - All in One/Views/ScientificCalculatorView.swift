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
    
    // Add this property for better organization
    private var scientificFunctions: [(String, String)] {
        [
            ("sine", "sin"),
            ("cosine", "cos"),
            ("tangent", "tan"),
            ("pi", "π"),
            ("euler", "e"),
            ("square", "x²"),
            ("cube", "x³"),
            ("power", "xʸ"),
            ("square root", "√"),
            ("logarithm", "log"),
            ("natural logarithm", "ln"),
            ("reciprocal", "1/x")
        ]
    }
    
    private let keyboardController: KeyboardCommandsController
    
    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        self.keyboardController = KeyboardCommandsController(viewModel: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Display
                DisplayView(value: viewModel.displayValue, hasMemory: viewModel.hasMemoryValue)
                    .frame(height: geometry.size.height * 0.15)
                    .accessibilityLabel("Calculator display showing \(viewModel.displayValue)")
                
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
                                .accessibilityAddTraits(.isHeader)
                            
                            LazyVGrid(
                                columns: gridLayout,
                                spacing: getSpacing()
                            ) {
                                ForEach(scientificFunctions, id: \.0) { function, symbol in
                                    ScientificButton(title: symbol) {
                                        viewModel.performScientificOperation(function)
                                    }
                                    .accessibilityLabel("\(function) function")
                                    .accessibilityHint("Calculates the \(function) of the current value")
                                }
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
                                .accessibilityAddTraits(.isHeader)
                            
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
        .navigationTitle("Scientific Calculator")
        .navigationBarTitleDisplayMode(.inline)
        #if !os(macOS)
        .background(
            KeyboardCommandsControllerRepresentable(controller: keyboardController)
                .frame(width: 0, height: 0)
        )
        #endif
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

class KeyboardCommandsController: UIViewController {
    weak var viewModel: CalculatorViewModel?
    
    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        var commands = [UIKeyCommand]()
        
        // Add operation commands
        let operations = [
            ("+", "Add"),
            ("-", "Subtract"),
            ("*", "Multiply"),
            ("/", "Divide"),
            ("\r", "Calculate"),
            ("c", "Clear")
        ]
        
        for (input, description) in operations {
            commands.append(UIKeyCommand(
                input: input,
                modifierFlags: [],
                action: #selector(handleKeyCommand(_:)),
                discoverabilityTitle: description
            ))
        }
        
        // Add number commands
        for number in 0...9 {
            commands.append(UIKeyCommand(
                input: "\(number)",
                modifierFlags: [],
                action: #selector(handleKeyCommand(_:)),
                discoverabilityTitle: "Enter \(number)"
            ))
        }
        
        return commands
    }
    
    @objc func handleKeyCommand(_ sender: UIKeyCommand) {
        guard let key = sender.input else { return }
        switch key {
        case "0"..."9":
            if let number = Int(key) {
                viewModel?.numberPressed(number)
            }
        case "+": viewModel?.operationPressed("+")
        case "-": viewModel?.operationPressed("-")
        case "*": viewModel?.operationPressed("×")
        case "/": viewModel?.operationPressed("÷")
        case "\r": viewModel?.calculateResult()
        case "c": viewModel?.clear()
        default: break
        }
    }
}

#if !os(macOS)
struct KeyboardCommandsControllerRepresentable: UIViewControllerRepresentable {
    let controller: KeyboardCommandsController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
#endif

#Preview {
    ScientificCalculatorView(viewModel: CalculatorViewModel())
} 
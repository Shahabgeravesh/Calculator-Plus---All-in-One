import SwiftUI

struct CalculatorButton: View {
    let config: CalculatorButtonConfig
    let action: () -> Void
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    init(
        title: String,
        color: Color = .gray,
        width: CalculatorButtonConfig.ButtonWidth = .single,
        action: @escaping () -> Void
    ) {
        self.config = CalculatorButtonConfig(
            title: title,
            color: color,
            width: width
        )
        self.action = action
    }
    
    private var buttonSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        switch sizeClass {
        case .regular:
            return 85 // iPad
        default:
            // iPhone
            let isLargePhone = screenHeight > 800
            let defaultSize = screenWidth / 5.2 // Reduced from 4.2 for better fit
            return isLargePhone ? defaultSize : defaultSize * 0.95
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(config.title)
                .font(.system(size: getFontSize(), design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(
                    width: config.width == .double ? buttonSize * 2.1 + 12 : buttonSize,
                    height: buttonSize
                )
                .background(
                    RoundedRectangle(cornerRadius: buttonSize/4)
                        .fill(config.color)
                        .shadow(color: config.color.opacity(0.3), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(CalculatorButtonStyle())
        .calculatorAccessibility(
            label: getAccessibilityLabel(),
            hint: getAccessibilityHint()
        )
    }
    
    private func getFontSize() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let isLargePhone = screenHeight > 800
        
        let baseSize: CGFloat = sizeClass == .regular ? 34 : (isLargePhone ? 32 : 28)
        if config.title.count > 1 {
            return baseSize * 0.7
        }
        return baseSize
    }
    
    private func getAccessibilityLabel() -> String {
        switch config.action {
        case .number: return "\(config.title) button"
        case .operation: return "\(config.title) operation"
        case .scientific: return "\(config.title) function"
        default: return config.title
        }
    }
    
    private func getAccessibilityHint() -> String {
        switch config.action {
        case .number: return "Enters the number \(config.title)"
        case .operation: return "Performs \(config.title) operation"
        case .scientific: return "Calculates \(config.title) function"
        case .equals: return "Calculates the result"
        case .clear: return "Clears the calculator"
        default: return ""
        }
    }
}

struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CalculatorButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    CalculatorButton(title: "Compound\nInterest", color: .blue) {}
                    CalculatorButton(title: "Simple\nInterest", color: .green) {}
                }
                HStack(spacing: 12) {
                    CalculatorButton(title: "ROI", color: .purple) {}
                    CalculatorButton(title: "Break\nEven", color: .orange) {}
                }
            }
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
            
            // Dark mode preview
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    CalculatorButton(title: "Compound\nInterest", color: .blue) {}
                    CalculatorButton(title: "Simple\nInterest", color: .green) {}
                }
                HStack(spacing: 12) {
                    CalculatorButton(title: "ROI", color: .purple) {}
                    CalculatorButton(title: "Break\nEven", color: .orange) {}
                }
            }
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}

extension CalculatorButton {
    struct Config: Hashable {
        let title: String
        let color: Color
        let action: Action
        let width: ButtonWidth
        
        init(
            title: String,
            color: Color = .gray,
            action: Action = .number,
            width: ButtonWidth = .single
        ) {
            self.title = title
            self.color = color
            self.action = action
            self.width = width
        }
        
        enum Action: Hashable {
            case number
            case operation(String)
            case equals
            case clear
            case decimal
            case negate
            case percentage
            case scientific(String)
            case memoryAdd
            case memorySubtract
            case memoryRecall
            case memoryClear
            case memoryStore
            case financial(String)
        }
        
        enum ButtonWidth {
            case single
            case double
        }
    }
}  
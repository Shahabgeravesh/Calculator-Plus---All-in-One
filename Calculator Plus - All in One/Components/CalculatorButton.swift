import SwiftUI

struct CalculatorButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    init(
        title: String,
        color: Color = .gray,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.7)
                    .lineLimit(2)
                    .padding(.vertical, 8)
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(CalculatorButtonStyle())
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

#Preview {
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
}

extension CalculatorButton {
    struct Config: Hashable {
        enum Action: Hashable {
            case financial(String)
        }
    }
} 
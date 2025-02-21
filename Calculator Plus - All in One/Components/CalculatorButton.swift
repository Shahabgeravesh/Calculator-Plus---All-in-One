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
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(minWidth: 44, maxWidth: .infinity)
                .frame(height: 60)
                .background(color)
                .cornerRadius(12)
                .shadow(radius: 2)
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
    HStack {
        CalculatorButton(title: "1") {}
        CalculatorButton(title: "+", color: .orange) {}
    }
    .padding()
}

extension CalculatorButton {
    struct Config: Hashable {
        enum Action: Hashable {
            case financial(String)
        }
    }
} 
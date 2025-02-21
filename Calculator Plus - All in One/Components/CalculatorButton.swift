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
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(color)
        .cornerRadius(12)
    }
} 
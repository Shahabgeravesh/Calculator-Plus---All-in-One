import SwiftUI

struct FinancialResultView: View {
    let title: String
    let value: String
    let details: [String: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(value)
                .font(.title)
                .bold()
            
            ForEach(details.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                HStack {
                    Text(key)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(value)
                        .bold()
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
} 
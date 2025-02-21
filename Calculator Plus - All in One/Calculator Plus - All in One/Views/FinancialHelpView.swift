import SwiftUI

struct FinancialHelpView: View {
    let calculationType: FinancialCalculationType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    Text(calculationType.explanation)
                }
                
                Section("Formula") {
                    Text(calculationType.formula)
                        .font(.system(.body, design: .monospaced))
                }
                
                Section("Example") {
                    Text(calculationType.example)
                }
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
} 
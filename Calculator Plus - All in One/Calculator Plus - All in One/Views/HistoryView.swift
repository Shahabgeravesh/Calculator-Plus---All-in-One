import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyManager: HistoryManager
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(historyManager.history) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(item.mode.rawValue)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(dateFormatter.string(from: item.date))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(item.calculation)
                            .font(.body)
                        
                        Text(item.result)
                            .font(.title3)
                            .bold()
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: historyManager.removeCalculation)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        historyManager.clearHistory()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView(historyManager: HistoryManager())
} 
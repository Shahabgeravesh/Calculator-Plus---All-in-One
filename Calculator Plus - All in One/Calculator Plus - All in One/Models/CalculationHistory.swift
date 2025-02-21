import Foundation

struct CalculationHistory: Identifiable, Codable {
    let id: UUID
    let mode: CalculatorMode
    let calculation: String
    let result: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case mode
        case calculation
        case result
        case date
    }
    
    init(mode: CalculatorMode, calculation: String, result: String) {
        self.id = UUID()
        self.mode = mode
        self.calculation = calculation
        self.result = result
        self.date = Date()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        mode = try container.decode(CalculatorMode.self, forKey: .mode)
        calculation = try container.decode(String.self, forKey: .calculation)
        result = try container.decode(String.self, forKey: .result)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(mode, forKey: .mode)
        try container.encode(calculation, forKey: .calculation)
        try container.encode(result, forKey: .result)
        try container.encode(date, forKey: .date)
    }
}

class HistoryManager: ObservableObject {
    @Published var history: [CalculationHistory] = []
    
    private let maxHistoryItems = 100
    private let saveKey = "calculationHistory"
    
    init() {
        loadHistory()
    }
    
    func addCalculation(_ calculation: CalculationHistory) {
        history.insert(calculation, at: 0)
        if history.count > maxHistoryItems {
            history.removeLast()
        }
        saveHistory()
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            do {
                let decoder = JSONDecoder()
                history = try decoder.decode([CalculationHistory].self, from: data)
            } catch {
                print("Error loading history: \(error)")
                history = []
            }
        }
    }
    
    private func saveHistory() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(history)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Error saving history: \(error)")
        }
    }
    
    func clearHistory() {
        history.removeAll()
        saveHistory()
    }
    
    func removeCalculation(at indexSet: IndexSet) {
        history.remove(atOffsets: indexSet)
        saveHistory()
    }
} 
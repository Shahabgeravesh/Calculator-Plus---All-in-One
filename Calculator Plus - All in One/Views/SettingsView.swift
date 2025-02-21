import SwiftUI

struct SettingsView: View {
    @AppStorage("defaultCalculatorMode") private var defaultMode = CalculatorMode.standard
    @AppStorage("decimalPlaces") private var decimalPlaces = 2
    @AppStorage("useThousandsSeparator") private var useThousandsSeparator = true
    @AppStorage("defaultCurrency") private var defaultCurrency = "USD"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Display") {
                    Picker("Default Mode", selection: $defaultMode) {
                        ForEach(CalculatorMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    
                    Stepper("Decimal Places: \(decimalPlaces)", value: $decimalPlaces, in: 0...8)
                    
                    Toggle("Use Thousands Separator", isOn: $useThousandsSeparator)
                    
                    Picker("Default Currency", selection: $defaultCurrency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.description).tag(currency.code)
                        }
                    }
                }
                
                Section("About") {
                    Link("Rate the App", destination: URL(string: "itms-apps://itunes.apple.com/app/id")!)
                    Link("Privacy Policy", destination: URL(string: "https://yourwebsite.com/privacy")!)
                    Link("Terms of Use", destination: URL(string: "https://yourwebsite.com/terms")!)
                }
                
                Section {
                    Text("Version \(Bundle.main.appVersion)")
                        .foregroundColor(.secondary)
                } footer: {
                    Text("© 2025 Your Company Name")
                }
            }
            .navigationTitle("Settings")
        }
    }
} 
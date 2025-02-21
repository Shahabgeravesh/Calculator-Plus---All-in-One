//
//  ContentView.swift
//  Calculator Plus - All in One
//
//  Created by Shahab Geravesh on 2/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            // Mode Selector
            Picker("Calculator Mode", selection: $viewModel.currentMode) {
                ForEach(CalculatorMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Different calculator views based on mode
            switch viewModel.currentMode {
            case .standard:
                StandardCalculatorView(viewModel: viewModel)
            case .scientific:
                ScientificCalculatorView(viewModel: viewModel)
            case .financial:
                FinancialCalculatorView(viewModel: viewModel)
            case .measurement:
                MeasurementCalculatorView(viewModel: viewModel)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onChange(of: viewModel.currentMode) { oldValue, newValue in
            viewModel.modeChanged()
        }
    }
}

#Preview {
    ContentView()
}

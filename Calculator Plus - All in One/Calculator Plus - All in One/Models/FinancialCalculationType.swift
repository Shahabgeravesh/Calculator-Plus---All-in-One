extension FinancialCalculationType {
    var formula: String {
        switch self {
        case .compound:
            return "A = P(1 + r)^t\nwhere:\nA = Final amount\nP = Principal\nr = Interest rate\nt = Time"
        case .simple:
            return "I = P × r × t\nwhere:\nI = Interest\nP = Principal\nr = Interest rate\nt = Time"
        case .loan:
            return "PMT = P × (r(1 + r)^n)/((1 + r)^n - 1)\nwhere:\nPMT = Payment\nP = Principal\nr = Monthly rate\nn = Number of payments"
        case .futureValue:
            return "FV = PV(1 + r)^t\nwhere:\nFV = Future Value\nPV = Present Value\nr = Interest rate\nt = Time"
        case .presentValue:
            return "PV = FV/(1 + r)^t\nwhere:\nPV = Present Value\nFV = Future Value\nr = Interest rate\nt = Time"
        case .annuity:
            return "FV = PMT × ((1 + r)^n - 1)/r\nwhere:\nFV = Future Value\nPMT = Payment\nr = Interest rate\nn = Number of payments"
        case .roi:
            return "ROI = ((FV - IV)/IV) × 100\nwhere:\nROI = Return on Investment\nFV = Final Value\nIV = Initial Value"
        case .breakEven:
            return "BE = FC/(P - VC)\nwhere:\nBE = Break-even point\nFC = Fixed Costs\nP = Price per unit\nVC = Variable Cost per unit"
        case .depreciation:
            return "D = (IV - SV)/n\nwhere:\nD = Annual Depreciation\nIV = Initial Value\nSV = Salvage Value\nn = Useful Life"
        }
    }
    
    var example: String {
        switch self {
        case .compound:
            return "Initial: $1,000\nRate: 5%\nTime: 3 years\nResult: $1,157.63"
        case .simple:
            return "Initial: $1,000\nRate: 5%\nTime: 3 years\nResult: $1,150.00"
        case .loan:
            return "Amount: $200,000\nRate: 4.5%\nTerm: 30 years\nResult: $1,013.37/month"
        case .futureValue:
            return "Initial: $5,000\nRate: 6%\nTime: 5 years\nResult: $6,691.13"
        case .presentValue:
            return "Future: $10,000\nRate: 5%\nTime: 3 years\nResult: $8,638.38"
        case .annuity:
            return "Payment: $500/month\nRate: 6%\nTime: 10 years\nResult: $79,646.85"
        case .roi:
            return "Investment: $10,000\nFinal: $15,000\nResult: 50% ROI"
        case .breakEven:
            return "Fixed Costs: $100,000\nPrice: $50\nVariable Cost: $30\nResult: 5,000 units"
        case .depreciation:
            return "Initial: $50,000\nSalvage: $5,000\nLife: 5 years\nResult: $9,000/year"
        }
    }
} 
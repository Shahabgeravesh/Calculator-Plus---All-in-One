import XCTest
@testable import Calculator_Plus___All_in_One

final class CalculatorTests: XCTestCase {
    var viewModel: CalculatorViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CalculatorViewModel()
    }
    
    func testCompoundInterest() {
        viewModel.principal = 1000
        viewModel.rate = 5
        viewModel.periods = 3
        viewModel.calculateCompoundInterest()
        XCTAssertEqual(viewModel.displayValue, "1157.63")
    }
    
    // Add more tests...
} 
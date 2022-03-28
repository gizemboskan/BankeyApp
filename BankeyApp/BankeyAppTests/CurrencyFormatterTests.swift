//
//  CurrencyFormatterTests.swift
//  BankeyAppTests
//
//  Created by Gizem Boskan on 28.03.2022.
//

import XCTest

@testable import BankeyApp

class Test: XCTestCase {
    
    var formatter: CurrencyFormatter!
    let locale = Locale.current
    lazy var currencySymbol = locale.currencySymbol!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
    
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(929466.23)
        XCTAssertEqual(result, "\(currencySymbol)929,466.23")
    }
    
    func testZeroDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(0.0)
        XCTAssertEqual(result, "\(currencySymbol)0.00")
    }
}

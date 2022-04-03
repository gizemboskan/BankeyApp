//
//  AccountTests.swift
//  BankeyAppTests
//
//  Created by Gizem Boskan on 31.03.2022.
//

import Foundation
import XCTest

@testable import BankeyApp

class AccountTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testCanParse() throws {
        let json = """
        [
            {
                "id": "1",
                "type": "Banking",
                "name": "Basic Savings",
                "amount": 929466.23,
                "createdDateTime": "2010-06-21T15:29:32Z"
            }
        ]
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode([AccountModel].self, from: data)
        
        XCTAssertEqual(result.count, 1)
        
        let account1 = result[0]
        XCTAssertEqual(account1.id, "1")
        XCTAssertEqual(account1.type, .Banking)
        XCTAssertEqual(account1.name, "Basic Savings")
        XCTAssertEqual(account1.amount, 929466.23)
        XCTAssertEqual(account1.createdDateTime.monthDayYearString, "Jun 21, 2010")
    }
}

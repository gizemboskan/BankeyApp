//
//  ProfileTests.swift
//  BankeyAppTests
//
//  Created by Gizem Boskan on 31.03.2022.
//

import Foundation
import XCTest

@testable import BankeyApp

class ProfileTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testCanParse() throws {
        let json = """
        {
        "id": "1",
        "first_name": "Kevin",
        "last_name": "Flynn",
        }
        """
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(ProfileModel.self, from: data)
        
        XCTAssertEqual(result.id, "1")
        XCTAssertEqual(result.firstName, "Kevin")
        XCTAssertEqual(result.lastName, "Flynn")
    }
}

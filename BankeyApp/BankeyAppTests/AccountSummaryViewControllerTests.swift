//
//  AccountSummaryViewControllerTests.swift
//  BankeyAppTests
//
//  Created by Gizem Boskan on 31.03.2022.
//

import Foundation
import XCTest

@testable import BankeyApp

class AccountSummaryViewControllerTests: XCTestCase {
    var vc: AccountSummaryViewController!
    var mockManager: MockProfileManager!
    
    class MockProfileManager: ProfileManageable {
        var profile: Profile?
        var error: NetworkError?
        
        func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
            completion(.success(profile!))
        }
    }
    
    override func setUp() {
        super.setUp()
        
        vc = AccountSummaryViewController()
        mockManager = MockProfileManager()
        vc.profileManager = mockManager
    }
    
    func testTitleAndMessageForServerError() throws {
        let titleAndMessage = vc.titleAndMessage(for: .serverError)
        XCTAssertEqual("Server Error", titleAndMessage.0)
        XCTAssertEqual("Please check your network connectivity and try again", titleAndMessage.1)
        
    }
    
    func testTitleAndMessageForDecodingError() throws {
        let titleAndMessage = vc.titleAndMessage(for: .decodingError)
        XCTAssertEqual("Decoding Error", titleAndMessage.0)
        XCTAssertEqual("Please check your network connectivity and try again", titleAndMessage.1)
        
    }
    
    func testAlertForServerError() throws {
        mockManager.error = NetworkError.serverError
        vc.forceFetchProfile()
        
        XCTAssertEqual("Server Error", vc.errorAlert.title)
        XCTAssertEqual("Please check your network connectivity and try again", vc.errorAlert.message)
    }
    
    func testAlertForDecodingError() throws {
        mockManager.error = NetworkError.decodingError
        vc.forceFetchProfile()
        
        XCTAssertEqual("Decoding Error", vc.errorAlert.title)
        XCTAssertEqual("Please check your network connectivity and try again", vc.errorAlert.message)
    }
}

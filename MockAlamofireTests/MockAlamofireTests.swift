//
//  MockAlamofireTests.swift
//  MockAlamofireTests
//
//  Created by Steigerwald, Kris S. (CONT) on 2/13/17.
//  Copyright © 2017 Velaru. All rights reserved.
//

import XCTest
@testable import MockAlamofire

class MockAlamofireTests: XCTestCase {
   
    var manager:RequestState = .Live
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLiveRequestState() {
        let expect = expectation(description: "Get")
        
        manager.session.request("https://httpbin.org/get").responseJSON { response in
            switch response.result {
            case .success(let value):
                let val = value as AnyObject?
                print("LIVE DATA", val as Any)
            case .failure(let error):
                print("Error: Handle failure", error)
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
   
    func testMockRequest() {
        
        manager = .Mock
        
        let expect = expectation(description: "Get")
        
        manager.session.request("https://httpbin.org/todos").responseJSON { response in
            switch response.result {
            case .success(let value):
                let val = value as AnyObject?
                print("Mock DATA", val as Any)
            case .failure(let error):
                print("Error: Handle failure", error)
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
}

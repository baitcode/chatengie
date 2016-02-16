//
//  chatengieTests.swift
//  chatengieTests
//
//  Created by Ilia Batiy on 16/02/16.
//  Copyright © 2016 engie. All rights reserved.
//

import XCTest

class chatengieTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiClientGetMessages() {
        // This is an example of a functional test case.
        let client = EngieApiClient(endpoint: "http://api.beta.engie.co.il/test/chat/")

        let expectation = self.expectationWithDescription("Returns response")
        
        client.getMessages(from: "yaron")
            .then({ data in
                print(data)
            }).always({
                expectation.fulfill()
            }).error({
                error in
                XCTAssert(false, "Error shouldn't happen")
            })

        self.waitForExpectationsWithTimeout(5.0, handler: {
            error in
            if let error = error {
                NSLog("Timeout Error: \(error)");
            }
        })
    }

    func testApiClientBadRequest() {
        // This is an example of a functional test case.
        let client = EngieApiClient(endpoint: "http://api.beta.engie.co.il/test/chat/")
        
        let expectation = self.expectationWithDescription("Returns response")
        
        client.getMessages(from: "").then({
            body in
            XCTAssert(false, "Error has to be raised")
        }).always({
            expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: {
            error in
            if let error = error {
                NSLog("Timeout Error: \(error)");
            }
        })
    }

}

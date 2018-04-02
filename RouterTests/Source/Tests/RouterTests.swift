//
//  RouterTests.swift
//  RouterTests
//
//  Created by Red Davis on 30/03/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import XCTest
@testable import Router


internal final class RouterTests: XCTestCase
{
    // MARK: Setup
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    // MARK: Handling URLs
    
    internal func testHandlingURL()
    {
        let expectation = self.expectation(description: "call handler")
        let url = URL(string: "http://red.to/a/valueA/c/valueB")!
        
        let routeA = Route(path: "a/:varA/c/:varB") { (attributes) -> Bool in
            XCTAssertEqualOptional("valueA", attributes["varA"])
            XCTAssertEqualOptional("valueB", attributes["varB"])
            expectation.fulfill()
            
            return true
        }
        
        let router = Router()
        router.register(route: routeA)
        XCTAssert(router.handle(url: url))
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
}

//
//  RouteTests.swift
//  RouterTests
//
//  Created by Red Davis on 30/03/2018.
//  Copyright © 2018 Red Davis. All rights reserved.
//

import XCTest
@testable import DeeplinkRouter


internal final class RouteTests: XCTestCase
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
    
    // MARK: Matches
    
    internal func testMatches()
    {
        let routeA = Route(path: "a/b/c/:d/e") { (_) -> Bool in
            return true
        }
        
        let pathA = "a/b/c/123/e"
        let pathB = "c/b/a/123/e"
        let pathC = "a/b/c/"
        let pathD = "a/b/c/123/e/"
        let pathE = "a/123/c/123/e"
        
        XCTAssert(routeA.matches(path: pathA))
        XCTAssertFalse(routeA.matches(path: pathB))
        XCTAssertFalse(routeA.matches(path: pathC))
        XCTAssert(routeA.matches(path: pathD))
        XCTAssertFalse(routeA.matches(path: pathE))
    }
    
    // MARK: Handle url
    
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
        
        XCTAssert(routeA.handle(url: url))
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
}

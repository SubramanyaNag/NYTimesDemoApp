//
//  NYTimesArticleUITests.swift
//  NYTimesArticleUITests
//
//  Created by subramanya on 17/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import XCTest

class NYTimesArticleUITests: XCTestCase {
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFullAppNavigation() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: app.tables, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        app.tables.firstMatch.tap()
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        XCTAssert(userInFirstVC())
        
    }
    
    func testNavigateToDetailVC() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.launch()

        app.tables.firstMatch.tap()
        
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: app.tables, handler: nil)
        waitForExpectations(timeout: 7, handler: nil)
        XCTAssert(userInDetailVC())
        
    }
    
    func userInFirstVC() -> Bool {
        let titleText = app.navigationBars.element.identifier
        if titleText == "Articles For This Month" {
            return true
        } else {
            return false
        }
    }
    
    func userInDetailVC() -> Bool {
        let titleText = app.navigationBars.element.identifier
        if titleText == "Article details" {
            return true
        } else {
            return false
        }
    }
    
}

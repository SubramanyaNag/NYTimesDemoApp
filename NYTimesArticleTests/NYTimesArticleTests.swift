//
//  NYTimesArticleTests.swift
//  NYTimesArticleTests
//
//  Created by subramanya on 17/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import XCTest
@testable import NYTimesArticle

class NYTimesArticleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetArticlesFromDB() {
        let expect = expectation(description: "Get the articles stored in DB")
        
        let dbBridge = DBBridge()
        dbBridge.getArticle { (articles, errorMessage) in
            if errorMessage == nil {
                XCTAssertNotNil(articles)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }
    
    func testGetArticlesFromWeb() {
        let expect = expectation(description: "Get the articles stored in DB")
        
        let vc = ViewController()
        vc.getArticlesFromWeb { (articles, error) in
            if error == nil {
                XCTAssertNotNil(articles)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }
    
}

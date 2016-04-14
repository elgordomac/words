//
//  DictionaryTest.swift
//  Words
//
//  Created by Gordon MacDonald on 4/3/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import XCTest
@testable import Words

class DictionaryTest: XCTestCase {
    
    var dictionary: Words.Dictionary = Dictionary()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValid() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(true)
        XCTAssert(dictionary.isValid("chicken"))
        XCTAssert(!dictionary.isValid("choockin"))
    }
    
    func testValidPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            let words = self.dictionary.getWords();
            for word in words {
                self.dictionary.isValid(word)
            }
        }
    }
    
    func testValidNSPerformance() {
     
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            let words = self.dictionary.getNSWords();
            for word in words {
                self.dictionary.isValid(word)
            }            
        }
    }
    
}

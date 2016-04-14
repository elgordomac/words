//
//  ScrabbleTest.swift
//  Words
//
//  Created by Gordon MacDonald on 4/3/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import XCTest
@testable import Words

class ScrabbleTest: XCTestCase {
    
    var dictionary: Words.Dictionary = Dictionary()
    var scrabble: Scrabble = Scrabble()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceIndexes() {
        // This is an example of a performance test case.
        self.measureBlock {
            
            let letter: Character = "c";
            let words = self.dictionary.getWords();
            var count: Int = 0
            for word in words {
                var indexes = self.scrabble.get_indexes_of(word, letter: letter);
                if(indexes.count > 0) {
                    count++
                }
            }
            print("count is " + String(count))
        }
    }
    
    func testPerformanceNSIndexes() {
        // This is an example of a performance test case.
        self.measureBlock {
            let letter: NSString = "c";
            let words = self.dictionary.getNSWords();
            var count: Int = 0
            for word in words {
                var indexes = self.scrabble.get_indexes_of(word, letter: letter);
                if(indexes.count > 0) {
                    count++
                }
            }
            print("nscount is " + String(count))
        }
    }
}

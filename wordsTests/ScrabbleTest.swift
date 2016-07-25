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
                var indexes = self.scrabble.get_indexes_of(word, letter: letter as String);
                if(indexes.count > 0) {
                    count++
                }
            }
            print("nscount is " + String(count))
        }
    }
    
    func testFindWords() {
        var board: Board = Board();
        board.set_row(0,  letters: "               ");
        board.set_row(1,  letters: "               ");
        board.set_row(2,  letters: "               ");
        board.set_row(3,  letters: "               ");
        board.set_row(4,  letters: "      biz      ");
        board.set_row(5,  letters: "      o        ");
        board.set_row(6,  letters: "      to       ");
        board.set_row(7,  letters: "               ");
        board.set_row(8,  letters: "               ");
        board.set_row(9,  letters: "               ");
        board.set_row(10, letters: "               ");
        board.set_row(11, letters: "               ");
        board.set_row(12, letters: "               ");
        board.set_row(13, letters: "               ");
        board.set_row(14, letters: "               ");
        
        
        var rack: Rack = Rack()
        rack.set("oo")
        
        var w = scrabble.place_word(board, row: 4, col: 8, word: "zoo", distribution: rack.get_distribution(), direction: "down")
        if (w != nil) {
            // score and check if its the highest
            w?.score = scrabble.score(w!);
            print("word is " + (w?.debugDescription)!)
            XCTAssert(w!.score == 15)
        }
        else {
            print("word was nil :(")
            XCTFail()
        }
        
    }
    
    func testFindWords2() {
        var board: Board = Board();
        board.set_row(0,  letters: "   p           ");
        board.set_row(1,  letters: "dozens         ");
        board.set_row(2,  letters: "i  a           ");
        board.set_row(3,  letters: "v  c           ");
        board.set_row(4,  letters: "a  e           ");
        board.set_row(5,  letters: "s              ");
        board.set_row(6,  letters: "               ");
        board.set_row(7,  letters: "               ");
        board.set_row(8,  letters: "               ");
        board.set_row(9,  letters: "               ");
        board.set_row(10, letters: "               ");
        board.set_row(11, letters: "               ");
        board.set_row(12, letters: "               ");
        board.set_row(13, letters: "               ");
        board.set_row(14, letters: "               ");
        
        
        var rack: Rack = Rack()
        rack.set("le")
        
        var w = scrabble.place_word(board, row: 4, col: 0, word: "ale", distribution: rack.get_distribution(), direction: "right")
        if (w != nil) {
            // score and check if its the highest
            w?.score = scrabble.score(w!);
            print("word is " + (w?.debugDescription)!)
            XCTFail()
        }
        else {
            print("word was nil, which is good because alee is not a word")
        }
    }
    
    func testFindWords3() {
        var board: Board = Board();
        board.set_row(0,  letters: "   p           ");
        board.set_row(1,  letters: "dozens         ");
        board.set_row(2,  letters: "i  a t         ");
        board.set_row(3,  letters: "v  c e         ");
        board.set_row(4,  letters: "a  e a         ");
        board.set_row(5,  letters: "s    m         ");
        board.set_row(6,  letters: "     y         ");
        board.set_row(7,  letters: "               ");
        board.set_row(8,  letters: "               ");
        board.set_row(9,  letters: "               ");
        board.set_row(10, letters: "               ");
        board.set_row(11, letters: "               ");
        board.set_row(12, letters: "               ");
        board.set_row(13, letters: "               ");
        board.set_row(14, letters: "               ");
        
        
        var rack: Rack = Rack()
        rack.set("d")
        
        var w = scrabble.place_word(board, row: 2, col: 3, word: "ad", distribution: rack.get_distribution(), direction: "right")
        if (w != nil) {
            // score and check if its the highest
            w?.score = scrabble.score(w!);
            print("word is " + (w?.debugDescription)!)
            XCTFail()
        }
        else {
            print("word was nil, which is good because alee is not a word")
        }
    }
}

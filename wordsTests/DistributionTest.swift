//
//  DistributionTest.swift
//  Words
//
//  Created by Gordon MacDonald on 4/3/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import XCTest
@testable import Words

class DistributionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let distribution: Distribution = Distribution()
        distribution.add("a")
        distribution.add("p")
        distribution.add("p")
        distribution.add("l")
        distribution.add("e")
        
        XCTAssert(distribution.can_make("apple"))
        XCTAssert(distribution.can_make("ape"))
        XCTAssert(!distribution.can_make("apples"))
        XCTAssert(!distribution.can_make("zoo"))
    }
}

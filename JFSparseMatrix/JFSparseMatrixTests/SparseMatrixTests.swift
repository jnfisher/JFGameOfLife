//
//  SparseMatrixTests.swift
//  SparseMatrixTests
//
//  Created by John Fisher on 2/6/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import UIKit
import XCTest
import JFSparseMatrix
import Foundation

class SparseMatrixTests: XCTestCase {
    var subject = SparseMatrix<Int>()
    
    override func setUp() {
        super.setUp()
        subject = SparseMatrix<Int>()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddingOneItem() {
        subject[0, 0] = 50
        XCTAssert(subject[0, 0] == 50)
    }
    
    func testOverwritingOneItem() {
        subject[10, 10] = 50
        subject[10, 10] = 42
        XCTAssert(subject[10, 10] == 42)
    }
    
    func testAccessingEmptyLocation() {
        XCTAssert(subject[0, 0] == nil)
    }
    
    func testCanIterate() {
        subject[0, 0] = 222
        
        for (key, value) in subject {
            XCTAssert(value == 222)
        }
    }
    
    func testCanIterateThroughAllItems() {
        subject[0, 0] = 222
        subject[0, 1] = 222
        subject[2, 0] = 222
        subject[3, 0] = 222
        subject[4, 1] = 222
        
        var count = 0
        for (key, value) in subject {
            XCTAssert(value == 222)
            count++
        }
        
        XCTAssert(count == 5, "\(subject.count) should be 5")
    }
    
    func testCount() {
        for ii in 0..<100 {
            subject[ii, Int(arc4random_uniform(1000))] = 0
        }
        XCTAssert(subject.count == 100, "Expect \(subject.count) to be 100")
    }
    
    func testNegativeHashing() {
        subject[-9, 3] = 42
        subject[-1000, -500] = 2112
        subject[-35000, 30000] = 3333
        
        XCTAssert(subject[-9, 3] == 42, "Expect \(subject[-9, 3]) to be 42")
        XCTAssert(subject[-1000, -500] == 2112, "Expect \(subject[-9000, -15000]) to be 2112")
        XCTAssert(subject[-35000, 30000] == 3333, "Expect \(subject[-35000, 30000]) to be 3333")
        XCTAssert(subject[-1, -1] == nil)
    }
    
    func testConstructionWithAnArrayOfTuples() {
        subject = SparseMatrix<Int>(array: [(0, 1, 3), (0, 2, 4)])
        
        XCTAssert(subject[0, 1] == 3, "Expect \(subject[0, 1]) to be 3")
        XCTAssert(subject[0, 2] == 4)
    }
}

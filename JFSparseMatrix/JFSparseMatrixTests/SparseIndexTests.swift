//
//  SparseIndexTests.swift
//  JFSparseMatrix
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import UIKit
import XCTest
import JFSparseMatrix
import Foundation

func == <T:Equatable> (tuple1:(T,T),tuple2:(T,T)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}


class SparseIndexTests: XCTestCase {
    let subject = SparseIndex(row: 5, col: 5)
    
    func testMoore() {
        var moore = subject.moore
        XCTAssert(moore.count == 8)
        XCTAssert(moore[0] == (4, 5))
        XCTAssert(moore[1] == (4, 6))
        XCTAssert(moore[2] == (5, 6))
        XCTAssert(moore[3] == (6, 6))
        XCTAssert(moore[4] == (6, 5))
        XCTAssert(moore[5] == (6, 4))
        XCTAssert(moore[6] == (5, 4))
        XCTAssert(moore[7] == (4, 4))
    }
}

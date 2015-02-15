//
//  SparseIndex.swift
//  JFSparseMatrix
//
//  Created by John Fisher on 2/9/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation

public class SparseIndex : Hashable, Equatable {
    public let row: Int = 0
    public let col: Int = 0
    
    public required init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    public var moore: [(Int, Int)] {
        get {
            return [(row-1, col  ),
                (row-1, col+1),
                (row  , col+1),
                (row+1, col+1),
                (row+1, col  ),
                (row+1, col-1),
                (row  , col-1),
                (row-1, col-1)]
        }
    }
    
    public var hashValue: Int {
        // Modified Szudzik pairing function,
        // http://stackoverflow.com/questions/919612/mapping-two-integers-to-one-in-a-unique-and-deterministic-way
        var A = row >= 0 ? 2 * row : -2 * row - 1
        var B = col >= 0 ? 2 * col : -2 * col - 1
        var C = (A >= B ? A * A + A + B : A + B * B) / 2
        return row < 0 && col < 0 || row >= 0 && col >= 0 ? C : -C - 1
    }
}

public func ==(lhs: SparseIndex, rhs: SparseIndex) -> Bool {
    return lhs.row == rhs.row && lhs.col == rhs.col
}
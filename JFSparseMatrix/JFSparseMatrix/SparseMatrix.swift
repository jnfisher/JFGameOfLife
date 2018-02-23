//
//  SparseMatrix.swift
//  JFSparseMatrix
//
//  Created by John Fisher on 2/6/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation

open class SparseMatrix<T: CustomStringConvertible> : Sequence, CustomStringConvertible {
    var matrix: [SparseIndex: T] = [:]
    
    open var minRow = Int.max
    open var minCol = Int.max
    open var maxRow = Int.min
    open var maxCol = Int.min
    
    public required init() {}
    
    public required init(array: Array<(Int, Int, T)>) {
        for a in array {
            self[a.0, a.1] = a.2
        }
    }
    
    open subscript(row: Int, column: Int) -> T? {
        get {
            return matrix[SparseIndex(row: row, col: column)]
        }
        set(data) {
            updateMinMax(row, column: column)
            matrix[SparseIndex(row: row, col: column)] = data
        }
    }
    
    open func makeIterator() -> DictionaryIterator<SparseIndex, T> {
        return matrix.makeIterator()
    }
    
    open var count: Int {
        get {
            return matrix.count
        }
    }
    
    open var description: String {
        get {
            var str = ""
            for (index, data) in matrix {
                str = str + "[\(index.row), \(index.col)] = \(data)\n"
            }
            return str
        }
    }
    
    fileprivate func updateMinMax(_ row: Int, column: Int) -> Void {
        if row > maxRow {
            maxRow = row
        }
        if row < minRow {
            minRow = row
        }
        
        if column > maxCol {
            maxCol = column
        }
        if column < minCol {
            minCol = column
        }
    }
}

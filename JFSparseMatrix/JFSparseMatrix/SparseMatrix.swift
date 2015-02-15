//
//  SparseMatrix.swift
//  JFSparseMatrix
//
//  Created by John Fisher on 2/6/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation

public class SparseMatrix<T: Printable> : SequenceType, Printable {
    var matrix: [SparseIndex: T] = [:]
    
    public var minRow = Int.max
    public var minCol = Int.max
    public var maxRow = Int.min
    public var maxCol = Int.min
    
    public required init() {}
    
    public required init(array: Array<(Int, Int, T)>) {
        for a in array {
            self[a.0, a.1] = a.2
        }
    }
    
    public subscript(row: Int, column: Int) -> T? {
        get {
            return matrix[SparseIndex(row: row, col: column)]
        }
        set(data) {
            updateMinMax(row, column: column)
            matrix[SparseIndex(row: row, col: column)] = data
        }
    }
    
    public func generate() -> DictionaryGenerator<SparseIndex, T> {
        return matrix.generate()
    }
    
    public var count: Int {
        get {
            return matrix.count
        }
    }
    
    public var description: String {
        get {
            var str = ""
            for (index, data) in matrix {
                str = str + "[\(index.row), \(index.col)] = \(data)\n"
            }
            return str
        }
    }
    
    private func updateMinMax(row: Int, column: Int) -> Void {
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

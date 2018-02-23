//
//  Rule.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public enum CellState {
    case unaffected
    case dead
    case alive
}

public protocol ApplicableRule {
    func apply(_ index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState
}

open class Rule : ApplicableRule {
    open func apply(_ index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return CellState.unaffected
    }
    
    func aliveNeighbors(_ index: SparseIndex, matrix: Matrix) -> Int {
        return index.moore.reduce(0, {
            if let data = matrix[$1.0, $1.1] {
                let cell = data as Cell
                if cell.state == CellState.alive {
                    return $0 + 1
                }
            }
            return $0
        })
    }
}

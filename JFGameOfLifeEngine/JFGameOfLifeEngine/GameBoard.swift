//
//  GameBoard.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public func buildMatrix(_ array: Array<(Int, Int, String)>) -> SparseMatrix<Cell> {
    var matrix = SparseMatrix<Cell>()
    for a in array {
        if a.2 == "alive" {
            matrix[a.0, a.1] = Cell(state: CellState.alive)
        }
        else if a.2 == "dead" {
            matrix[a.0, a.1] = Cell(state: CellState.dead)
        }
        else {
            matrix[a.0, a.1] = Cell(state: CellState.unaffected)
        }
    }
    return matrix
}

open class GameBoard<MatrixType: Matrix> {
    open let matrix: MatrixType
    let aliveRuleSet: Array<Rule>
    let deadRuleSet:  Array<Rule>

    public init(matrix : MatrixType, aliveRuleSet: Array<Rule>, deadRuleSet: Array<Rule>) {
        self.matrix = matrix
        self.aliveRuleSet = aliveRuleSet
        self.deadRuleSet = deadRuleSet
    }
    
    open func applyRules(_ index: SparseIndex) -> CellState {
        var state:CellState
        if let cell = matrix[index.row, index.col] {
            state = cell.state
        }
        else {
            state = CellState.dead
        }
        
        var rules = state == CellState.alive ? aliveRuleSet : deadRuleSet
        var numAlive = Rule().aliveNeighbors(index, matrix: matrix)
        
        for rule in rules {
            var ruling = rule.apply(index, matrix: matrix, numAliveNeighbors: numAlive)
            if ruling != CellState.unaffected {
                return ruling
            }
        }

        return CellState.dead
    }
}

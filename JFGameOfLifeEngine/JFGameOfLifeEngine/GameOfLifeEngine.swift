//
//  GameOfLifeEngine.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

open class Cell : CustomStringConvertible {
    open var state = CellState.unaffected
    public init(state: CellState) {
        self.state = state
    }
    
    open var description: String {
        get {
            if self.state == CellState.alive {
                return "alive"
            }
            else if self.state == CellState.dead {
                return "dead"
            }
            else {
                return "unused"
            }
        }
    }
}

public typealias Matrix = SparseMatrix<Cell>
public typealias GameOfLifeBoard = GameBoard<Matrix>

extension SparseMatrix {
    
}

open class GameOfLifeEngine {
    open var currentBoard:GameBoard<Matrix>
    
    public init(initialBoard: GameBoard<Matrix>) {
        self.currentBoard = initialBoard
    }
    
    public init() {
        self.currentBoard = GameBoard(matrix: Matrix(), aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset)
    }
    
    open func step() -> GameBoard<Matrix> {
        let nextBoard = Matrix(array: processedCurrentlyAliveCells + processedLiveNeighboringCells)
        return GameBoard<Matrix>(matrix: nextBoard, aliveRuleSet: currentBoard.aliveRuleSet, deadRuleSet: currentBoard.deadRuleSet)
    }
    
    open func swap(_ newBoard: GameBoard<Matrix>) {
        self.currentBoard = newBoard
    }
    
    open var processedCurrentlyAliveCells: Array<(Int, Int, Cell)> {
        get {
            let cells = currentBoard.matrix.map { (key, cell) -> (Int, Int, Cell) in
                if cell.state == CellState.alive {
                    return (key.row, key.col, Cell(state: self.currentBoard.applyRules(key)))
                }
                else {
                    return (key.row, key.col, Cell(state: CellState.unaffected))
                }
            }
            
            return cells.filter { $0.2.state != CellState.unaffected }
        }
    }
    
    open var processedLiveNeighboringCells: Array<(Int, Int, Cell)> {
        get {
            let processedCellCache = Matrix()
            for (index, cell) in currentBoard.matrix {
                if cell.state == CellState.alive {
                    for (row, col) in index.moore {
                        if currentBoard.matrix[row, col]?.state == CellState.alive {
                            // skip currently alive cells, they were already processed
                            continue
                        }
                        
                        if processedCellCache[row, col] == nil {
                            processedCellCache[row, col] = Cell(state: self.currentBoard.applyRules(SparseIndex(row: row, col: col)))
                        }
                    }
                }
            }
            
            let cells = processedCellCache.map { (key, cell) -> (Int, Int, Cell) in
                return (key.row, key.col, cell)
            }
            
            return cells.filter { $0.2.state == CellState.alive }
        }
    }
}



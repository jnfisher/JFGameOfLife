//
//  ConwaysRules.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/7/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation
import JFSparseMatrix

public struct ConwaysRules {
    public static let aliveRuleset = [FewerThanTwoLiveNeighbors(), TwoOrThreeLiveNeighbors(), MoreThanThreeLiveNeighbors()]
    public static let deadRuleset  = [ExactlyThreeLiveNeighbors()]
}

open class FewerThanTwoLiveNeighbors : Rule {
    open override func apply(_ index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors < 2 ? CellState.dead : CellState.unaffected
    }
}

open class TwoOrThreeLiveNeighbors : Rule {
    open override func apply(_ index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors == 2 || numAliveNeighbors == 3 ? CellState.alive : CellState.unaffected
    }
}

open class MoreThanThreeLiveNeighbors : Rule {
    open override func apply(_ index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors > 3 ? CellState.dead : CellState.unaffected
    }
}

open class ExactlyThreeLiveNeighbors : Rule {
    open override func apply(_ index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors == 3 ? CellState.alive : CellState.unaffected
    }
}

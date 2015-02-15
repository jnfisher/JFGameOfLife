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

public class FewerThanTwoLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors < 2 ? CellState.Dead : CellState.Unaffected
    }
}

public class TwoOrThreeLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors == 2 || numAliveNeighbors == 3 ? CellState.Alive : CellState.Unaffected
    }
}

public class MoreThanThreeLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors > 3 ? CellState.Dead : CellState.Unaffected
    }
}

public class ExactlyThreeLiveNeighbors : Rule {
    public override func apply(index: SparseIndex, matrix: Matrix, numAliveNeighbors: Int) -> CellState {
        return numAliveNeighbors == 3 ? CellState.Alive : CellState.Unaffected
    }
}

//
//  GameScene.swift
//  JFGameOfLife
//
//  Created by John Fisher on 2/11/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import SpriteKit
import JFSparseMatrix
import JFGameOfLifeEngine

class GameScene: SKScene {
    var lastUpdatedAtTime:CFTimeInterval = -1.0
    var engine = GameOfLifeEngine()
    
    let boardNode = SKNode()
    let sprite = SKSpriteNode(imageNamed: "Cell.png")

    var boardXScale:CGFloat = 1.0
    var boardYScale:CGFloat = 1.0
    
    override func didMoveToView(view: SKView) {
        boardNode.xScale = boardXScale
        boardNode.yScale = boardYScale
        self.addChild(boardNode)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        if currentTime - lastUpdatedAtTime > 0.0333 {
            engine.swap(engine.step())
            draw(engine.currentBoard, currentTime: currentTime)
        }
    }
    
    func draw(board: GameOfLifeBoard, currentTime: CFTimeInterval) -> Void {
        lastUpdatedAtTime = currentTime
        boardNode.removeAllChildren()
        
        var board = engine.currentBoard
        var cols  = (board.matrix.maxCol - board.matrix.minCol)
        var rows = (board.matrix.maxRow - board.matrix.minRow)
        self.size = CGSize(width: rows, height: cols)
        
        for (index, cell) in board.matrix {
            if cell.state == CellState.Alive {
                var cellNode = sprite.copy() as SKSpriteNode
                cellNode.position = CGPoint(x: CGFloat(index.row), y: CGFloat(index.col))
                boardNode.addChild(cellNode)
            }
        }
    }
}

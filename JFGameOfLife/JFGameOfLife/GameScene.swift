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
    
    override func didMove(to view: SKView) {
        boardNode.xScale = boardXScale
        boardNode.yScale = boardYScale
        self.addChild(boardNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
    }
   
    override func update(_ currentTime: TimeInterval) {
        if currentTime - lastUpdatedAtTime > 0.0333 {
            engine.swap(engine.step())
            draw(engine.currentBoard, currentTime: currentTime)
        }
    }
    
    func draw(_ board: GameOfLifeBoard, currentTime: CFTimeInterval) -> Void {
        lastUpdatedAtTime = currentTime
        boardNode.removeAllChildren()
        
        let board = engine.currentBoard
        let cols  = (board.matrix.maxCol - board.matrix.minCol)
        let rows = (board.matrix.maxRow - board.matrix.minRow)
        

        self.size = CGSize(width: rows, height: cols)
        
        for (index, cell) in board.matrix {
            if cell.state == CellState.alive {
                if let  cellNode = sprite.copy() as? SKSpriteNode {
                    cellNode.position = CGPoint(x: CGFloat(index.row), y: CGFloat(index.col))
                    boardNode.addChild(cellNode)
                }
            }
        }
    }
}

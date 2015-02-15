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
    
    let sprite = SKSpriteNode(imageNamed: "Cell.png")
    let cellResolution:CGFloat = 2.0
    
    override func didMoveToView(view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.xScale = cellResolution
        sprite.yScale = cellResolution
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        if lastUpdatedAtTime < 0.0 {
            if let importedBoard = RLEReader().buildBoard("gun-p165mwss") {
                println("Lower Left: \(importedBoard.matrix.minCol), \(importedBoard.matrix.minRow)  Upper Right \(importedBoard.matrix.maxCol), \(importedBoard.matrix.maxRow)")
                
                engine.swap(importedBoard)
                draw(engine.currentBoard, currentTime: currentTime)
            }
            else {
                engine.swap(GameBoard(matrix: Matrix(), aliveRuleSet: [], deadRuleSet: []))
            }
        }
        else {
            if currentTime - lastUpdatedAtTime > 0.1 {
                engine.swap(engine.step())
                draw(engine.currentBoard, currentTime: currentTime)
            }
        }
    }
    
    func draw(board: GameOfLifeBoard, currentTime: CFTimeInterval) -> Void {
        lastUpdatedAtTime = currentTime
//        println(board.matrix)
        
        self.removeAllChildren()
        for (index, cell) in board.matrix {
            if cell.state == CellState.Alive {
                var cellNode = sprite.copy() as SKSpriteNode
                cellNode.position = CGPoint(x: CGFloat(index.row)*cellResolution, y: CGFloat(index.col)*cellResolution)
                self.addChild(cellNode)
            }
        }
    }
}

//
//  GameViewController.swift
//  JFGameOfLife
//
//  Created by John Fisher on 2/11/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import UIKit
import SpriteKit
import JFSparseMatrix
import JFGameOfLifeEngine

extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        if let url = Bundle.main.url(forResource: file as String, withExtension: "sks") {
            let sceneData = try? Data(contentsOf: url, options: .mappedIfSafe)
            
            if sceneData != nil {
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData!)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
                archiver.finishDecoding()
                return scene
            }
        }
        
        return nil
    }
}

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
//            scene.anchorPoint = CGPoint(x: 0.25, y: 0.25)
            
            if let board = RLEReader().buildBoard("sidecargun") {
                let cols  = (board.matrix.maxCol - board.matrix.minCol)
                let rows = (board.matrix.maxRow - board.matrix.minRow)
                scene.size = CGSize(width: rows, height: cols)
                scene.engine.swap(board)
            }
            else {
                scene.engine.swap(GameBoard(matrix: Matrix(), aliveRuleSet: [], deadRuleSet: []))
            }
        
            
            skView.presentScene(scene)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

//    override func supportedInterfaceOrientations() -> Int {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return Int(UIInterfaceOrientationMask.allButUpsideDown.rawValue)
//        } else {
//            return Int(UIInterfaceOrientationMask.all.rawValue)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}

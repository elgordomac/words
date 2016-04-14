//
//  GameViewController.swift
//  words
//
//  Created by Gordon MacDonald on 1/30/16.
//  Copyright (c) 2016 Gordon MacDonald. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    let log_level = "info";
    
    var scrabble : Scrabble = Scrabble()
    
    var scene: GameScene!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .ResizeFill
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    func beginGame() {
        //shuffle()
    }
    
    func shuffle() {
    }
    
    
}
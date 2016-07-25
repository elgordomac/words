//
//  Banner.swift
//  Words
//
//  Created by Gordon MacDonald on 2/28/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import SpriteKit

class Banner {
    // current word
    // best so far
    // iterations
    // time elapsed
    var parent: SKNode
    var status_image: SKSpriteNode?
    var current_word: SKLabelNode = SKLabelNode(fontNamed: "Arial");
    var best: SKLabelNode = SKLabelNode(fontNamed: "Arial");
    var iterations: SKLabelNode = SKLabelNode(fontNamed: "Arial");
    var time_elapsed: SKLabelNode = SKLabelNode(fontNamed: "Arial");
    
    init(parent: SKNode) {
        self.parent = parent
        
        self.current_word.text = ""
        self.current_word.fontSize = 12
        self.current_word.fontColor = SKColor.blackColor()
        self.current_word.position = CGPoint(x: -100,y: 316)
        self.current_word.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        self.best.text = ""
        self.best.fontSize = 12
        self.best.fontColor = SKColor.blackColor()
        self.best.position = CGPoint(x: -100,y: 298)
        self.best.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        self.iterations.text = ""
        self.iterations.fontSize = 12
        self.iterations.fontColor = SKColor.blackColor()
        self.iterations.position = CGPoint(x: -100,y: 282)
        self.iterations.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        self.time_elapsed.text = ""
        self.time_elapsed.fontSize = 12
        self.time_elapsed.fontColor = SKColor.blackColor()
        self.time_elapsed.position = CGPoint(x: -100,y: 266)
        self.time_elapsed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        parent.addChild(self.current_word)
        parent.addChild(self.best)
        parent.addChild(self.iterations)
        parent.addChild(self.time_elapsed)
    }
    
    func set_status(status: String) {
        
        if(status_image != nil) {
            status_image?.removeFromParent()
            status_image = nil
        }
        
            status_image = SKSpriteNode(imageNamed: status)
            status_image!.position = CGPoint(x: -148, y: 295)
            status_image?.setScale(0.5)
            parent.addChild(status_image!)
        
    }
    
    func set_text(string: String) {
        self.current_word.text = "";
        self.best.text = string;
        self.iterations.text = "";
        self.time_elapsed.text = "";
    }
    
    func set_info(current_word: NSString?, best: String?, iterations: String?, time_elapsed: Double?) {
        
        dispatch_async(dispatch_get_main_queue()) {
         
        if(current_word != nil) {
            self.current_word.text = "current: " + (current_word! as String)
        }
        else {
            self.current_word.text = "current: "
        }
        
        if(best != nil) {
            self.best.text = "best: " + best!
        }
        else {
            self.best.text = "best: "
        }
        
        if(iterations != nil) {
            self.iterations.text = "iterations: " + iterations!
        }
        else {
            self.iterations.text = "iterations: "
        }
        
        if(time_elapsed != nil) {
            self.time_elapsed.text = "elapsed: " + String(format: "%.2f", time_elapsed!) + "s"
        }
        else {
            self.time_elapsed.text = "elapsed: "
        }
        }
    }
}

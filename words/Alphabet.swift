//
//  Alphabet.swift
//  words
//
//  Created by Gordon MacDonald on 1/30/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import SpriteKit

class Alphabet {
    
    var alphabet: SKNode
    let TileWidth: CGFloat = 25.0
    let TileHeight: CGFloat = 25.0
    var row1 = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
    var row2 = ["j", "k", "l", "m", "n", "o", "p", "q", "r"]
    var row3 = ["s", "t", "u", "v", "w", "x", "y", "z", "blank"]
    
    init(alphabet: SKNode) {
        self.alphabet = alphabet
        
        var start = 0-(CGFloat(row1.count) * TileWidth - TileWidth)/2;
        for letter in row1 {
            
            let sprite = SKSpriteNode(imageNamed: letter)
            sprite.position = CGPoint(x: start, y: (0 - 0.5 * TileWidth))
            alphabet.addChild(sprite)
            start += TileWidth
        }
        start = 0-(CGFloat(row2.count) * TileWidth - TileWidth)/2;
        for letter in row2 {
            
            let sprite = SKSpriteNode(imageNamed: letter)
            sprite.position = CGPoint(x: start, y: (0 - 1.5 * TileWidth))
            alphabet.addChild(sprite)
            start += TileWidth
        }
        start = 0-(CGFloat(row3.count) * TileWidth - TileWidth)/2;
        for letter in row3 {
            
            let sprite = SKSpriteNode(imageNamed: letter)
            sprite.position = CGPoint(x: start, y: (0 - 2.5 * TileWidth))
            alphabet.addChild(sprite)
            start += TileWidth
        }
    }
    
    func get_letter(point: CGPoint) -> Character? {
        print("alphabet " + point.x.description + "," + point.y.description);
        
        var row1 = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        var row2 = ["j", "k", "l", "m", "n", "o", "p", "q", "r"]
        var row3 = ["s", "t", "u", "v", "w", "x", "y", "z", "blank"]
        
        
        var i: Int? = Int((point.x + ((CGFloat(row1.count) * TileWidth)/2))/TileWidth);
               
        if(i != nil) {
            if(point.y < 0 && point.y >= -25) {
                var c: Character?
                if(i == 0) { c = "a" }
                else if(i == 1) { c = "b" }
                else if(i == 2) { c = "c" }
                else if(i == 3) { c = "d" }
                else if(i == 4) { c = "e" }
                else if(i == 5) { c = "f" }
                else if(i == 6) { c = "g" }
                else if(i == 7) { c = "h" }
                else if(i == 8) { c = "i" }
                else {
                    return nil
                }
                
                return c!
            }
            else if(point.y < -25 && point.y >= -50) {
                var c: Character?
                if(i == 0) { c = "j" }
                else if(i == 1) { c = "k" }
                else if(i == 2) { c = "l" }
                else if(i == 3) { c = "m" }
                else if(i == 4) { c = "n" }
                else if(i == 5) { c = "o" }
                else if(i == 6) { c = "p" }
                else if(i == 7) { c = "q" }
                else if(i == 8) { c = "r" }
                else {
                    return nil
                }
                
                return c!
                
            }
            else if(point.y < -50 && point.y >= -75) {
                var c: Character?
                if(i == 0) { c = "s" }
                else if(i == 1) { c = "t" }
                else if(i == 2) { c = "u" }
                else if(i == 3) { c = "v" }
                else if(i == 4) { c = "w" }
                else if(i == 5) { c = "x" }
                else if(i == 6) { c = "y" }
                else if(i == 7) { c = "z" }
                else if(i == 8) { c = " " }
                else {
                    return nil
                }
                
                return c!
                
            }
            else {
                return nil
            }
        }
        
        return nil
    }
}

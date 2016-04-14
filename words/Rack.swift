//
//  Rack.swift
//  words
//
//  Created by Gordon MacDonald on 2/7/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import Foundation
import SpriteKit

class Rack {
    var rack: Array<Tile>;
    let TileWidth: CGFloat = 25.0
    let TileHeight: CGFloat = 25.0
    
    init () {
        self.rack = [Tile(),Tile(),Tile(),Tile(),Tile(),Tile(),Tile()]
    }
    
    func set(letters: String) {
        
        var position: Int = 0;
        for letter in letters.characters {
            self.rack[position].letter = letter;
            position++;
        }
    }
    
    func get(position: Int) -> Tile {
        return rack[position]
    }
    
    func get_letters() -> [Character] {
        
        var ww: String = "";
        for tile in self.rack {
            if(tile.letter != nil) {
                ww.append(tile.letter!)
            }
        }
        
        return [Character] (ww.characters)
    }
    
    func positionForTile(position: Int) -> CGPoint {
        return CGPoint(
            x: 100 + (CGFloat(position)*TileWidth) + TileWidth/2,
            y: -30)
    }
    
    func commit(layer: SKNode) {
        
        for (var position = 0; position < rack.count; position++) {
            
            if(rack[position].letter != nil) {
                let tile = rack[position];
                if (tile.letter != nil) {
                    if(tile.sprite == nil) {
                        let sprite = SKSpriteNode(imageNamed: String(tile.letter!))
                        sprite.position = positionForTile(position)
                        layer.addChild(sprite)
                        tile.sprite = sprite
                    }
                    else {
                        tile.sprite?.alpha = 1.0
                    }
                    
                    if(!tile.yellow) {
                        print("committing " + position.description)
                        tile.yellow = true;
                    }
                }
            }
        }
    }
    
    func reset() {
        
        for (var position = 0; position < rack.count; position++) {
            
            let tile = rack[position];
            tile.letter = nil
            tile.yellow = false
            if(tile.sprite != nil) {
                tile.sprite?.removeFromParent()
            }
            tile.sprite = nil
            tile.used = false            
        }
    }
    
    func get_distribution() -> Distribution {
        
        var distribution: Distribution = Distribution()
        distribution.add(self.get_letters())

        return distribution
    }
    
    func serialize() -> String {
        
        var serialized: String = "";
        for tile in self.rack {
            if(tile.letter != nil) {
                serialized.append(tile.letter!)
            }
        }
        
        return serialized
    }
    
    func deserialize(serialized: String) {
        
        var position: Int = 0;
        for letter in serialized.characters {
            self.rack[position].letter = letter;
            position++;
        }
    }
}
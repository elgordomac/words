//
//  Tile.swift
//  scrabble
//
//  Created by Gordon MacDonald on 1/10/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import SpriteKit

class Tile {
    
    var row: Int = -1;
    var col: Int = -1;
    var used: Bool = false;
    var yellow: Bool = false;
    var feature: String = ""; // CENTER,DL,TL,DW,TW
    var letter: Character?;
    var sprite: SKSpriteNode?
    var up: Tile?
    var down: Tile?
    var left: Tile?
    var right: Tile?
}
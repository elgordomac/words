//
//  Word.swift
//  scrabble
//
//  Created by Gordon MacDonald on 1/10/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import Foundation

class Word {
    
    var word: String = "";
    var row: Int = -1;
    var col: Int = -1;
    var direction: String = "";
    var tiles: Array<Tile> = [];
    var score: Int = -1;
    
    init (word: String, row: Int, col: Int, direction: String, tiles: Array<Tile>) {
        self.word = word
        self.row = row
        self.col = col
        self.direction = direction
        self.tiles = tiles
    }
    
    var debugDescription: String {
        return word + " starting at " + String(row) + "," + String(col) + " going " + direction  + " (" + String(score) + " pts)";
    }
}
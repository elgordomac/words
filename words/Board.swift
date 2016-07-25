//
//  Board.swift
//  scrabble
//
//  Created by Gordon MacDonald on 1/17/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import Foundation
import SpriteKit

class Board {
    private var board = Array<Array<Tile>>(count: 15, repeatedValue: Array<Tile>());
    
    let TileWidth: CGFloat = 25.0
    let TileHeight: CGFloat = 25.0
    
    init () {
        
        // create the board structure...
        for (var row = 0; row < 15; row++) {
            board[row] = Array<Tile>(count: 15, repeatedValue: Tile());
            for (var col = 0; col < 15; col++) {
                let tile = Tile();
                tile.letter = nil;
                tile.used = false;
                tile.yellow = false;
                tile.row = row;
                tile.col = col;
                board[row][col] = tile;
            }
        }
        
        // set up the relationships
        for (var row = 0; row < 15; row++) {
            for (var col = 0; col < 15; col++) {
                let tile = get_tile(row, col: col)
                if(row > 0) { tile.up = get_tile(row - 1, col: col) }
                if(row < 14) { tile.down = get_tile(row + 1, col: col) }
                if(col > 0) { tile.left = get_tile(row, col: col - 1) }
                if(col < 14) { tile.right = get_tile(row, col: col + 1) }
            }
        }
        
        // add the feature pieces
        get_tile(0, col: 3).feature = "TW";
        get_tile(0, col: 6).feature = "TL";
        get_tile(0, col: 8).feature = "TL";
        get_tile(0, col: 11).feature = "TW";
        get_tile(1, col: 2).feature = "DL";
        get_tile(1, col: 5).feature = "DW";
        get_tile(1, col: 9).feature = "DW";
        get_tile(1, col: 12).feature = "DL";
        get_tile(2, col: 1).feature = "DL";
        get_tile(2, col: 4).feature = "DL";
        get_tile(2, col: 10).feature = "DL";
        get_tile(2, col: 13).feature = "DL";
        get_tile(3, col: 0).feature = "TW";
        get_tile(3, col: 3).feature = "TL";
        get_tile(3, col: 7).feature = "DW";
        get_tile(3, col: 11).feature = "TL";
        get_tile(3, col: 14).feature = "TW";
        get_tile(4, col: 2).feature = "DL";
        get_tile(4, col: 6).feature = "DL";
        get_tile(4, col: 8).feature = "DL";
        get_tile(4, col: 12).feature = "DL";
        get_tile(5, col: 1).feature = "DW";
        get_tile(5, col: 5).feature = "DL";
        get_tile(5, col: 9).feature = "DL";
        get_tile(5, col: 13).feature = "DW";
        get_tile(6, col: 0).feature = "TL";
        get_tile(6, col: 4).feature = "DL";
        get_tile(6, col: 10).feature = "DL";
        get_tile(6, col: 14).feature = "TL";
        get_tile(7, col: 3).feature = "DW";
        get_tile(7, col: 7).feature = "CENTER";
        get_tile(7, col: 11).feature = "DW";
        get_tile(8, col: 0).feature = "TL";
        get_tile(8, col: 4).feature = "DL";
        get_tile(8, col: 10).feature = "DL";
        get_tile(8, col: 14).feature = "TL";
        get_tile(9, col: 1).feature = "DW";
        get_tile(9, col: 5).feature = "DL";
        get_tile(9, col: 9).feature = "DL";
        get_tile(9, col: 13).feature = "DW";
        get_tile(10, col: 2).feature = "DL";
        get_tile(10, col: 6).feature = "DL";
        get_tile(10, col: 8).feature = "DL";
        get_tile(10, col: 12).feature = "DL";
        get_tile(11, col: 0).feature = "TW";
        get_tile(11, col: 3).feature = "TL";
        get_tile(11, col: 7).feature = "DW";
        get_tile(11, col: 11).feature = "TL";
        get_tile(11, col: 14).feature = "TW";
        get_tile(12, col: 1).feature = "DL";
        get_tile(12, col: 4).feature = "DL";
        get_tile(12, col: 10).feature = "DL";
        get_tile(12, col: 13).feature = "DL";
        get_tile(13, col: 2).feature = "DL";
        get_tile(13, col: 5).feature = "DW";
        get_tile(13, col: 9).feature = "DW";
        get_tile(13, col: 12).feature = "DL";
        get_tile(14, col: 3).feature = "TW";
        get_tile(14, col: 6).feature = "TL";
        get_tile(14, col: 8).feature = "TL";
        get_tile(14, col: 11).feature = "TW";
    }
    
    func set_row(row: Int, letters: String) {
        
        var col: Int = 0;
        for letter in letters.characters {
            let tile = board[row][col];
            if (letter != " ") {
                tile.letter = letter;
                tile.yellow = true;
            }
            else {
                tile.letter = nil;
                tile.yellow = false;
            }
            
            col++;
        }
    }
    
    func set(row: Int, col: Int, letter: Character) {
        board[row][col].letter = letter;
    }
    
    func get(row: Int, col: Int) -> Character? {
        return board[row][col].letter;
    }
    
    func set_tile(row: Int, col: Int, tile: Tile) {
        board[row][col] = tile;
    }
    
    func get_tile(row: Int, col: Int) -> Tile {
        return board[row][col];
    }
    
    func move(row: Int, col: Int, toRow: Int, toCol: Int) {
        let from = board[row][col];
        let to = board[toRow][toCol];
        to.letter = from.letter;
        to.sprite = from.sprite
        to.yellow = from.yellow;
        from.letter = nil;
        from.sprite = nil;
        from.yellow = false;
    }
    
    func add_word(word: Word) -> Bool {
        return false;
    }
    
    func reset_letters() {
        return
        for row in board {
            for tile in row {
                if (!tile.yellow) {
                    tile.letter = nil;
                }
                tile.used = false;
            }
        }
    }
    
    func commit(layer: SKNode) {
        
            for (var row = 0; row < 15; row++) {
                for (var col = 0; col < 15; col++) {
                    let tile = board[row][col];
                    if (tile.letter != nil) {
                        if(tile.sprite == nil) {
                            let sprite = SKSpriteNode(imageNamed: String(tile.letter!))
                            sprite.position = positionForTile(col, column: row)
                            layer.addChild(sprite)
                            tile.sprite = sprite
                        }
                        else {
                            tile.sprite?.alpha = 1.0
                        }
                        
                        if(!tile.yellow) {
                            print("committing " + row.description + "," + col.description)
                            tile.yellow = true;
                        }
                    }
                    else {
                        if(tile.sprite != nil) {
                            tile.sprite?.removeFromParent()
                        }
                        tile.yellow = false;
                    }
                    tile.used = false;
                }
            }
    }
    
    func reset() {
        
        for (var row = 0; row < 15; row++) {
            for (var col = 0; col < 15; col++) {
                let tile = board[row][col];
                tile.letter = nil
                tile.yellow = false
                if(tile.sprite != nil) {
                    tile.sprite?.removeFromParent()
                }
                tile.sprite = nil
                tile.used = false
            }
        }
    }
    
    func positionForTile(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(row)*TileWidth + TileWidth/2,
            y: CGFloat(14-column)*TileHeight + TileHeight/2)
    }
    
    var debugDescription: String {
        
        print("  012345678901234");
        for (var row = 0; row < 15; row++) {
            var b: String = String()
            if(row < 10) {
                b = b + " ";
            }
            b = b + String(row);
            for (var col = 0; col < 15; col++) {
                if(board[row][col].letter == nil) {
                    b = b + " ";
                }
                else {
                    b.append(self.get(row, col: col)!)
                }
            }
            print(b);
        }
        return "";
    }
    
    func get_distribution() -> Distribution {
        
        var distribution: Distribution = Distribution()
        for (var row = 0; row < 15; row++) {
            for (var col = 0; col < 15; col++) {
                if(board[row][col].letter != nil) {
                    distribution.add(board[row][col].letter!)
                }
            }
        }
        
        return distribution
    }
    
    func serialize() -> String {
        
        var serialized: String = "";
        for (var row = 0; row < 15; row++) {
            for (var col = 0; col < 15; col++) {
                if(board[row][col].letter == nil) {
                    serialized.append(Character(" "))
                }
                else {
                    serialized.append(self.get(row, col: col)!)
                }
            }
        }
        
        return serialized
    }
    
    func deserialize(serialized: String) {
        var index: Int = 0;
        for (var row = 0; row < 15; row++) {
            for (var col = 0; col < 15; col++) {
                let letter = serialized[serialized.startIndex.advancedBy(index)]
                let tile = board[row][col];
                if (letter != " ") {
                    tile.letter = letter;
                    tile.yellow = true;
                }
                else {
                    tile.letter = nil;
                    tile.yellow = false;
                }
                index++;
            }
        }
    }
}
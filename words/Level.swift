//
//  Level.swift
//  words
//
//  Created by Gordon MacDonald on 1/30/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import SpriteKit

let NumColumns = 15
let NumRows = 15

class Level {
    private var cookies = Array2D<Cookie>(columns: NumColumns, rows: NumRows)
    
    func cookieAtColumn(column: Int, row: Int) -> Cookie? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cookies[column, row]
    }
    
    func shuffle() -> Set<Cookie> {
        return createInitialCookies()
    }
    
    func addCookie(sprite: SKSpriteNode?, letter: Character, row: Int, column: Int) {
        let cookie = Cookie(column: column, row: row, letter: letter, sprite: sprite!)
        cookies[column, row] = cookie
    }
    
    func moveCookie(row: Int, column: Int, toRow: Int, toColumn: Int) {
        cookies[toColumn,toRow] = cookies[column, row]
        cookies[column, row] = nil;
    }
    
    private func createInitialCookies() -> Set<Cookie> {
        var set = Set<Cookie>()
        
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                var chance = Int(arc4random_uniform(2))
                if chance == 0 {
                
                // 2
                    var letter: Character = "k"
                // 3
                    let cookie = Cookie(column: column, row: row, letter: letter)
                cookies[column, row] = cookie
                
                // 4
                set.insert(cookie)
                }
            }
        }
        return set
    }
}

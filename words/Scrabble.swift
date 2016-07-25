//
//  Scrabble.swift
//  scrabble
//
//  Created by Gordon MacDonald on 1/10/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//
// TODO - change seeking (find word etc) to up,down,left,right
// TODO - conditional debug statements
// TODO - return score-sorted list of words
// TODO - handle blanks
// best on debug 131 (UI updates to 1000 saved 1.5 secs)

import Foundation
import SpriteKit

class Scrabble {
    
    var dictionary : Dictionary = Dictionary();
    var letter_values: [String: Int];
    var log_level = "info"
    var log: UILabel?;
    var banner: Banner?
    
    init() {
        // set up the letter values...
        letter_values = [String: Int]()
        letter_values["a"] = 1;
        letter_values["b"] = 4;
        letter_values["c"] = 4;
        letter_values["d"] = 2;
        letter_values["e"] = 1;
        letter_values["f"] = 4;
        letter_values["g"] = 3;
        letter_values["h"] = 3;
        letter_values["i"] = 1;
        letter_values["j"] = 10;
        letter_values["k"] = 5;
        letter_values["l"] = 2;
        letter_values["m"] = 4;
        letter_values["n"] = 2;
        letter_values["o"] = 1;
        letter_values["p"] = 4;
        letter_values["q"] = 10;
        letter_values["r"] = 1;
        letter_values["s"] = 1;
        letter_values["t"] = 1;
        letter_values["u"] = 2;
        letter_values["v"] = 5;
        letter_values["w"] = 4;
        letter_values["x"] = 8;
        letter_values["y"] = 3;
        letter_values["z"] = 10;
       
    }
    
    func log_console(level: String, message: String) {
        
        if (level == "info" || (level == "debug" && log_level == "debug")) {
            print(level + " : " + message);            
        }
    }
    
    func update_progress(text: String) {
        // current word
        // best so far
        // iterations
        // time elapsed
        
        dispatch_async(dispatch_get_main_queue()) {
            self.banner!.set_text(text);
        }
    }
    
    func update_text(text: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.banner!.set_text(text);
        }
    }
    
    func run(board: Board, rack: Rack, banner: Banner) -> Word? {
        
        let letters: [Character] = rack.get_letters();
        
        self.banner = banner;
        self.log = UILabel();
        update_text("starting...")
        
        let startTime = CFAbsoluteTimeGetCurrent()
        print("solving with letters " + letters.debugDescription + " for board:")
        debug_board(board);
        
        // get the seeds...
        let seeds = find_seeds(board);
        
        let word: Word? = position_words(board, seeds: seeds, rack: rack, dictionary: dictionary);

        print("completed in " + String(CFAbsoluteTimeGetCurrent() - startTime))
        return word
    }
    
    func find_seeds(board: Board) -> Array<Tile> {
        
        // get the seed tiles (the yellow ones on the board)...
        var seeds = Array<Tile>();
        for (var i = 0; i < 15; i += 1) {
            for (var j = 0; j < 15; j += 1) {
                let tile = board.get_tile(i, col: j);
                if (tile.yellow) {
                    
                    if((tile.up != nil && !tile.up!.yellow) ||
                        (tile.down != nil && !tile.down!.yellow) ||
                        (tile.left != nil && !tile.left!.yellow) ||
                        (tile.right != nil && !tile.right!.yellow)) {
                            seeds.append(tile);
                    }
                    else {
                        print("tile " + i.description + "," + j.description + " is boxed in, skipping as a seed");
                    }
                }
            }
        }
        
        // if there are no seed tiles then the seed is the center
        if (seeds.count == 0) {
            seeds.append(board.get_tile(7,col: 7));
        }
        
        print("found " + String(seeds.count) + " seeds")
        return seeds;
    }
    
    func get_letters(board: Board) -> [Character] {
        var unique = Set<Character>();
        
        for (var row = 0; row < 15; row += 1) {
            for (var col = 0; col < 15; col += 1) {
                let a: Character? = board.get(row, col: col);
                if(a != nil) {
                    unique.insert(a!)
                }
            }
        }
        
        print("extracted " + String(unique.count) + " unique letters from board")
        return unique.sort()
    }
    
    func get_distribution(board: Board, rack: Rack) -> Distribution {
        let distribution: Distribution = Distribution()
        
        distribution.add(board.get_distribution())
        distribution.add(rack.get_distribution())
        
        print("extracted distribution from board")
        return distribution
    }
    
    func debug_board(board: Board) {
        
        print("  012345678901234");
        for (var row = 0; row < 15; row += 1) {
            var b: String = String()
            if(row < 10) {
                b = b + " ";
            }
            b = b + String(row);
            for (var col = 0; col < 15; col += 1) {
                if(board.get(row, col: col) == nil) {
                    b = b + " ";
                }
                else {
                    b.append(board.get(row, col: col)!)
                }
            }
            print(b);
        }
    }
    
    func position_words(board: Board, seeds: Array<Tile>, rack: Rack, dictionary: Dictionary) -> Word? {
        
        var highest: Word? = nil;
        var iterations: Int = 0;
        let startTime = NSDate();
        
        var words = dictionary.getNSWords();
       // words = dictionary.getNSWord("ad"); //XXX
        let board_distribution = board.get_distribution()
        let rack_distribution = rack.get_distribution()
        
        log_console("info", message: "letters " + rack.get_letters().debugDescription);
        log_console("info", message: "seeds " + String(seeds.count));
        log_console("info", message: "words " + String(words.count));
        log_console("info", message: "starting board: ");
        let interval: Int = 1;
        var interval_count: Int = 0;
        var skip_seed: Int = 0;
        debug_board(board)
        let rack_letters = rack.get_letters()
        for word in words {
            
            // update the display...
            interval_count += 1;
            if(interval_count >= interval) {
                interval_count = 0;
                self.banner!.set_info(word , best: highest?.debugDescription, iterations: String(iterations), time_elapsed: NSDate().timeIntervalSinceDate(startTime))
            }
            
            // does the word contain one of the rack tiles
            var found: Bool = false;
            for letter in rack_letters {
                if(word.containsString(String(letter))) {
                    found = true;
                    break;
                }
            }
            if(!found) {
                continue
            }
            
            // can we make the word from all the letters
            if(!board_distribution.can_make(word)) {
                continue
            }
            
            // does the word fit on the board
            if(word.length > 15) {
                continue
            }
            
            // for each seed position the tiles in each direction...
            for seed in seeds {
                
                let row = seed.row;
                let col = seed.col;
                
                // going right...
                
                // we can rule out a seed boxed in left and right as it will be covered already...
                if(seed.left == nil || !seed.left!.yellow || seed.right == nil || !seed.right!.yellow) {
                    
                    var start_col = col - word.length + 1;  // if row is 4 and word length is 3 chars then start_row should be 2
                    if(start_col < 0) { start_col = 0; }
                    
                    var end_col = col;  // if col is 12 and word length is 6 chars then end_col should be 9
                    if((col + word.length - 1) > 14) { end_col = 14 - word.length + 1 }
                    
                    for(var i=start_col; i<=col; i++) {
                        
                        let w = place_word(board, row: row, col: i, word: word as String, distribution: rack_distribution, direction: "right");
                        if (w != nil) {
                            // score and check if its the highest
                            w?.score = score(w!);
                            if (w!.score > 0 && (highest == nil || w!.score > highest!.score)) {
                                highest = w!;
                            }
                        }
                        // reset
                        board.reset_letters();
                        iterations += 1;
                    }
                }
                
                // we must now check all tiles above and below the seed tiles if they are blank
                if(seed.up != nil && seed.up?.letter == nil) {
                    let w = place_word(board, seed: seed.up!, word: word as String, distribution: rack_distribution, direction: "right");
                    if (w != nil) {
                        // score and check if its the highest
                        w?.score = score(w!);
                        if (w!.score > 0 && (highest == nil || w!.score > highest!.score)) {
                            highest = w!;
                        }
                    }
                    // reset
                    board.reset_letters();
                    iterations += 1;
                }
                if(seed.down != nil && seed.down?.letter == nil) {
                    let w = place_word(board, seed: seed.down!, word: word as String, distribution: rack_distribution, direction: "right");
                    if (w != nil) {
                        // score and check if its the highest
                        w?.score = score(w!);
                        if (w!.score > 0 && (highest == nil || w!.score > highest!.score)) {
                            highest = w!;
                        }
                    }
                    // reset
                    board.reset_letters();
                    iterations += 1;
                }
                
                
                // going down...
                
                // we can rule out a seed boxed in top and bottom as it will be covered already...
                if(seed.up == nil || !seed.up!.yellow || seed.down == nil || !seed.down!.yellow) {
                    
                    var start_row = row - word.length + 1;  // if row is 4 and word length is 3 chars then start_row should be 2
                    if(start_row < 0) { start_row = 0; }
                    
                    var end_row = row;  // if row is 12 and word length is 6 chars then end_row should be 9
                    if((row + word.length - 1) > 14) { end_row = 14 - word.length + 1 }
                    
                    for(var i=start_row; i<=end_row; i++) {
                        
                        let w = place_word(board, row: i, col: col, word: word as String, distribution: rack_distribution, direction: "right");
                        if (w != nil) {
                            // score and check if its the highest
                            w?.score = score(w!);
                            if (w!.score > 0 && (highest == nil || w!.score > highest!.score)) {
                                highest = w!;
                            }
                        }
                        // reset
                        board.reset_letters();
                        iterations += 1;
                    }
                }
                
                // we must now check all tiles above and below the seed tiles if they are blank
                if(seed.left != nil && seed.left?.letter == nil) {
                    let w = place_word(board, seed: seed.left!, word: word as String, distribution: rack_distribution, direction: "down");
                    if (w != nil) {
                        // score and check if its the highest
                        w?.score = score(w!);
                        if (w!.score > 0 && (highest == nil || w!.score > highest!.score)) {
                            highest = w!;
                        }
                    }
                    // reset
                    board.reset_letters();
                    iterations += 1;
                }
                if(seed.right != nil && seed.right?.letter == nil) {
                    let w = place_word(board, seed: seed.right!, word: word as String, distribution: rack_distribution, direction: "down");
                    if (w != nil) {
                        // score and check if its the highest
                        w?.score = score(w!);
                        if (w!.score > 0 && (highest == nil || w!.score > highest!.score)) {
                            highest = w!;
                        }
                    }
                    // reset
                    board.reset_letters();
                    iterations += 1;
                }
                
                
//                // get indexes of seed in word, iterate through those
//                var indexes = get_indexes_of(word, letter: String(seed.letter!));
//                
//                
//                // looking for a word going right (can rule out a seed boxed in left and right)...
//                if(seed.left == nil || !seed.left!.yellow || seed.right == nil || !seed.right!.yellow) {
//                    for index in indexes {
//                        if(index > col) { continue; } // head of the word won't fit on board
//                        if(col + word.length - index > 14) { continue; } // tail of the word won't fit on the board
//                    
//                        // fits on the board so place it...
//                        let w = place_word(board, row: row, col: col - index, word: word as String, distribution: rack_distribution, direction: "right");
//                        if (w != nil) {
//                            // score and check if its the highest
//                            w?.score = score(w!);
//                            if (highest == nil || w!.score > highest!.score) {
//                                highest = w!;
//                            }
//                        }
//                        // reset
//                        board.reset_letters();
//                        iterations += 1;
//                    
//                    }
//                    // now deal with the seed derivitives...
//                    // we've already tried all horitonzal possibilities but we can try the tiles left
//                    // and right if they are blank to add a word in the vertical direction
//                    //TODO
//                    
//                    
//                    //e.g. seed row 7, col 2
//                   // for(var i=0; i<
//                    
//                    
//                    
//                }
//                
//                
//                // looking for a word going down...
//                //TODO - can rule out a seed boxed in top and bottom!
//                if(seed.up == nil || !seed.up!.yellow || seed.down == nil || !seed.down!.yellow) {
//                    for index in indexes {
//                        if(index > row) { continue; } // head of the word won't fit on board
//                        if(row + word.length - index > 14) { continue; } // tail of the word won't fit on the board
//                    
//                        // fits on the board so place it...
//                        let w = place_word(board, row: row - index, col: col, word: word as String, distribution: rack_distribution, direction: "down");
//                        if (w != nil) {
//                            // score and check if its the highest
//                            w?.score = score(w!);
//                            if (highest == nil || w!.score > highest!.score) {
//                                highest = w!;
//                            }
//                        }
//                        // reset
//                        board.reset_letters();
//                        iterations += 1;
//                    
//                    }
//                    // now deal with the seed derivitives...
//                    // we've already tried all vertical possibilities but we can try the tiles up
//                    // and down if they are blank to add a word in the horizontal direction
//                    //TODO
//                    
//                    
//                    
//                }
            }
        }
        
        if (highest != nil) {
            log_console("info", message: "overall highest: " + (highest?.debugDescription)! + " (tried " + String(iterations) + " iterations)");
            
            place_word(board, row: highest!.row, col: highest!.col, word: highest!.word, distribution: rack_distribution, direction: (highest?.direction)!);
            self.banner!.set_info("completed search and found a word!", best: highest?.debugDescription, iterations: String(iterations), time_elapsed: NSDate().timeIntervalSinceDate(startTime))
        } else {
            self.banner!.set_info("completed search but found no words", best: "", iterations: String(iterations), time_elapsed: NSDate().timeIntervalSinceDate(startTime))
            log_console("info", message: "failed to find a way to position the letters (tried " + String(iterations) + " iterations)");
        }
        
        return highest
    }
    
    
    func place_word(board: Board, row: Int, col: Int, word: String, distribution: Distribution, direction: String) -> Word? {
        return place_word(board, seed: board.get_tile(row, col: col), word: word, distribution: distribution, direction: direction);
    }
    
    func place_word(board: Board, seed: Tile?, word: String, distribution: Distribution, direction: String) -> Word? {
        return nil;
   //     log_console("debug", message: "trying to place word " + word + " going " + direction + " from (" + String(row) + "," + String(col) + ")");
    
        var tile: Tile? = seed;
        let w: Word = Word(word: word, row: tile!.row, col: tile!.col, direction: direction, tiles: Array<Tile>())
        distribution.reset()
        
        if (direction == "down") {
            
            for c in word.characters {
                if(tile != nil) {
                    tile!.used = true;
                    w.tiles.append(tile!)
                    
                    if (tile!.yellow) {
                        // already a tile here, check its the letter we need
                        if (!(tile!.letter == c)) {
                            return nil;
                        }
                    } else {
                        
                        // check we have this letter available and mark it used
                        if (distribution.use(c)) {
                            tile!.letter = c;
                        } else {
                            return nil;
                        }
                    }
                }
                else {
                    // ran out of tiles, unexpected as the space is already calculated
                    return nil
                }
                
                // move to the next tile
                tile = tile!.down
            }
        } else {
            for c in word.characters {
                if(tile != nil) {
                    tile!.used = true;
                    w.tiles.append(tile!)
                    
                    if (tile!.yellow) {
                        // already a tile here, check its the letter we need
                        if (!(tile!.letter == c)) {
                            return nil;
                        }
                    } else {
                        
                        // check we have this letter available and mark it used
                        if (distribution.use(c)) {
                            tile!.letter = c;
                        } else {
                            return nil;
                        }
                    }
                }
                else {
                    // ran out of tiles, unexpected as the space is already calculated
                    return nil
                }
                
                // move to the next tile
                tile = tile!.right
            }
        }
        
        if (w.tiles.count > 0 && distribution.used() > 0) {
            return w;
        } else {
            return nil;
        }
    }
    
    // returns an array of the words made by the new word, or nil if the
    // result is illegal
    func find_words(word: Word) -> Array<Word>? {
        
        // all words are right or down
        var words = Array<Word>();
        
        // add the newly created words perpendicular to the made word...
        for tile in word.tiles {
            
            if(tile.used && !tile.yellow) {
                
                if(word.direction == "down") {
                    
                    let w: Word? = find_word(tile, direction: "right");
                    if(w != nil && w?.word.characters.count > 1) {
                        if(dictionary.isValid(w!.word)) { //XXX dont count single character words!
                            words.append(w!);
                        }
                        else {
                            return nil;
                        }
                    }
                }
                else {
                    
                    let w: Word? = find_word(tile, direction: "down");
                    if(w != nil && w?.word.characters.count > 1) {
                        if(dictionary.isValid(w!.word)) {
                            words.append(w!);
                        }
                        else {
                            return nil;
                        }
                    }
                }
            }
        }
        
        // its only possible to make one word in the same direction as the passed word...
        
        let w: Word? = find_word(word.tiles[0], direction: word.direction);
        if(w != nil && w?.word.characters.count > 1) {
            if(dictionary.isValid(w!.word)) {
                words.append(w!);
            }
            else {
                return nil;
            }
        }
        
        return words;
    }
    
    func find_word(tile: Tile, direction: String) -> Word? {
        
        if(direction == "down") {
            
            // keep peeking up to find the start of the word
            var start_tile = tile;
            while(start_tile.up != nil && (start_tile.up!.used || start_tile.up!.yellow)) {
                start_tile = start_tile.up!
            }
            
            // read the word by going down
            var word: String = "";
            var tiles = Array<Tile>();
            var current_tile: Tile? = start_tile
            while(current_tile != nil && (current_tile!.used || current_tile!.yellow)) {
                word.append(current_tile!.letter!);
                tiles.append(current_tile!);
                
                current_tile = current_tile!.down
            }
            
            if(tiles.count > 0) {
                return Word(word: word, row: start_tile.row, col: start_tile.col, direction: "down", tiles: tiles);
            }
        }
        else {
            // keep peeking left to find the start of the word
            var start_tile = tile;
            while(start_tile.left != nil && (start_tile.left!.used || start_tile.left!.yellow)) {
                start_tile = start_tile.left!
            }
            
            // read the word by going right
            var word = "";
            var tiles = Array<Tile>();
            var current_tile: Tile? = start_tile
            while(current_tile != nil && (current_tile!.used || current_tile!.yellow)) {
                word.append(current_tile!.letter!);
                tiles.append(current_tile!);
                
                current_tile = current_tile!.right
            }
            
            if(tiles.count > 0) {
                return Word(word: word, row: start_tile.row, col: start_tile.col, direction: "right", tiles: tiles);
            }
        }
        
        // there was no word created in the direction given, just the tile itself
        return nil;
    }
    
    func score(word: Word) -> Int {
        
        var result = 0;
        let words = find_words(word);
//        log_console("debug", message: "found a total of " + String(words.count) + " words");

        if(words != nil) {
            for word in words! {
                let s = score_word(word);
                result += s;
            }
        }
        
        return result;
    }
    
    func score_word(word: Word) -> Int {
        
        var dw = 0;
        var tw = 0;
        var result: Int = 0;
        for tile in word.tiles {
            let letter_score = get_letter_score(String(tile.letter!));
            if (tile.yellow) {
                result += letter_score;
            } else {
                if (tile.feature == "DL") {
                    result += (letter_score * 2);
                } else if (tile.feature == "TL") {
                    result += (letter_score * 3);
                } else {
                    result += letter_score;
                }
                
                if (tile.feature == "DW") {
                    dw += 1;
                }
                if (tile.feature == "TW") {
                    tw += 1;
                }
            }
        }
        
        if (dw > 0) {
            result = result * 2 * dw;
        }
        if (tw > 0) {
            result = result * 3 * tw;
        }
        
        return result;
    }
    
    func get_letter_score(letter: String) -> Int {
        return letter_values[letter]!;
    }
    
    func get_indexes_of(word: String, letter: Character) -> Array<Int> {
    
        var indexes: Array<Int> = Array<Int>();
        for (var i=0; i<word.characters.count; i++) {
            if(word[word.startIndex.advancedBy(i)] == letter) {
                indexes.append(i);
            }
        }
        
        return indexes;
    }
    
    func get_indexes_of(word: NSString, letter: String) -> Array<Int> {
        
        var indexes: Array<Int> = Array<Int>();
        var range: NSRange = word.rangeOfString(letter);
        while range.location != NSNotFound {
            indexes.append(range.location)
            range = word.rangeOfString(letter, options: NSStringCompareOptions.LiteralSearch, range: NSRange(location: range.location+1, length: (word.length - (range.location+1))));
        }
        
        return indexes;
    }
}
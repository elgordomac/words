//
//  Letters.swift
//  Words
//
//  Created by Gordon MacDonald on 3/2/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import Foundation

class Distribution {
    
    struct Letter {
        var initial: Int
        var available: Int
    }
    
    var distributionLetters: [Character: Letter];
    var used_count: Int = 0;
    
    init() {
        distributionLetters = [Character: Letter]()
    }
    
    func zero() {
        
        for letter in distributionLetters.keys {
            distributionLetters[letter]?.initial = 0
            distributionLetters[letter]?.available = 0
        }
    }
    
    func reset() {
        for letter in distributionLetters.keys {
            distributionLetters[letter]?.available = (distributionLetters[letter]?.initial)!
        }
        used_count = 0;
    }
    
    func add(letters: Array<Character>) {
        for (var i = 0; i < letters.count; i++) {
            let c = letters[i];
            add(c)
        }
    }
    
    func add(character: Character) {
        let str = distributionLetters[character]
        if(str == nil) {
            distributionLetters[character] = Letter(initial: 0, available: 0)
        }
        distributionLetters[character]?.initial = (distributionLetters[character]?.initial)! + 1
    }
    
    func add(distribution: Distribution) {
        for letter in distribution.distributionLetters.keys {
            add(letter)
        }
    }
    
    func setup(letters: Array<Character>) {
        zero()
        add(letters)
        reset()
    }
    
    func use(c: Character) -> Bool {
        var letter = distributionLetters[c];
        if(letter != nil && letter!.available > 0) {
            letter!.available = (letter?.available)! - 1;
            used_count += 1;
            return true
        }
        return false;
    }
    
    func can_make(word: String) -> Bool {
        reset()
        for letter in word.characters {
            if(!use(letter)) {
                return false;
            }
        }
        
        return true;
    }
    
    func can_make(nsword: NSString) -> Bool {
        reset()
        var word = String(nsword)
        for letter in word.characters {
            if(!use(letter)) {
                return false;
            }
        }
        
        return true;
    }
    
    func used() -> Int {
        return self.used_count;
    }
    
    var debugDescription: String {
        
        for letter in distributionLetters.keys {
            print(letter.debugDescription + " (" + distributionLetters[letter].debugDescription + ")")
        }
        return "";
    }
}
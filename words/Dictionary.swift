//
//  Dictionary.swift
//  scrabble
//
//  Created by Gordon MacDonald on 1/10/16.
//  Copyright © 2016 Gordon MacDonald. All rights reserved.
//

import Foundation

class Dictionary {
    
    var words : Array<String> = Array<String>()
    var nswords : Array<NSString> = Array<NSString>()
    var words_set : Set<String> = Set<String>()
    var nswords_set : Set<NSString> = Set<NSString>()
    
    init() {
        
        let file = NSBundle.mainBundle().URLForResource("dictionary", withExtension: "txt")!
        let contents = try! String(contentsOfURL: file, encoding: NSUTF8StringEncoding)
        let lines: [String] = contents.componentsSeparatedByString("\n")
        
        for line in lines {
            words_set.insert(line);
            nswords_set.insert(NSString(string: line));
            words.append(line);
            nswords.append(NSString(string: line));
        }
        
    }
    
    func isValid(word: String) -> Bool {
        return words_set.contains(word);
    }
    
    func isValid(nsword: NSString) -> Bool {
        return nswords_set.contains(nsword);
    }
    
    func getWords() -> Array<String> {
        return words
    }
    
    func getNSWords() -> Array<NSString> {
        return nswords
    }
    
    func setWords(words : Set<String>) {
        self.words_set = words;
        self.words = words.sort();
    }
}
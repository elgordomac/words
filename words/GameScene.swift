//
//  GameScene.swift
//  words
//
//  Created by Gordon MacDonald on 1/30/16.
//  Copyright (c) 2016 Gordon MacDonald. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    let TileWidth: CGFloat = 25.0
    let TileHeight: CGFloat = 25.0
    let NumRows: Int = 15;
    let NumColumns: Int = 15;
    
    let gameLayer = SKNode()
    let cookiesLayer = SKNode()
    let alphabet = SKNode()
    var status_image: SKSpriteNode?
    var movingSprite: SKSpriteNode?
    var movingRow: Int?
    var movingColumn: Int?
    var movingLetter: Character?
    var movingRackPosition: Int?
    var scrabble: Scrabble = Scrabble()
    var board: Board;
    var rack: Rack;
    var banner: Banner;
    var angels: AVAudioPlayer!
    var alph: Alphabet?
    var running: Bool = false;
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        self.board = Board();
        self.rack = Rack();
        self.banner = Banner(parent: gameLayer);
        
        super.init(size: size)
        
        self.angels = setupAudioPlayerWithFile("clear_tombstone_01", type: "caf")

        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: 64 + (-TileHeight * CGFloat(NumRows) / 2))
        
        cookiesLayer.position = layerPosition
        alphabet.position = CGPoint(x: 0, y: -200)
        gameLayer.addChild(cookiesLayer)
        gameLayer.addChild(alphabet)
        showAlphabet()
        
        var loadButton = SKLabelNode(fontNamed: "Chalkduster")
        loadButton.text = "Load"
        loadButton.fontColor = SKColor.blackColor()
        loadButton.position = CGPoint(x: -140, y: -315)
        loadButton.name = "load"
        loadButton.fontSize = 24
        gameLayer.addChild(loadButton)
        
        var saveButton = SKLabelNode(fontNamed: "Chalkduster")
        saveButton.text = "Save"
        saveButton.fontColor = SKColor.blackColor()
        saveButton.position = CGPoint(x: -45, y: -315)
        saveButton.name = "save"
        saveButton.fontSize = 24
        gameLayer.addChild(saveButton)
        
        var goButton = SKLabelNode(fontNamed: "Chalkduster")
        goButton.text = "GO!"
        goButton.fontColor = SKColor.blackColor()
        goButton.position = CGPoint(x: 45, y: -315)
        goButton.name = "go"
        goButton.fontSize = 24
        gameLayer.addChild(goButton)
        
        var resetButton = SKLabelNode(fontNamed: "Chalkduster")
        resetButton.text = "Reset"
        resetButton.fontColor = SKColor.blackColor()
        resetButton.position = CGPoint(x: 140, y: -315)
        resetButton.name = "reset"
        resetButton.fontSize = 24
        gameLayer.addChild(resetButton)
        
    }
    
    func setuptest1() {
        board.set_row(0,  letters: "               ");
        board.set_row(1,  letters: "               ");
        board.set_row(2,  letters: "               ");
        board.set_row(3,  letters: "               ");
        board.set_row(4,  letters: "               ");
        board.set_row(5,  letters: "       d       ");
        board.set_row(6,  letters: "       abs     ");
        board.set_row(7,  letters: "       d       ");
        board.set_row(8,  letters: "               ");
        board.set_row(9,  letters: "               ");
        board.set_row(10, letters: "               ");
        board.set_row(11, letters: "               ");
        board.set_row(12, letters: "               ");
        board.set_row(13, letters: "               ");
        board.set_row(14, letters: "               ");
        
        rack.set("dykwqzo")
        
        board.commit(cookiesLayer)
        rack.commit(cookiesLayer)
    }
    
    func setuptest2() {
        board.set_row(0,  letters: "               ");
        board.set_row(1,  letters: "               ");
        board.set_row(2,  letters: "               ");
        board.set_row(3,  letters: "       d       ");
        board.set_row(4,  letters: "      bid      ");
        board.set_row(5,  letters: "     visit     ");
        board.set_row(6,  letters: "      ten      ");
        board.set_row(7,  letters: "       aga     ");
        board.set_row(8,  letters: "       s       ");
        board.set_row(9,  letters: " a   zee       ");
        board.set_row(10, letters: " h s e doth    ");
        board.set_row(11, letters: "woolen   ion   ");
        board.set_row(12, letters: " y u     k     ");
        board.set_row(13, letters: "   s     i fa  ");
        board.set_row(14, letters: "   haj   scan  ");
        
        rack.set("derbpeh")
        
        board.commit(cookiesLayer)
        rack.commit(cookiesLayer)
    }
    
    func setuptest3() {
        board.set_row(0,  letters: "   p       jill");
        board.set_row(1,  letters: "dozens  vigas i");
        board.set_row(2,  letters: "i  a t    om  n");
        board.set_row(3,  letters: "v  c e t  os  i");
        board.set_row(4,  letters: "a  e aura s   e");
        board.set_row(5,  letters: "s    m edged  r");
        board.set_row(6,  letters: "       n i     ");
        board.set_row(7,  letters: "       carps   ");
        board.set_row(8,  letters: "    hath t q  d");
        board.set_row(9,  letters: "     t   h u no");
        board.set_row(10, letters: "  beetle   i or");
        board.set_row(11, letters: "     i     bonk");
        board.set_row(12, letters: "     r       e ");
        board.set_row(13, letters: "     e         ");
        board.set_row(14, letters: "               ");
        
        rack.set("lwwteyy")
        
        board.commit(cookiesLayer)
        rack.commit(cookiesLayer)
    }
    
    func go() {
        running = true
        self.set_status("thinking")
        angels.play()
        // tidy up from any previous run
        self.board.commit(self.cookiesLayer)
        self.scrabble.dictionary = Dictionary()
        
        print(board.debugDescription);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { ()
        
            var ww: String = "";
            for tile in self.rack.rack {
                if(tile.letter != nil) {
                    ww.append(tile.letter!)
                }
            }
            
            let word: Word? = self.scrabble.run(self.board, rack: self.rack, banner: self.banner);
            
            dispatch_async(dispatch_get_main_queue()) {
                if(word != nil) {
                    self.preview_word(word!)
                    self.set_status("success")                    
                    self.angels.play()
                }
                else {
                    self.set_status("failure")
                }
                self.running = false
            }
        }
    }
    
    func reset() {
        print("resetting board and rack")
        board.reset()
        rack.reset()
    }
    
    func load() {
        print("loading board and rack")
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var loaded_rack = defaults.objectForKey("rack");
        var loaded_board = defaults.objectForKey("board");
        if(loaded_rack != nil && loaded_board != nil) {
            rack.deserialize(loaded_rack as! String)
            board.deserialize(loaded_board as! String)
            
            board.commit(cookiesLayer)
            rack.commit(cookiesLayer)
        }
        else {
            setuptest3()
        }
    }
    
    func save() {
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        print("saving board and rack")
        defaults.setObject(rack.serialize(), forKey: "rack")
        defaults.setObject(board.serialize(), forKey: "board")
        
        defaults.synchronize()
        
        
//        board.set_row(0,  letters: "   p       j   ");
//        board.set_row(1,  letters: "dozens  vigas  ");
//        board.set_row(2,  letters: "i  a t    om   ");
//        board.set_row(3,  letters: "v  c e t  os   ");
//        board.set_row(4,  letters: "a  e aura s    ");
//        board.set_row(5,  letters: "s    m edged   ");
//        board.set_row(6,  letters: "       n       ");
//        board.set_row(7,  letters: "       carps   ");
//        board.set_row(8,  letters: "       h   q   ");
//        board.set_row(9,  letters: "           u   ");
//        board.set_row(10, letters: "           i   ");
//        board.set_row(11, letters: "           b   ");
//        board.set_row(12, letters: "               ");
//        board.set_row(13, letters: "               ");
//        board.set_row(14, letters: "               ");
//        
//        rack.set("rrkdnlo")
        
        board.commit(cookiesLayer)
        rack.commit(cookiesLayer)
        
    }
    
    func setupAudioPlayerWithFile(file: String, type: String) -> AVAudioPlayer? {
        
        if let url = NSBundle.mainBundle().URLForResource(file, withExtension: type) {
            do {
                return try AVAudioPlayer(contentsOfURL: url)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func showAlphabet() {
        alph = Alphabet(alphabet: alphabet);
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(14-row)*TileHeight + TileHeight/2)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        var location = touch.locationInNode(cookiesLayer)
        
        print("begin " + location.x.description + "," + location.y.description);
        let (isBoard, column, row) = findBoardTile(location)
        print("found board tile location" + isBoard.description + " at " + row.description + " " + column.description)
        if isBoard {
            
            let tile = board.get_tile(row, col: column)
            print("found tile with letter " + tile.letter.debugDescription)
            if tile.letter != nil {
                movingRow = row
                movingColumn = column
                movingSprite = tile.sprite
                movingLetter = tile.letter
                tile.letter = nil;
                tile.sprite = nil;
                tile.yellow = false;
            }
        }
        else {
            location = touch.locationInNode(alphabet)
            let letter: Character? = self.alph?.get_letter(location)
            if letter != nil {
            
                let sprite = SKSpriteNode(imageNamed: String(letter!))
                sprite.position = touch.locationInNode(cookiesLayer)
                cookiesLayer.addChild(sprite)
                movingLetter = letter;
                movingSprite = sprite;
            }
            else {
                let location = touch.locationInNode(cookiesLayer)
                let (isRack, position, tile) = findRackTile(location)
                if isRack {
                    
                    movingLetter = tile!.letter;
                    movingSprite = tile!.sprite;
                    movingRackPosition = position;
                    tile!.letter = nil;
                    tile!.sprite = nil;
                }
                
            }
        }
        location = touch.locationInNode(gameLayer)
        let node = gameLayer.nodeAtPoint(location) //1
        if (node.name == "go" && running == false) { //2
            go()
        }
        else if(node.name == "reset" && running == false) {
            reset();
        }
        else if(node.name == "load" && running == false) {
            load();
        }
        else if(node.name == "save" && running == false) {
            save();
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(cookiesLayer)
            
        if self.movingSprite != nil {
            self.movingSprite!.position = location
            //print("touch " + location.x.description + "," + location.y.description);
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(cookiesLayer)
        print("ended " + location.x.description + "," + location.y.description);

        if(movingLetter != nil) {
            let (onboard, column, row) = findBoardTile(location)
            if onboard {
                
                let tile = board.get_tile(row, col: column)
                
                if tile.letter != nil {
                    
                    if(movingRow != nil && movingColumn != nil) {
                        //XXX send back to source, maybe animate
                        var source = board.get_tile(movingRow!, col: movingColumn!)
                        source.letter = movingLetter!
                        source.sprite = movingSprite
                        source.yellow = true
                        self.movingSprite?.position = pointForColumn(movingColumn!, row: movingRow!)
                        
                    }
                    else if(movingRackPosition != nil) {
                        //XXX animate?
                        self.movingSprite?.position = CGPoint(
                        x: 100 + (CGFloat(movingRackPosition!)*TileWidth) + TileWidth/2,
                        y: -30)
                        rack.get(movingRackPosition!).letter = movingLetter!
                        rack.get(movingRackPosition!).sprite = movingSprite
                    }
                    else {
                        // came from alphabet, just destroy it...
                        self.movingSprite?.removeFromParent()
                    }
                }
                else {
                    // move cookie to new board location
                    tile.letter = movingLetter!
                    tile.sprite = movingSprite
                    tile.yellow = true
                    self.movingSprite?.position = pointForColumn(column, row: row)
                }
            }
            else {
                let (onrack, position, tile) = findRackTile(location)
                if onrack {
                    if(self.rack.get(position).letter != nil) {
                        if(movingRow != nil && movingColumn != nil) {
                            //XXX send back to source, maybe animate
                            var source = board.get_tile(movingRow!, col: movingColumn!)
                            source.letter = movingLetter!
                            source.sprite = movingSprite
                            source.yellow = true
                            self.movingSprite?.position = pointForColumn(movingColumn!, row: movingRow!)
                            
                        }
                        else if(movingRackPosition != nil) {
                            //XXX animate?
                            self.movingSprite?.position = CGPoint(
                                x: 100 + (CGFloat(movingRackPosition!)*TileWidth) + TileWidth/2,
                                y: -30)
                            rack.get(movingRackPosition!).letter = movingLetter!
                            rack.get(movingRackPosition!).sprite = movingSprite
                        }
                        else {
                            // came from alphabet, just destroy it...
                            self.movingSprite?.removeFromParent()
                        }
                    }
                    else {
                        self.movingSprite?.position = CGPoint(
                            x: 100 + (CGFloat(position)*TileWidth) + TileWidth/2,
                            y: -30)
                        rack.get(position).letter = movingLetter!
                        rack.get(position).sprite = movingSprite
                    }
                }
                else {
                    self.movingSprite?.removeFromParent()
                }
            }
        }
        
        self.movingRow = nil
        self.movingColumn = nil
        self.movingLetter = nil
        self.movingSprite = nil
        print(board.debugDescription)
        
        var r: String = String()
        for (var i = 0; i < 7; i++) {
            if(rack.get(i).letter != nil) {
                r.append(self.rack.get(i).letter!)
            }
            else {
                r.append(Character("_"))
            }
        }
        print(r)
    }
    
    func findBoardTile(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
                print("closest drop is " + String(Int(point.x / TileWidth)) + "," + String(Int(15 - point.y / TileHeight)))
                return (true, Int(point.x / TileWidth), Int(15 - point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    func findRackTile(point: CGPoint) -> (success: Bool, position: Int, tile: Tile?) {
        
        if point.x >= 100 && point.x < 275 && point.y <= -25 && point.y > -50 {
            var p: Int = Int((point.x - 100)/TileWidth);
            var t: Tile? = self.rack.get(p);
            if(t != nil) {
                return (true, p, t)
            }
        }
        
        return (false, 0, nil)  // invalid location
    }
    
    func snapToGrid() {
        if self.movingSprite != nil {
            
        }
    }
    
    func set_status(status: String?) {
        banner.set_status(status!)
    }
    
    func preview_word(word: Word) {
        for tile in word.tiles {
            if(!tile.yellow) {
                let sprite = SKSpriteNode(imageNamed: String(tile.letter!))
                sprite.position = self.pointForColumn(tile.col, row: tile.row)
                sprite.alpha = 0.5
                self.cookiesLayer.addChild(sprite)
                tile.sprite = sprite
            }
        }
    }
}
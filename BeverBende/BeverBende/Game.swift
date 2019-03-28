//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

class Game {
    public var drawPile: Deck
    public var playerDeck: Deck
    public var actrDeck1: Deck
    public var actrDeck2: Deck
    public var actrDeck3: Deck
    public var discardPile: Deck
    public var modelPlayer1: ModelPlayer
    public var modelPlayer2: ModelPlayer
    public var modelPlayer3: ModelPlayer
    public var isFinished: Bool = false
    
    public func cardsInit() {
        drawPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: true)
        drawPile.makeCardsClickable(fourCards: false, setTrueOrFalse: true)
        if discardPile.cards.isEmpty {
            discardPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: true)
            discardPile.makeCardsClickable(fourCards: false, setTrueOrFalse: true)
        }
    }
    
    public func ACTRModelActions(model: ModelPlayer, deck: Deck) {
        model.run()
        model.modifyLastAction(slot: "isa", value: "start-info")
        model.modifyLastAction(slot: "left", value: String(deck.returnCardAtPos(position: 0)))
        model.modifyLastAction(slot: "right", value: String(deck.returnCardAtPos(position: 3)))
        //Start turn
        model.run()
        model.run()
        
        let max_tuple = max(model: model)
        print(max_tuple)
        let max_val = max_tuple.0
        let max_pos = max_tuple.1
        model.modifyLastAction(slot: "isa", value: "compare-cards")
        model.modifyLastAction(slot: "max", value: String(max_val))
        model.modifyLastAction(slot: "max-pos", value: String(max_pos))
        let min_tuple = min(model: model)
        let min_val = min_tuple.0
        let min_pos = min_tuple.1
        print(min_tuple)
        model.modifyLastAction(slot: "min", value: String(min_val))
        model.modifyLastAction(slot: "min-pos", value: String(min_pos))
        print(model.buffers)
        model.run()
        
        model.modifyLastAction(slot: "isa", value: "moves")
        model.buffers["actions"]?.slotvals["discard"] = nil
        model.modifyLastAction(slot: "draw", value: String(drawPile.returnCardAtPos(position: drawPile.cards.endIndex-1)))
        print(model.buffers)
        model.run()
        print(model.buffers)
        // TODO: ACT-R Model actions are performed here
    }
    
    public func cardActions(pos: Int, pileClicked: Int) {
        if pileClicked == 1 {
            // if the drawPile is clicked
            discardPile.appendCard(fromDeck: playerDeck, pos: pos)
            playerDeck.popAndInsertCard(fromDeck: drawPile, pos: pos)
        } else if pileClicked == 2 {
            // if the discardPile is clicked
            playerDeck.swapCardsAtPos(fromDeck: discardPile, pos: pos)
        }
    }
        
    private func max(model: ModelPlayer) -> (Double, Int) {
        var highest: Double = -1
        var highestpos: Int = 5
        let position = ["pos0","pos1","pos2","pos3"]
        var j = 0
        for i in position {
            let value = model.buffers["action"]?.slotvals[i]?.number()
            if value != nil {
                if value! > highest {
                    highest = value!
                    highestpos = j
                }
            }
            j += 1
        }
        return (highest,highestpos)
    }
        
    private func min(model: ModelPlayer) -> (Double, Int)  {
        var lowest: Double = 100
        var lowestpos: Int = 5
        let position = ["pos0","pos1","pos2","pos3"]
        var j = 0
        for i in position {
            let value = model.buffers["action"]?.slotvals[i]?.number()
            if value != nil {
                if value! < lowest {
                    lowest = value!
                    lowestpos = j
                }
            }
            j += 1
        }
        return(lowest,lowestpos)
    }
    
//    public func humanActions() {
//        if drawPile.isClickedPile {
//            //discardPile.addCard(card: playerDeck.isClickedCard()!)
//            print("drawPile is clicked!")
//            discardPile.addCard(card: playerDeck.isClickedCard()!)
//            // TODO: Add the card to the playerDeck and remove from drawpile
//        }
        // TODO: Draw card from discard pile and add card to playerdeck
        
//    }
    
    public func initGame() {
        playerDeck.showOuterCards()
    }
    
    public func hideCard() {
        playerDeck.hideOuterCards()
    }
        
    init() {
        self.drawPile = Deck(completeDeck: true)
        self.playerDeck = Deck(drawPile: drawPile)
        self.actrDeck1 = Deck(drawPile: drawPile)
        print(self.actrDeck1.cards)
        self.actrDeck2 = Deck(drawPile: drawPile)
        self.actrDeck3 = Deck(drawPile: drawPile)
        self.discardPile = Deck()
        self.modelPlayer1 = ModelPlayer(playerNumber: 1)
        self.modelPlayer2 = ModelPlayer(playerNumber: 2)
        self.modelPlayer3 = ModelPlayer(playerNumber: 3)
    }
}

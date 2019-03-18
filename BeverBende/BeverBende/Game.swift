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
    
    private func modifyActionInit(model: ModelPlayer, deck: Deck) {
        model.modifyLastAction(slot: "isa", value: "start-info")
        model.modifyLastAction(slot: "left", value: String(deck.returnCardAtPos(position: 0)))
        model.modifyLastAction(slot: "right", value: String(deck.returnCardAtPos(position: 3)))
        print(model.buffers)
        model.run()
//        print(model.buffers)
    }
    
    public func initGame() {
        playerDeck.showOuterCards()
        modelPlayer1.run()
        modifyActionInit(model: modelPlayer1, deck: actrDeck1)
        
//        modifyActionInit(model: modelPlayer2, deck: actrDeck2)
//        modifyActionInit(model: modelPlayer3, deck: actrDeck3)
        
        // THIS IS JUST FOR TESTING
        modelPlayer1.modifyLastAction(slot: "isa", value: "moves")
        modelPlayer1.modifyLastAction(slot: "discard", value: "nil")
        modelPlayer1.modifyLastAction(slot: "draw", value: String(drawPile.returnCardAtPos(position: drawPile.cards.endIndex-1)))
        print(modelPlayer1.buffers)
        modelPlayer1.run()
        print(modelPlayer1.buffers)
//        print(modelPlayer1.trace)
//        let tmp = modelPlayer1.lastAction(slot: "action")
//        print(tmp!)
        
        
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

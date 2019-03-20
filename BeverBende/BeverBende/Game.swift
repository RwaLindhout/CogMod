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
    
    private func ACTRModelActions(model: ModelPlayer, deck: Deck) {
        model.run()
        model.modifyLastAction(slot: "isa", value: "start-info")
        model.modifyLastAction(slot: "left", value: String(deck.returnCardAtPos(position: 0)))
        model.modifyLastAction(slot: "right", value: String(deck.returnCardAtPos(position: 3)))
        model.run()
        model.modifyLastAction(slot: "isa", value: "moves")
        model.modifyLastAction(slot: "discard", value: "nil")
        model.modifyLastAction(slot: "draw", value: String(drawPile.returnCardAtPos(position: drawPile.cards.endIndex-1)))
        model.run()
        print(model.buffers)
    }
    
    private func humanActions() {
        // First turn there is nothing on the discardPile
        if (discardPile.cards.isEmpty) {
            // highlight card in the drawPile and make it clickable
            
        }
    }
    
    public func initGame() {
        playerDeck.showOuterCards()
        startGame()
        // if start button is pressed then start the game
    }
    
    public func hideCard() {
        playerDeck.hideOuterCards()
    }
    
    private func startGame() {
        // First human turn, then {
        // while beverbende button is not pressed {
        ACTRModelActions(model: modelPlayer1, deck: actrDeck1)
        ACTRModelActions(model: modelPlayer2, deck: actrDeck2)
        ACTRModelActions(model: modelPlayer3, deck: actrDeck3)
        //} Now human turn {
        //
        // }
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

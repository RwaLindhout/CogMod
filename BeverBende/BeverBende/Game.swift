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
    
    public func ACTRInit() {
        if discardPile.cards.isEmpty {
            drawPile.makeLastCardHighlighted()
        } else {
            drawPile.makeLastCardHighlighted()
            discardPile.makeLastCardHighlighted()
        }
    }
    
    public func ACTRModelActions(model: ModelPlayer, deck: Deck) {
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
        
        // TODO: ACT-R Model actions are performed here
    }
    
    public func humanActions() {
        // First turn there is nothing on the discardPile so only
        // drawPile becomes clickable and highlighted
        if (discardPile.cards.isEmpty) {
            drawPile.makeLastCardClickableAndHighlighted()
        } else {
            // drawPile and discardPile become clickable and highlighted
            drawPile.makeLastCardClickableAndHighlighted()
            discardPile.makeLastCardClickableAndHighlighted()
        }
        playerDeck.makeCardsClickableAndHighlighted()
        if drawPile.isClickedPile {
            //discardPile.addCard(card: playerDeck.isClickedCard()!)
            // TODO: Add the card to the playerDeck and remove from drawpile
        }
        // TODO: Draw card from discard pile and add card to playerdeck
        
    }
    
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

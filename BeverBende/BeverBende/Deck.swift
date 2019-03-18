//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

class Deck {
    private(set) var cards = [Card]()
    
    // TODO: Create a complete deck with 52 cards
    public func createDeck() {
        for _ in 0..<6 {
            // TODO: add correct cards to the deck when initialized
            for i in 0..<10 {
                let card = Card(value: i)
                cards += [card]
            }
        }
        // Shuffles the entire deck
        cards.shuffle()
        // Last card in the drawPile should be faceUp
//        cards[cards.endIndex-1].isFaceUp = true
    }
    
    // Initialize a player deck
    private func createPlayerDeck(drawDeck: Deck) {
        for i in 0..<4 {
            drawCard(position: i, fromDeck: drawDeck)
        }
    }
    
    // Draws a card from one deck to another
    public func drawCard(position: Int, fromDeck: Deck) {
        let card = fromDeck.cards.popLast()
        self.cards.insert(card!, at:position)
    }
    
    public func isEmpty() -> Bool {
        return self.cards.isEmpty
    }
    
    public func showOuterCards() {
        self.cards[0].isFaceUp = true
        self.cards[3].isFaceUp = true
    }
    
    private func initFourCards() {
        for _ in 0..<4 {
            let card = Card(value: 5)
            cards += [card]
        }
    }
    
    public func returnCardAtPos(position: Int) -> Int {
        return cards[position].value
    }
    
    // Init a deck with all the cards
    init(completeDeck: Bool) {
        if completeDeck {
            createDeck()
        }
    }
    
    // Init a player deck
    init(drawPile: Deck) {
        createPlayerDeck(drawDeck: drawPile)
    }
    
    // Init four cards for representation of ACT-R Model
    init(playerModel: Bool) {
        if playerModel {
            initFourCards()
        }
    }
    
    // Init an empty deck
    init() {
    }
}

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
        cards[cards.endIndex-1].isFaceUp = true
    }
    
    // Initialize a player deck
    private func createPlayerDeck(drawDeck: Deck) {
        let playerDeck = Deck()
        for i in 0..<4 {
            drawCard(position: i, fromDeck: drawDeck, toDeck: playerDeck)
        }
    }
    
    // Draws a card from one deck to another
    public func drawCard(position: Int, fromDeck: Deck, toDeck: Deck) {
        let card = fromDeck.cards.popLast()
        toDeck.cards.insert(card!, at: position)
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
    
    // Init an empty deck
    init() {
        
    }
}

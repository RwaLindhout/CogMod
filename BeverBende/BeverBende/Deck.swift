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
    
    // TODO: initialize all cards
    init() {
        for _ in 0..<6 {
            for i in 0..<10 {
                // Initialize a card with a value ranging from 0 to 9
                let card = Card(isFaceUp: false, value: i, identifier: Card.getUniqueIdentifier())
                cards += [card]
                print(card.cardValue)
            }
        }
    }
}

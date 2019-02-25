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
    
    init() {
        for _ in 0..<6 {
            for i in 0..<10 {
                let card = Card(value: i)
                cards += [card]
                print(card.cardValue)
            }
        }
    }
}

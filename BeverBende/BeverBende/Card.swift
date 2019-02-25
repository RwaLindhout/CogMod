//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var value: Int
    private var identifier: Int
    
    var cardValue: Int {
        get {
            return value
        } set {
            value = newValue
        }
    }
    
    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return 0
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
        // self.value needs to be a random number
        self.value = Int(arc4random())
    }
}

extension Int {
    var arc4random: Int {
//        return Int(arc4random_uniform(UInt32(9)))
        return Int(arc4random_uniform(UInt32(9)))
    }
}

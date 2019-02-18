//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var value: Int
    var identifier: Int
    
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
}

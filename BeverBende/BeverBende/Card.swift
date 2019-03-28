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
    
    public var isFaceUp = true
    public var isHighlighted = false
    public var isClickable = false
    var value: Int
    private var identifier: Int
    public var isClicked = false
    
    static var identifierFactory = 0

    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return 0
    }
    
    public mutating func setValue(value: Int) {
        self.value = value
    }
    
//    mutating func setFaceUp(faceUp: Bool) {
//        self.isFaceUp = faceUp
//    }
    
    init(value: Int) {
        self.identifier = Card.getUniqueIdentifier()
        self.value = value
    }
}

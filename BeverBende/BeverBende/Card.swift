//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

struct Card: Hashable {
//    var hashValue: Int { return identifier }
//
//    static func ==(lhs: Card, rhs: Card) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
    
    public var isFaceUp = false
    public var isHighlighted = false
    public var isClickable = false
    public var isClicked = false
    public var value: Int
    public var type = ""
//    private var identifier: Int
//
//    static var identifierFactory = 0
//
//    static func getUniqueIdentifier() -> Int {
//        identifierFactory += 1
//        return 0
//    }
    
    public mutating func setValue(value: Int) {
        self.value = value
    }
    
//    mutating func setFaceUp(faceUp: Bool) {
//        self.isFaceUp = faceUp
//    }
    
    init(value: Int) {
//        self.identifier = Card.getUniqueIdentifier()
        self.value = value
    }
    
    init(value: Int, type: String) {
        self.value = value
        self.type = type
    }
}

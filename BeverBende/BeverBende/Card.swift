//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

struct Card: Hashable {
    public var isFaceUp = false
    public var isHighlighted = false
    public var isClickable = false
    public var isClicked = false
    public var value: Int
    public var type = ""
    
    public mutating func setValue(value: Int) {
        self.value = value
    }
    
    init(value: Int) {
        self.value = value
    }
    
    init(value: Int, type: String) {
        self.value = value
        self.type = type
    }
}

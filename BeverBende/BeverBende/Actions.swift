//
//  actions.swift
//  BeverBende
//
//  Created by Joppe Boekestijn on 28/03/2019.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

struct Actions {
    public var action: Int
    public var player: Int
    public var position: Int
    public var lower: Int
    public var upper: Int
    public var estimatedValue: Int
    
    init(action: Int, player: Int, position: Int, lower: Int, upper: Int, estimatedValue: Int) {
        self.action = action
        self.player = player
        self.position = position
        self.lower = lower
        self.upper = upper
        self.estimatedValue = estimatedValue
    }
}

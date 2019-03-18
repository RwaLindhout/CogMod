//
//  Player.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 18/03/2019.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

class ModelPlayer: Model {
    public var playerNumber: Int
    public var playerTurn: Bool
    public var humanPlayer: Deck
    public var otherPlayer2: Deck
    public var otherPlayer3: Deck
    public var loadedModel: String? = nil
    
    init(playerNumber: Int) {
        self.playerNumber = playerNumber
        self.playerTurn = false
        self.humanPlayer = Deck(playerModel: true)
        self.otherPlayer2 = Deck(playerModel: true)
        self.otherPlayer3 = Deck(playerModel: true)
    }
}

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
    public var actions = [Actions]()
    
    // Make a new action and add it to an array of actions
    public func addActions(action: Int, player: Int, position: Int, estimatedValue: Int) {
        let action = Actions(action: action, player: player, position: position, estimatedValue: estimatedValue)
        actions += [action]
        // todo: these actions should be sent to the actr model
    }
    
    init(playerNumber: Int) {
        self.playerNumber = playerNumber
        self.playerTurn = false
        self.humanPlayer = Deck(playerModel: true)
        self.otherPlayer2 = Deck(playerModel: true)
        self.otherPlayer3 = Deck(playerModel: true)
    }
}

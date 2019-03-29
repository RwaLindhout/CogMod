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
    public func addActions(actionNum: Int, player: Int, position: Int, estimatedValue: Int) {
        if actionNum == 2 {
            // todo: lower and upper to -1 actually should be set to nil
            let action = Actions(action: actionNum, player: player, position: position, lower: -1, upper: -1, estimatedValue: estimatedValue)
            actions += [action]
        } else {
            let action = Actions(action: actionNum, player: player, position: position, lower: 0, upper: estimatedValue * 2, estimatedValue: estimatedValue)
            actions += [action]
        }
        
        if player == 0 {
            humanPlayer.setCardValueAtPos(position: position, value: estimatedValue)
        } else if playerNumber == 1 {
            if player == 2 {
                otherPlayer2.setCardValueAtPos(position: position, value: estimatedValue)
            } else if player == 3 {
                otherPlayer3.setCardValueAtPos(position: position, value: estimatedValue)
            }
        } else if playerNumber == 2 {
            if player == 1 {
                otherPlayer2.setCardValueAtPos(position: position, value: estimatedValue)
            } else if player == 3 {
                otherPlayer3.setCardValueAtPos(position: position, value: estimatedValue)
            }
        } else if player == 3 {
            if player == 1 {
                otherPlayer2.setCardValueAtPos(position: position, value: estimatedValue)
            } else if player == 2 {
                otherPlayer3.setCardValueAtPos(position: position, value: estimatedValue)
            }
        }
        
        // if there are 4 actions in the array, remove the first one
        if actions.count == 4 {
            actions.removeFirst(1)
        }
        
        // todo: these actions should be sent to the ACTR model
    }
    
    init(playerNumber: Int) {
        self.playerNumber = playerNumber
        self.playerTurn = false
        self.humanPlayer = Deck(playerModel: true)
        self.otherPlayer2 = Deck(playerModel: true)
        self.otherPlayer3 = Deck(playerModel: true)
    }
}

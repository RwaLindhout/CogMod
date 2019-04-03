//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation

class Game {
    public var drawPile: Deck
    public var playerDeck: Deck
    public var actrDeck1: Deck
    public var actrDeck2: Deck
    public var actrDeck3: Deck
    public var discardPile: Deck
    public var modelPlayer1: ModelPlayer
    public var modelPlayer2: ModelPlayer
    public var modelPlayer3: ModelPlayer
    public var isFinished: Bool = false
    
    
    public func cardsInit(ACTR: Bool) {
        if ACTR {
            drawPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: false)
            drawPile.makeCardsClickable(fourCards: false, setTrueOrFalse: false)
            playerDeck.makeCardsClickable(fourCards: true, setTrueOrFalse: false)
            playerDeck.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
            if discardPile.cards.isEmpty {
                discardPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: false)
                discardPile.makeCardsClickable(fourCards: false, setTrueOrFalse: false)

            }
        } else {
            drawPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: true)
            drawPile.makeCardsClickable(fourCards: false, setTrueOrFalse: true)
            if discardPile.cards.isEmpty {
                discardPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: false)
                discardPile.makeCardsClickable(fourCards: false, setTrueOrFalse: false)
            } else {
                discardPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: true)
                discardPile.makeCardsClickable(fourCards: false, setTrueOrFalse: true)
            }
        }
    }
    // took-drawpile action = 1
    // nieuw geschatte waarde afgespeelde waarde op discardpile / 2
    
    // took-discard action = 2
    // dan weet je zeker welke waarde er ligt, want dat is waarde van discardPile kaart
    
    
    private func ACTRUpdateKnowledge(model: ModelPlayer, deck: Deck, action: Int, position: Int, value: Int) {
        let playerNumber = model.playerNumber
        if playerNumber == 1 {
            modelPlayer2.addActions(actionNum: action, player: 1, position: position, estimatedValue: value)
            modelPlayer3.addActions(actionNum: action, player: 1, position: position, estimatedValue: value)
        } else if playerNumber == 2 {
            modelPlayer1.addActions(actionNum: action, player: 2, position: position, estimatedValue: value)
            modelPlayer3.addActions(actionNum: action, player: 2, position: position, estimatedValue: value)
        } else if playerNumber == 3 {
            modelPlayer1.addActions(actionNum: action, player: 3, position: position, estimatedValue: value)
            modelPlayer2.addActions(actionNum: action, player: 3, position: position, estimatedValue: value)
        }
    }
    
    //Add human actions to the history of the models
    public func ACTRUpdateHumanKnowledge(action: Int, position: Int, value: Int) {
        modelPlayer1.addActions(actionNum: action, player: 0, position: position, estimatedValue: value)
        modelPlayer2.addActions(actionNum: action, player: 0, position: position, estimatedValue: value)
        modelPlayer3.addActions(actionNum: action, player: 0, position: position, estimatedValue: value)
    }
    
    public func initACTRModelActions(model: ModelPlayer, deck: Deck) {
        model.run()
        model.modifyLastAction(slot: "isa", value: "start-info")
        model.modifyLastAction(slot: "left", value: String(deck.returnCardAtPos(position: 0)))
        model.modifyLastAction(slot: "right", value: String(deck.returnCardAtPos(position: 3)))
        model.run()
        print(model.dm.chunks)
        print("test")
        model.dm.addToDM(model.dm.chunks["imaginal2"]!)
        model.dm.addToDM(model.dm.chunks["imaginal3"]!)
        //debug print
        print(model.buffers)
    }
    
    
    public func ACTRModelActions(model: ModelPlayer, deck: Deck) -> (Int, Int, Bool) {
        //Start by looking at previous moves mnade by opponents 
        print(model.playerNumber)
        for action in model.actions{
            print(action)
            print("position: \(action.position)")
            print("player: \(action.player)")
            print("estimated value: \(action.estimatedValue)")

            model.modifyLastAction(slot: "isa", value: "history")
            model.modifyLastAction(slot: "position", value: String(action.position))
            model.modifyLastAction(slot: "new-avg", value: String(action.estimatedValue))
            
            //Add action and limits to the chunks for the history
            if(action.action == 1){
                //Action  was took draw
                model.modifyLastAction(slot: "action", value: "took-draw")
                model.modifyLastAction(slot: "upper", value: String(action.upper))
                model.modifyLastAction(slot: "lower", value: String(action.lower))
            }else if(action.action == 2){
                //Action was took discard
                model.modifyLastAction(slot: "action", value: "took-discard")
                model.buffers["action"]?.slotvals["upper"] = nil
                model.buffers["action"]?.slotvals["lower"] = nil
            }
                
                
            //Make sure the player numbers used in Swift match up with those in ACT-R
            if(model.playerNumber == 1){
                if(action.player == 0 ){
                    //The human player is opponent 3 for model 1
                    model.modifyLastAction(slot: "player", value: "3")
                }else if(action.player == 1 ){
                    //The first model is the model itself, so a 0
                    model.modifyLastAction(slot: "player", value: "0")
                }else if(action.player == 2 ){
                    //The second model is opponent 1 for model 1
                    model.modifyLastAction(slot: "player", value: "1")
                }else if(action.player == 3 ){
                    //The third model is opponent 2 for model 1
                    model.modifyLastAction(slot: "player", value: "2")
                }
            } else  if(model.playerNumber == 2){
                if(action.player == 0 ){
                    //The human player is opponent 2 for model 2
                    model.modifyLastAction(slot: "player", value: "2")
                }else if(action.player == 1 ){
                    //The first model is opponent 3 for model 2
                    model.modifyLastAction(slot: "player", value: "3")
                }else if(action.player == 2 ){
                    //The second model is the model itself, so  a 0
                    model.modifyLastAction(slot: "player", value: "0")
                }else if(action.player == 3 ){
                    //The third model is opponent 1 for model 2
                    model.modifyLastAction(slot: "player", value: "1")
                }
            } else  if(model.playerNumber == 3){
                if(action.player == 0 ){
                    //The human player is opponent 1 for model 3
                    model.modifyLastAction(slot: "player", value: "1")
                }else if(action.player == 1 ){
                    //The first model is opponent 2 for model 3
                    model.modifyLastAction(slot: "player", value: "2")
                }else if(action.player == 2 ){
                    //The second model is opponent 3 for model 3
                    model.modifyLastAction(slot: "player", value: "3")
                }else if(action.player == 3 ){
                    //The third model is the model itself, so a 0.
                    model.modifyLastAction(slot: "player", value: "0")
                }
            }
            
            print(model.buffers)
            model.run()
        }
        //No more previous moves/history left to process so act-r can start turn
        model.modifyLastAction(slot: "isa", value: "history")
        model.modifyLastAction(slot: "action", value: "done")
        model.run()
        
       
        //Start turn
        model.run()
        print(model.buffers)
        //Get max and minimum value of the four cards of the model and return the highest and lowest to ACT-R
        let max_tuple = max(model: model)
        let max_val = max_tuple.0
        let max_pos = max_tuple.1
        model.modifyLastAction(slot: "isa", value: "compare-cards")
        model.modifyLastAction(slot: "max", value: String(max_val))
        model.modifyLastAction(slot: "max-pos", value: String(max_pos))
        let min_tuple = min(model: model)
        let min_val = min_tuple.0
        let min_pos = min_tuple.1
        model.modifyLastAction(slot: "min", value: String(min_val))
        model.modifyLastAction(slot: "min-pos", value: String(min_pos))
        //Get value of current hand according to model
        let total = sum(model:model)
        model.modifyLastAction(slot: "sum", value: String(total))
        
        print("sum cards: \(total)")
        print("sum cards opp1: \(model.otherPlayer2.sumCards())")
        print("sum cards opp2: \(model.otherPlayer3.sumCards())")
        print("sum cards human: \(model.humanPlayer.sumCards())")

        model.run()
        
        //Does the model wanna call beverbende?
        let my_score = model.buffers["action"]?.slotvals["total"]?.number()
        if( callBeverbende(model: my_score!, opponent1: Double(model.otherPlayer2.sumCards()), opponent2: Double(model.otherPlayer3.sumCards()), opponent3: Double(model.humanPlayer.sumCards()))) {
               //We wanna call beverbende
            model.modifyLastAction(slot: "isa", value: "beverbende")
            model.modifyLastAction(slot: "choice", value: "yes")
            model.run()
        }else{
            //We do not wanna call beverbende
            model.modifyLastAction(slot: "isa", value: "beverbende")
            model.modifyLastAction(slot: "choice", value: "no")
            model.run()
        }
        
        //Beverbende has been called, so that must be excecuted in swift as well.
         if model.buffers["action"]?.slotvals["action"]?.text() == "beverbende" {
            //Beverbende has been called by the model
            //beverbende will be called from the ViewController
            return(-2,-2,true)
        }
        
        
        //Beverbende has not been called so we continue with our turn
        model.modifyLastAction(slot: "isa", value: "moves")
        //If discard pile is empty give nil to ACT-R otherwise give the value of the card at the top of the discard pile
        if discardPile.isEmpty(){
            model.buffers["action"]?.slotvals["discard"] = nil
        }else{
            model.modifyLastAction(slot: "discard", value: String(discardPile.returnCardAtPos(position: discardPile.cards.endIndex-1)))
        }
        if drawPile.returnStringAtPos(position: drawPile.cards.endIndex-1) == "swap" {
            model.modifyLastAction(slot: "draw", value: "swap")
        } else if drawPile.returnStringAtPos(position: drawPile.cards.endIndex-1) == "sneak-peek" {
            model.modifyLastAction(slot: "draw", value: "sneak-peek")
        } else {
            model.modifyLastAction(slot: "draw", value: String(drawPile.returnCardAtPos(position: drawPile.cards.endIndex-1)))
        }
        model.run()

        //If the action required is a sneakpeek
        if model.buffers["action"]?.slotvals["action"]?.text() == "peek" {
            //Either ACT-R doesn't know where to look, then a random card will be looked at. Otherwise the speciefied card will be used.
            if model.buffers["action"]?.slotvals["position"]?.text() == "random"{
                //let Swift pick a random card to look at
                let position = Int(arc4random_uniform(3))
                let value = deck.returnCardAtPos(position: position)
                model.modifyLastAction(slot: "isa", value: "peek")
                model.modifyLastAction(slot: "position", value: String(position))
                model.modifyLastAction(slot: "value", value: String(value))
            } else {
                //Look at the card chosen by ACT-R.
                let position = Int((model.buffers["action"]?.slotvals["position"]?.number())!)
                let value = deck.returnCardAtPos(position: position)
                model.modifyLastAction(slot: "isa", value: "peek")
                model.modifyLastAction(slot: "position", value: String(position))
                model.modifyLastAction(slot: "value", value: String(value))
                }
        } else if model.buffers["action"]?.slotvals["action"]?.text() == "find-swap"{
            let lowest_opponent_card = min_opponents(model: model)
            print(lowest_opponent_card)
            model.modifyLastAction(slot: "isa", value: "swap")
            model.modifyLastAction(slot: "player", value: String(lowest_opponent_card.0))
            model.modifyLastAction(slot: "position", value: String(lowest_opponent_card.1))
            model.modifyLastAction(slot: "value", value: String(lowest_opponent_card.2))
            
        }
        model.run()
        print(model.buffers)

        // TODO: ACT-R Model actions are performed here
        if model.buffers["action"]?.slotvals["action"]?.text() == "discard-draw" {
            return (0, 0, false)
        } else if model.buffers["action"]?.slotvals["action"]?.text() == "took-draw" {
            let position = Int((model.buffers["action"]?.slotvals["position"]?.number())!)
            // should be the value of the card that will be swapped and put in the discardpile later on
            let value = deck.cards[position].value / 2
            // needed so that special cards still have avg of 5
            ACTRUpdateKnowledge(model: model, deck: deck, action: 1, position: position, value: value)
            return (1, position, false)
        } else if model.buffers["action"]?.slotvals["action"]?.text() == "took-discard" {
            let position = Int((model.buffers["action"]?.slotvals["position"]?.number())!)
            let value = discardPile.cards[discardPile.cards.endIndex-1].value  //hoeft niet te delen door twee hier, want je weet de waarde exact
            // needed so that special cards still have avg of 5
            ACTRUpdateKnowledge(model: model, deck: deck, action: 2, position: position, value: value)
            return (2, position, false)
        } else if model.buffers["action"]?.slotvals["action"]?.text() == "took-swap" {
            //Implement a swap
            let position1 = Int((model.buffers["action"]?.slotvals["pos1"]?.number())!)
            let position2 = Int((model.buffers["action"]?.slotvals["pos2"]?.number())!)
            let model_player = Int((model.buffers["action"]?.slotvals["player1"]?.number())!)
            let opponent = Int((model.buffers["action"]?.slotvals["player2"]?.number())!)
            //Get the playernumbers in the correct swift convention
            let model_deck =  getSwiftPlayerNumber(model: model.playerNumber, player: model_player)
            let opponent_deck =  getSwiftPlayerNumber(model: model.playerNumber, player: opponent)
            //Swap player1 pos1 with player 2 pos 2
            model_deck.swapPlayerCardsAtPos(fromDeck: opponent_deck, posFrom: position2, posTo: position1)
            //Historie wordt nog niet geupdate met een swap move
            return (0, 0, false)
        } else if model.buffers["action"]?.slotvals["action"]?.text() == "discard-swap" {
            //Model discarded a swap, so nothing changes other than that the card goes from drawpile to discardpile
            
            return (0, 0, false)
        } else if model.buffers["action"]?.slotvals["action"]?.text() == "peek-done" {
            //Model looked at one of its cards: representation needs to be updated and card from draw to discard. 
            return (0, 0, false)
        } else {
            return (-1, -1, false)
        }
        // three other case: took-swap en discard-swap, peek-done
    }

    public func cardActions(pos: Int, pileClicked: Int, deck: Deck) {
        // if the drawPile is clicked
        if pileClicked == 1 {
            discardPile.appendCard(fromDeck: deck, pos: pos)
            deck.popAndInsertCard(fromDeck: drawPile, pos: pos)
        } else if pileClicked == 2 {
            // if the discardPile is clicked
            deck.swapCardsAtPos(fromDeck: discardPile, pos: pos)
        }
        if discardPile.cards[discardPile.cards.endIndex-1].type == "sneak-peek" ||
            discardPile.cards[discardPile.cards.endIndex-1].type == "swap" {
            discardPile.makeCardsClickable(fourCards: false, setTrueOrFalse: false)
        }
    }
    
    //Check whether a hand is smaller than all the other by a certain percentage to decide if we want to call beverbende.
    public func callBeverbende(model: Double, opponent1: Double, opponent2: Double, opponent3: Double) -> (Bool){
        let win_factor = 1.5     //Opponents cards have to be 50% higher
        if ( (opponent1 >= model*win_factor) && (opponent2 >= model*win_factor)  &&  (opponent3 >= model*win_factor) ){
            return true
        }else{
            return false
        }
    }
    
        
    private func max(model: ModelPlayer) -> (Double, Int) {
        var highest: Double = -1
        var highestpos: Int = 5
        let position = ["pos0","pos1","pos2","pos3"]
        var j = 0
        for i in position {
            let value = model.buffers["action"]?.slotvals[i]?.number()
            if value != nil {
                if value! > highest {
                    highest = value!
                    highestpos = j
                }
            }
            j += 1
        }
        return (highest,highestpos)
    }
    
    private func sum(model: ModelPlayer) -> Int {
        let position = ["pos0","pos1","pos2","pos3"]
        var sum: Int = 0
        for i in position {
            let value = model.buffers["action"]?.slotvals[i]?.number()
            if value != nil {
                sum = sum + Int(value!)
            }
        }
        return sum
    }
    
    private func min(model: ModelPlayer) -> (Double, Int)  {
        var lowest: Double = 100
        var lowestpos: Int = 5
        let position = ["pos0","pos1","pos2","pos3"]
        var j = 0
        for i in position {
            let value = model.buffers["action"]?.slotvals[i]?.number()
            if value != nil {
                if value! < lowest {
                    lowest = value!
                    lowestpos = j
                }
            }
            j += 1
        }
        return(lowest,lowestpos)
    }
    
    //Get the opponent card with the smallest estimated value
    private func min_opponents(model: ModelPlayer) -> (Int, Int, Double)  {
        var lowest: Double = 100
        var lowestpos: Int = -1
        var player: Int = -1
        var lowest_chunk: String = ""
        let position = ["opp11","opp12","opp13","opp14","opp21","opp22","opp23","opp24","opp31","opp32","opp33","opp34"]
        for i in position {
            let value = model.dm.chunks[i]?.slotvals["avg"]?.number()
            if value != nil {
                if model.dm.chunks[i]!.activation() >= model.dm.retrievalThreshold{
                    if value! < lowest {
                        lowest = value!
                        lowest_chunk = i
                    }
                }
            }
        }
            //Misselijk makende switch
            switch lowest_chunk {
            case "opp11":
                lowestpos = 0
                player = 1
            case "opp12":
                lowestpos = 1
                player = 1
            case "opp13":
                lowestpos = 2
                player = 1
            case "opp14":
                lowestpos = 3
                player = 1
            case "opp21":
                lowestpos = 0
                player = 2
            case "opp22":
                lowestpos = 1
                player = 2
            case "opp23":
                lowestpos = 2
                player = 2
            case "opp24":
                lowestpos = 3
                player = 2
            case "opp31":
                lowestpos = 0
                player = 3
            case "opp32":
                lowestpos = 1
                player = 3
            case "opp33":
                lowestpos = 2
                player = 3
            case "opp34":
                lowestpos = 3
                player = 3
            default:
                lowestpos = -1
                player = -1
    
        }
        return(player,lowestpos, lowest)
    }
    
    
    public func getSwiftPlayerNumber(model: Int, player: Int) -> (Deck){
        //Make sure the player numbers used in Swift match up with those in ACT-R
        if(model == 1){
            if(player == 0 ){
                //The model is talking about itself
                return actrDeck1
            }else if(player == 1 ){
                //First opponent of model 1 is model 2 in swift
                return actrDeck2
            }else if(player == 2 ){
                //second opponent of model 1 is model 3 in swift
                return actrDeck3
            }else if(player == 3 ){
                //Third opponent of model 1 is the human player in swift
                return playerDeck
            }
        } else if(model == 2){
            if(player == 0 ){
                //The model is talking about itself
                return actrDeck2
            }else if(player == 1 ){
                //First opponent of model 2 is model 3 in swift
                return actrDeck3
            }else if(player == 2 ){
                //second opponent of model 2 is the human player in swift
                return playerDeck
            }else if(player == 3 ){
                //Third opponent of model 2 is model 1 in swift
                return actrDeck1
            }
        } else if(model == 3){
            if(player == 0 ){
                //The model is talking about itself
                return actrDeck3
            }else if(player == 1 ){
                //First opponent of model 3 is the human player
                return playerDeck
            }else if(player == 2 ){
                //second opponent of model 3 is model 1 in swift
                return actrDeck1
            }else if(player == 3 ){
                //Third opponent of model 3 is model 2 in swift
                return actrDeck2
            }
        }
        return Deck()
    }
    
    public func resolveSpecialCards(deck: Deck, pos: Int){
        while deck.returnStringAtPos(position: pos) ==  "swap" || deck.returnStringAtPos(position: pos) == "sneak-peek" {
            deck.popAndInsertCard(fromDeck: drawPile, pos: pos)
            
        }
    }

    public func initGame() {
        playerDeck.showOuterCards()
    }
    
    public func hideCard() {
        playerDeck.hideOuterCards()
    }
    
    init() {
        self.drawPile = Deck(completeDeck: true)
        self.playerDeck = Deck(drawPile: drawPile)
        self.actrDeck1 = Deck(drawPile: drawPile)
        self.actrDeck2 = Deck(drawPile: drawPile)
        self.actrDeck3 = Deck(drawPile: drawPile)
        self.discardPile = Deck()
        self.modelPlayer1 = ModelPlayer(playerNumber: 1)
        self.modelPlayer2 = ModelPlayer(playerNumber: 2)
        self.modelPlayer3 = ModelPlayer(playerNumber: 3)
    }
}

//
//  deck.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import Foundation
//9* ruilen, 7 * spieken
class Deck {
    private(set) var cards = [Card]()
    
    // TODO: Create a complete deck with 52 cards
    public func createDeck() {
        for _ in 0..<10 {
            // TODO: add correct cards to the deck when initialized
            for i in 0..<10 {
                let card = Card(value: i)
                cards += [card]
            }
        }
        for _ in 0..<10 {
            let card = Card(value: 5, type: "swap")
            cards += [card]
        }
        for _ in 0..<8 {
            let card = Card(value: 5, type: "sneak-peek")
            cards += [card]
        }
        // Shuffles the entire deck
        cards.shuffle()
    }
    
    // Initialize a player deck
    private func createPlayerDeck(drawDeck: Deck) {
        for i in 0..<4 {
            drawCard(fromDeck: drawDeck, pos: i)
        }
    }
    
    // DrawPile is empty (Drawpile is self, fromDeck is discardPile)
    public func reshuffleAndInsert(fromDeck: Deck) {
        // Make sure that all the values of the special cards are set back to 5
        for i in 0..<fromDeck.cards.endIndex {
            if fromDeck.cards[i].type == "sneak-peek" || fromDeck.cards[i].type == "swap" {
                fromDeck.cards[i].setValue(value: 5)
            }
        }
        // Create a tmp deck which is a copy of the discardPile with the last card dropped
        let tmp = Deck()
        let slice = fromDeck.cards.dropLast()
        tmp.cards = Array(slice)
        tmp.cards.shuffle()
        // Set all the cards to faceDown
        for i in 0..<tmp.cards.endIndex {
            tmp.cards[i].isFaceUp = false
        }
        // Overwrite drawPile with the tmp deck
        self.cards = tmp.cards
        // Set discardPile to be only the last card of the pile
        fromDeck.cards = [fromDeck.cards.popLast()!]
    }
    
    // you call this function playerDeck.swapPlayerCardsAtPos(fromDeck: actrDeck1, posFrom: 3, posTo: 2) PosTo corresponds with self.cards[PosTo]
    public func swapPlayerCardsAtPos(fromDeck: Deck, posFrom: Int, posTo: Int) {
        let card = fromDeck.cards[posFrom]
        let card1 = self.cards[posTo]
        fromDeck.cards.remove(at: posFrom)
        self.cards.remove(at: posTo)
        fromDeck.cards.insert(card1, at: posFrom)
        self.cards.insert(card, at: posTo)
    }
    
    public func swapCardsAtPos(fromDeck: Deck, pos: Int) {
        let card = fromDeck.cards.popLast()
        let card_1 = self.cards[pos]
        self.cards.remove(at: pos)
        self.cards.insert(card!, at:pos)
        fromDeck.cards.append(card_1)
    }
    
    public func appendCard(fromDeck: Deck, pos: Int) {
        var card = fromDeck.cards[pos]
        if card.type == "swap" || card.type == "sneak-peek" {
            card.setValue(value: 10)
        }
        // to do: maybe set this to true
        // card.isFaceUp = true
        self.cards.append(card)
    }
    
    public func popAndInsertCard(fromDeck: Deck, pos: Int) {
        var card = fromDeck.cards.popLast()
        card?.isClickable = false
        self.cards.remove(at: pos)
        self.cards.insert(card!, at:pos)
    }
    
    public func removeAndAppendCard(fromDeck: Deck) {
        var card = fromDeck.cards.popLast()
        card?.isFaceUp = true
        if card?.type == "swap" || card?.type == "sneak-peek" {
            card?.setValue(value: 10)
            card?.isClickable = false
        } else {
            card?.isClickable = true
        }
        self.cards.append(card!)
    }
    
    // Draws a card from one deck to another
    public func drawCard(fromDeck: Deck, pos: Int) {
        let card = fromDeck.cards.popLast()
        self.cards.insert(card!, at:pos)
    }
    
    public func returnCardAtPos(position: Int) -> Int {
        return cards[position].value
    }
    
    public func returnStringAtPos(position: Int) -> String {
        return cards[position].type
    }
    
    public func setCardValueAtPos(position: Int, value: Int) {
        cards[position].value = value
    }
    
    public func isEmpty() -> Bool {
        return self.cards.isEmpty
    }
    
    public func showOuterCards() {
        self.cards[0].isFaceUp = true
        self.cards[3].isFaceUp = true
    }
    
    public func hideOuterCards() {
        // todo: set this to false
        self.cards[0].isFaceUp = false
        self.cards[3].isFaceUp = false
    }
    
    public func makeCardsClickable(fourCards: Bool, setTrueOrFalse: Bool) {
        if fourCards {
            for index in 0..<4 {
                if setTrueOrFalse {
                    self.cards[index].isClickable = true
                } else {
                    self.cards[index].isClickable = false
                }
            }
        } else if !self.cards.isEmpty {
            if setTrueOrFalse {
                self.cards[cards.endIndex-1].isClickable = true
            } else {
                self.cards[cards.endIndex-1].isClickable = false
            }
        }
    }
    
    public func makeCardsHighlighted(fourCards: Bool, setTrueOrFalse: Bool) {
        if fourCards {
            for index in 0..<4 {
                if setTrueOrFalse {
                    self.cards[index].isHighlighted = true
                } else {
                    self.cards[index].isHighlighted = false
                }
            }
        } else if !self.cards.isEmpty {
            if setTrueOrFalse {
                self.cards[cards.endIndex-1].isHighlighted = true
            } else {
                self.cards[cards.endIndex-1].isHighlighted = false
            }
        }
    }
    

    public func makeCardsFaceUp(fourCards: Bool, setTrueOrFalse: Bool) {
        if fourCards {
            for index in 0..<4 {
                if setTrueOrFalse {
                    self.cards[index].isFaceUp = true
                } else {
                    self.cards[index].isFaceUp = false
                }
            }
        } else if !self.cards.isEmpty {
            if setTrueOrFalse {
                self.cards[cards.endIndex-1].isFaceUp = true
                print(self.cards[cards.endIndex-1].value)
            } else {
                self.cards[cards.endIndex-1].isFaceUp = false
            }
        }
    }
    
    public func makeCardFaceUp(index: Int, bool: Bool) {
        self.cards[index].isFaceUp = bool
    }
    
    public func sumCards() -> Int{
        var sum = 0
        for i in 0..<4{
            sum += self.cards[i].value
        }
        return sum
    }
    
    private func initFourCards() {
        for _ in 0..<4 {
            let card = Card(value: 5)
            cards += [card]
        }
    }
    
    // Init a deck with all the cards
    init(completeDeck: Bool) {
        if completeDeck {
            createDeck()
        }
    }
    
    // Init a player deck
    init(drawPile: Deck) {
        createPlayerDeck(drawDeck: drawPile)
    }
    
    // Init four cards for representation of ACT-R Model
    init(playerModel: Bool) {
        if playerModel {
            initFourCards()
        }
    }
    
    
    // Init an empty deck
    init() {
    }
}

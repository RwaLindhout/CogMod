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
//    public var isClickedPile = false
    
    // TODO: Create a complete deck with 52 cards
    public func createDeck() {
        for _ in 0..<6 {
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
        for _ in 0..<7 {
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
    
    public func reshuffleAndInsert(fromDeck: Deck) {
        if self.cards.isEmpty {
            let tmp = Deck()
            let slice = fromDeck.cards.dropLast()
            tmp.cards = Array(slice)
            tmp.cards.shuffle()
            self.cards = tmp.cards
        }
    }
    
    public func swapCardsAtPos(fromDeck: Deck, pos: Int) {
        let card = fromDeck.cards.popLast()
        let card_1 = self.cards[pos]
        self.cards.remove(at: pos)
        self.cards.insert(card!, at:pos)
        fromDeck.cards.append(card_1)
    }
    
    // you call this function playerDeck.swapPlayerCardsAtPos(fromDeck: actrDeck1, posFrom: 3, posTo: 2)
    //Van actrr deck naar playerdeck, pos from is van act-r deck en to is naar playaaahhh deck
    public func swapPlayerCardsAtPos(fromDeck: Deck, posFrom: Int, posTo: Int) {
        let card = fromDeck.cards[posFrom]
        let card1 = self.cards[posTo]
        fromDeck.cards.remove(at: posFrom)
        self.cards.remove(at: posTo)
        fromDeck.cards.insert(card1, at: posFrom)
        self.cards.insert(card, at: posTo)
    }
    
    public func appendCard(fromDeck: Deck, pos: Int) {
        let card = fromDeck.cards[pos]
        self.cards.append(card)
    }
    
    public func popAndInsertCard(fromDeck: Deck, pos: Int) {
        let card = fromDeck.cards.popLast()
        self.cards.remove(at: pos)
        self.cards.insert(card!, at:pos)
    }
    
    public func removeAndAppendCard(fromDeck: Deck) {
        let card = fromDeck.cards.popLast()
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
    
    public func makeCardFaceUp(index: Int) {
        self.cards[index].isFaceUp = true
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

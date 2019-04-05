//
//  ViewController.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let bever = UIImage(named: "bever.jpg")!
    let vergrootglas = UIImage(named: "vergrootglas.png")!
    let ruil = UIImage(named: "ruil.png")!

    private var score = [0,0,0,0]
    
    private lazy var game = Game()
    private lazy var newGame = Game()
    private var beverBendeCount = 0
    
    // 0 for nothing, 1 for drawPile, 2 for discardPile
    private var pileClicked = 0
    
    // If start button is pressed, the outer two player cards must be placed downwards,
    // and the turn of the player should start, later this button should be used to call
    // BeverBende
    private var clickCount = 0
    private var endGame = false
    private var special = 0
    private var playerTurn = true
    private lazy var swapDeck: Deck? = nil
    private var swapPos: Int? = nil
    
    @IBAction func centralButton(_ sender: UIButton) {
        clickCount+=1
        centralButtonClick(button: sender, clicks: clickCount)
    }
    
    func centralButtonClick(button: UIButton,clicks: Int){
        switch (clicks)
        {
        case 1:
            game.initGame()
            updateViewFromModel(updateDiscardPile: true)
        case 2:
            game.hideCard()
            updateViewFromModel(updateDiscardPile: true)
            game.cardsInit(ACTR: false)
            updateViewFromModel(updateDiscardPile: true)
            button.setTitle("BeverBende!", for: .normal)
        default:
            endGame = true
            beverbende()
            break;
        }
    }
    
    public func beverbende(){
        for i in 0..<4 {
            game.resolveSpecialCards(deck: game.playerDeck, pos: playerButtons[i].tag)
            game.resolveSpecialCards(deck: game.actrDeck1, pos: actr1Buttons[i].tag)
            game.resolveSpecialCards(deck: game.actrDeck2, pos: actr2Buttons[i].tag)
            game.resolveSpecialCards(deck: game.actrDeck3, pos: actr3Buttons[i].tag)
        }

        updateViewFromModel(updateDiscardPile: true)
        score[0] += game.playerDeck.sumCards()
        score[1] += game.actrDeck1.sumCards()
        score[2] += game.actrDeck2.sumCards()
        score[3] += game.actrDeck3.sumCards()
        game.playerDeck.makeCardsFaceUp(fourCards: true, setTrueOrFalse: true)
        game.actrDeck1.makeCardsFaceUp(fourCards: true, setTrueOrFalse: true)
        game.actrDeck2.makeCardsFaceUp(fourCards: true, setTrueOrFalse: true)
        game.actrDeck3.makeCardsFaceUp(fourCards: true, setTrueOrFalse: true)
        updateViewFromModel(updateDiscardPile: true)
        beverBendeCount += 1
        if beverBendeCount == 5 {
            showscore(end: true)
        } else {
            showscore(end: false)
        }
    }
    
    public func startNewGame(){
        newGame = Game()
        game = newGame
        self.updateViewFromModel(updateDiscardPile: true)
        self.loadModels(game: game)
        clickCount = 0
        pileClicked = 0
        self.beverBendeButton.setTitle("Start!", for: .normal)
        // now everything should start again
    }
    

    @IBAction func drawPileClick(_ sender: UIButton) {
        pileClicked = 1
//        game.drawPile.makeCardsFaceUp(fourCards: false, setTrueOrFalse: true)
        if game.drawPile.returnStringAtPos(position: game.drawPile.cards.endIndex-1) == "swap" {
            special = 1
            game.actrDeck1.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
            game.actrDeck2.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
            game.actrDeck3.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
            game.actrDeck1.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
            game.actrDeck2.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
            game.actrDeck3.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
        } else {
            game.playerDeck.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
            game.playerDeck.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
        }
        if game.drawPile.returnStringAtPos(position: game.drawPile.cards.endIndex-1) == "sneak-peek" {
            game.playerDeck.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
            game.playerDeck.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
            special = 2
        }
        game.discardPile.makeCardsClickable(fourCards: false, setTrueOrFalse: true)
        game.discardPile.makeCardsHighlighted(fourCards: false, setTrueOrFalse: true)
        updateViewFromModel(updateDiscardPile: true)
        
        // action: make playerdeck highlighted and clickable, and discardpile as well
    }
    
    private func chooseSwapCard (button: MyButton) {
        for i in 0..<4 {
            if actr1Buttons[i] == button {
                swapDeck = game.actrDeck1
                swapPos = button.tag
            }
            if actr2Buttons[i] == button {
                swapDeck = game.actrDeck2
                swapPos = button.tag
            }
            if actr3Buttons[i] == button {
                swapDeck = game.actrDeck3
                swapPos = button.tag
            }
        }
        game.actrDeck1.makeCardsClickable(fourCards: true, setTrueOrFalse: false)
        game.actrDeck2.makeCardsClickable(fourCards: true, setTrueOrFalse: false)
        game.actrDeck3.makeCardsClickable(fourCards: true, setTrueOrFalse: false)
        game.actrDeck1.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
        game.actrDeck2.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
        game.actrDeck3.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
        game.playerDeck.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
        game.playerDeck.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
        updateViewFromModel(updateDiscardPile: true)
    }

    
    @IBAction func swapCardButton(_ sender: MyButton) {
        chooseSwapCard(button: sender)
    }
    
    @IBAction func discardPileClick(_ sender: MyButton) {
        // If the previous pileClicked was the drawPile
        if pileClicked == 1 {
            game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
            game.discardPile.makeCardsClickable(fourCards: false, setTrueOrFalse: false)
            // if the drawPile is now empty, put discard cards on the draw pile
            if game.drawPile.isEmpty() {
                game.drawPile.reshuffleAndInsert(fromDeck: game.discardPile)
            }
            playerTurn = false
            updateViewFromModel(updateDiscardPile: true)
            runACTR()
            game.cardsInit(ACTR: false)
            updateViewFromModel(updateDiscardPile: true)
        }
        pileClicked = 2
        
        game.playerDeck.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
        game.playerDeck.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
        game.drawPile.makeCardsClickable(fourCards: false, setTrueOrFalse: true)
        
        
        game.actrDeck1.makeCardsClickable(fourCards: true, setTrueOrFalse: false)
        game.actrDeck2.makeCardsClickable(fourCards: true, setTrueOrFalse: false)
        game.actrDeck3.makeCardsClickable(fourCards: true, setTrueOrFalse: false)
        game.actrDeck1.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
        game.actrDeck2.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
        game.actrDeck3.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
    }
    
    @IBAction func playerClick(_ sender: MyButton) {
        for i in 0..<4 {
            if playerButtons[i] == sender {
                // if drawPile has been clicked
                if pileClicked == 1 {
                    if special == 1{
                        playerButtons[i].isEnabled = false
                        game.playerDeck.swapPlayerCardsAtPos(fromDeck: swapDeck!, posFrom: swapPos!, posTo: playerButtons[i].tag)
                        game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
                        
                    }
                    if special == 2 {
                        game.playerDeck.makeCardFaceUp(index: playerButtons[i].tag, bool: true)
                        game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
                    } else {
                    // put card on discardPile and put drawPile card on correct place in playerDeck
                    game.cardActions(pos: playerButtons[i].tag, pileClicked: 1, deck: game.playerDeck)
                    //took draw
                    game.ACTRUpdateHumanKnowledge(action: 1, position: playerButtons[i].tag, value: (game.discardPile.returnCardAtPos(position: game.discardPile.cards.endIndex-1))/2)
                    // if the drawPile is now empty, put discard cards on the draw pile
                    if game.drawPile.isEmpty() {
                        game.drawPile.reshuffleAndInsert(fromDeck: game.discardPile) 
                        }
                    }
                } else if pileClicked == 2 {
                    //took discard
                    game.ACTRUpdateHumanKnowledge(action: 1, position: playerButtons[i].tag, value: (game.discardPile.returnCardAtPos(position: game.discardPile.cards.endIndex-1))/2)
                    // discardPile is clicked
                    game.cardActions(pos: playerButtons[i].tag, pileClicked: 2, deck: game.playerDeck)
                }
            }
        }
        special = 0
        pileClicked = 0
        // todo: turn of human is over, now the act-r models should run
        playerTurn = false
        updateViewFromModel(updateDiscardPile: true)
        runACTR()
        game.cardsInit(ACTR: false)
        updateViewFromModel(updateDiscardPile: true)
    }
    
    @IBOutlet var playerButtons: [MyButton]!
    @IBOutlet var actr1Buttons: [MyButton]!
    @IBOutlet var actr2Buttons: [MyButton]!
    @IBOutlet var actr3Buttons: [MyButton]!
    
    @IBOutlet weak var beverBendeButton: UIButton!
    @IBOutlet weak var discardPile: MyButton!
    @IBOutlet weak var drawPile: MyButton!
    
    @IBAction func score(_ sender: UIButton) {
        showscore(end: false)
    }
    
    func showscore(end: Bool){
        let alert = UIAlertController(title: "Score", message: "You: "+String(score[0])+"\nOpponent 1: "+String(score[1])+"\nOpponent 2: "+String(score[2])+"\nOpponent 3: "+String(score[3]), preferredStyle: .alert)
        if end{
            alert.addAction(UIAlertAction(title: "End Game", style: .default, handler: { _ in self.performSegue(withIdentifier: "backToStart", sender: nil)}))
        } else {
            alert.addAction(UIAlertAction(title: "Back to Menu", style: .default, handler: { _ in self.performSegue(withIdentifier: "backToStart", sender: nil)}))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.startNewGame()}))
        }
        self.present(alert, animated: true)
    }
    
    
    private func updateDeck(cardButton: [MyButton]!, deck: Deck, actr1 : Bool, actr2: Bool, actr3: Bool) {
        for index in cardButton.indices {
            let button = cardButton[index]
            let card = deck.cards[button.tag]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                if card.type == "swap" {
                    button.setBackgroundImage(ruil, for: .normal)
                    button.setTitle("", for: .normal)
                } else if card.type == "sneak-peek"{
                    button.setBackgroundImage(vergrootglas, for: .normal)
                    button.setTitle("", for: .normal)
                } else {
                    button.setTitle(String(card.value), for:UIControl.State.normal)
                    button.setBackgroundImage(nil, for: .normal)
                }
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                if actr1 == true {
                    let imageRotate = bever.rotate(radians: .pi/2)
                    button.setBackgroundImage(imageRotate, for: .normal)
                }
                else if actr2 == true {
                    let imageRotate = bever.rotate(radians: .pi)
                    button.setBackgroundImage(imageRotate, for: .normal)
                }
                else if actr3 == true {
                    let imageRotate = bever.rotate(radians: .pi/2*3)
                    button.setBackgroundImage(imageRotate, for: .normal)
                } else {
                    button.setBackgroundImage(bever, for: .normal)
                }
            }
            if card.isHighlighted {
                button.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            } else {
                button.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
            if card.isClickable {
                button.isEnabled = true
            } else {
                button.isEnabled = false
            }
        }
    }
    
    
    private func updateDeck(cardButton: MyButton, deck: Deck, isDrawPile: Bool) {
        // If deck is empty, make button transparent, for visibility this is now brown
        if deck.isEmpty() {

            cardButton.setTitle("", for: UIControl.State.normal)
            cardButton.setBackgroundImage(nil, for: .normal)
            cardButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            cardButton.isEnabled = true
        // If deck is not empty, and is a drawPile, then set
        // color to white, and the title to the last value in the collection of cards
//        } else if !isDrawPile {
//            if deck.cards[deck.cards.endIndex-1].type == "swap" {
//                cardButton.setBackgroundImage(ruil, for: .normal)
//                cardButton.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
//                cardButton.setTitle("", for: .normal)
//            } else if deck.cards[deck.cards.endIndex-1].type == "sneak-peek" {
//                cardButton.setBackgroundImage(vergrootglas, for: .normal)
//                cardButton.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
//                cardButton.setTitle("", for: .normal)
//            } else {
//                cardButton.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
//                cardButton.setBackgroundImage(nil, for: .normal)
//                cardButton.setTitle(String(deck.cards[deck.cards.endIndex-1].value), for:UIControl.State.normal)
//            }
        // If the deck is the drawPile
        } else {
            cardButton.setTitle("", for: UIControl.State.normal)
            cardButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            cardButton.setBackgroundImage(bever, for: .normal)
            if deck.cards[deck.cards.endIndex-1].isHighlighted {
                cardButton.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            } else if !deck.cards[deck.cards.endIndex-1].isHighlighted{
                cardButton.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
            if deck.cards[deck.cards.endIndex-1].isFaceUp {
                if deck.cards[deck.cards.endIndex-1].type == "swap" {
                    cardButton.setBackgroundImage(ruil, for: .normal)
                    cardButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    cardButton.setTitle("", for: .normal)
                } else if deck.cards[deck.cards.endIndex-1].type == "sneak-peek" {
                    cardButton.setBackgroundImage(vergrootglas, for: .normal)
                    cardButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    cardButton.setTitle("", for: .normal)
                } else {
                    cardButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    cardButton.setBackgroundImage(nil, for: .normal)
                    cardButton.setTitle(String(deck.cards[deck.cards.endIndex-1].value), for:UIControl.State.normal)
                }
            } else {
                cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            if deck.cards[deck.cards.endIndex-1].isClickable && playerTurn == true {
                print("true\n")
                cardButton.isEnabled = true
            } else {
                print("false\n")
                cardButton.isEnabled = false
            }
        }
    }
    
    // Update all different decks
    private func updateViewFromModel(updateDiscardPile: Bool) {
        if updateDiscardPile {
            updateDeck(cardButton: discardPile, deck: game.discardPile, isDrawPile: false)
        }
        updateDeck(cardButton: drawPile, deck: game.drawPile, isDrawPile: true)
        updateDeck(cardButton: playerButtons, deck: game.playerDeck, actr1: false, actr2: false,actr3: false)
        updateDeck(cardButton: actr1Buttons, deck: game.actrDeck1, actr1: true,actr2:false,actr3:false)
        updateDeck(cardButton: actr2Buttons, deck: game.actrDeck2,actr1:false,actr2:true,actr3:false)
        updateDeck(cardButton: actr3Buttons, deck: game.actrDeck3,actr1:false,actr2:false,actr3:true)
    }
   
    private func showSwap(){
        
    }
    
    // todo: this function should also update all the representations of cards
    private func updateACTRActions(action: Int, position: Int, positionTo: Int, deck: Deck, opponent_deck: Deck?) {
        let alert = UIAlertController(title: "", message: "Your turn!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        var chooseDeck = 5
        var opponentDeck = 5
        let decks = [playerButtons, actr1Buttons,actr2Buttons,actr3Buttons]
        var opponentButtons: [MyButton]?
        if deck === game.actrDeck1 {
            chooseDeck = 1
        } else if deck === game.actrDeck2 {
            chooseDeck = 2
        } else if deck === game.actrDeck3 {
            chooseDeck = 3
        }
        if opponent_deck != nil {
            if opponent_deck === game.playerDeck {
                opponentDeck = 0
            } else if opponent_deck === game.actrDeck1 {
                opponentDeck = 1
            } else if opponent_deck === game.actrDeck2 {
                opponentDeck = 2
            } else if opponent_deck === game.actrDeck3 {
                opponentDeck = 3
            }
            opponentButtons = decks[opponentDeck]
        }
        let buttons = decks[chooseDeck]
        // if action is discard-draw
        if action == 0 {
            game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
            // if the drawPile is now empty, put discard cards on the draw pile
            if game.drawPile.isEmpty() {
                game.drawPile.reshuffleAndInsert(fromDeck: game.discardPile)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1 ,
                delay: 0,
                options: [],
                animations: {
                    self.drawPile.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1,
                    delay: 0,
                    options: [],
                    animations: {
                        self.drawPile.transform = CGAffineTransform.identity
                }, completion: { _ in
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 0,
                        options: [],
                        animations: {
                            self.discardPile.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1,
                            delay: 0,
                            options: [],
                            animations: {
                                self.discardPile.transform = CGAffineTransform.identity
                                self.updateViewFromModel(updateDiscardPile: true)
                                if chooseDeck == 3 {
                                    self.present(alert, animated: true)
                                }
                        })
                    })
                })
            })
        // else if action is took-draw
        } else if action == 1 {
            //Look for the button corresponding to the correct tag
            for button in buttons! {
                if button.tag == position{
                    game.cardActions(pos: button.tag, pileClicked: 1, deck: deck)
                    if game.drawPile.isEmpty() {
                        game.drawPile.reshuffleAndInsert(fromDeck: game.discardPile)
                    }
                    button.isEnabled = false
                    deck.makeCardFaceUp(index: button.tag, bool: false)
                    // if the drawPile is now empty, put discard cards on the draw pile
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 0,
                        options: [],
                        animations: {
                            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            self.drawPile.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        }, completion: { _ in
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 1,
                                delay: 0,
                                options: [],
                                animations: {
                                    button.transform = CGAffineTransform.identity
                                    self.drawPile.transform = CGAffineTransform.identity
                           })
                       })
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 2,
                        options: [],
                        animations: {
                            self.discardPile.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1,
                            delay: 0,
                            options: [],
                            animations: {
                                self.discardPile.transform = CGAffineTransform.identity
                                self.updateViewFromModel(updateDiscardPile: true)
                                if chooseDeck == 3 {
                                    self.present(alert, animated: true)
                                }
                        })
                    })
                }
            }

        } else if action == 3 {
            for button in buttons!{
                if button.tag == position{
                    button.isEnabled = false
                    deck.makeCardFaceUp(index: button.tag, bool: false)
                    game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
                    if game.drawPile.isEmpty() {
                        game.drawPile.reshuffleAndInsert(fromDeck: game.discardPile)
                    }
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 0,
                        options: [],
                        animations: {
                            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1,
                            delay: 0,
                            options: [],
                            animations: {
                                button.transform = CGAffineTransform.identity
                                self.updateViewFromModel(updateDiscardPile: true)
                        })
                    })
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 2,
                        options: [],
                        animations: {
                            self.discardPile.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1,
                            delay: 0,
                            options: [],
                            animations: {
                                self.discardPile.transform = CGAffineTransform.identity
                                self.updateViewFromModel(updateDiscardPile: true)
                                if chooseDeck == 3 {
                                    self.present(alert, animated: true)
                                }
                        })
                    })
                }
            }
        } else if action == 4 && opponentButtons != nil {
             for button in buttons! {
                if button.tag == position{
                    button.isEnabled = false
                    deck.makeCardFaceUp(index: button.tag, bool: false)
                    game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
                    if game.drawPile.isEmpty() {
                        game.drawPile.reshuffleAndInsert(fromDeck: game.discardPile)
                    }
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 0,
                        options: [],
                        animations: {
                            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1,
                            delay: 0,
                            options: [],
                            animations: {
                                button.transform = CGAffineTransform.identity
                        })
                    })
                }
            }
            for opponentButton in opponentButtons! {
                if opponentButton.tag == position{
                    deck.makeCardFaceUp(index: opponentButton.tag, bool: false)
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 0,
                        options: [],
                        animations: {
                            opponentButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: { _ in
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 1,
                            delay: 0,
                            options: [],
                            animations: {
                                opponentButton.transform = CGAffineTransform.identity
                                self.updateViewFromModel(updateDiscardPile: true)
                                if chooseDeck == 3 {
                                    self.present(alert, animated: true)
                                }
                        })
                    })
                }
            }
        
        }//else action is took-discard
            else {
            //Look for the button corresponding to the correct tag
            for button in buttons! {
                if button.tag == position{
                    game.cardActions(pos: button.tag, pileClicked: 2, deck: deck)
                    button.isEnabled = false
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 1,
                        delay: 0,
                        options: [],
                        animations: {
                            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                            self.discardPile.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        }, completion: { _ in
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 1,
                                delay: 0,
                                options: [],
                                animations: {
                                    button.transform = CGAffineTransform.identity
                                    self.discardPile.transform = CGAffineTransform.identity
                                    self.updateViewFromModel(updateDiscardPile: true)
                                    if chooseDeck == 3 {
                                        self.present(alert, animated: true)
                                    }
                            })
                        })
                }
            }
        }
    }
    
    private func runACTR() {
        if !game.isFinished {
            game.initACTRModelActions(model: game.modelPlayer1, deck: game.actrDeck1)
            game.initACTRModelActions(model: game.modelPlayer2, deck: game.actrDeck2)
            game.initACTRModelActions(model: game.modelPlayer3, deck: game.actrDeck3)
            game.isFinished = true
        }
        
        game.cardsInit(ACTR: true)
        
        self.game.actrDeck1.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
        self.updateViewFromModel(updateDiscardPile: false)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if !self.endGame {
                self.game.playerDeck.makeCardsFaceUp(fourCards: true, setTrueOrFalse: false)
                let (action, position, positionTo, opponent_deck, beverbende) = self.game.ACTRModelActions(model: self.game.modelPlayer1, deck: self.game.actrDeck1)
                
                if(beverbende == true){
                    self.beverbende()
                    return
                }
                if action != -1 {
                    self.updateACTRActions(action: action, position: position, positionTo: positionTo, deck: self.game.actrDeck1, opponent_deck: opponent_deck)
                 }
               DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.game.cardsInit(ACTR: true)
                    self.game.actrDeck1.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
                    self.game.actrDeck2.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
                    self.updateViewFromModel(updateDiscardPile: false)
         
                    let (action1, position1, positionTo1, opponent_deck1, beverbende1) = self.game.ACTRModelActions(model: self.game.modelPlayer2, deck: self.game.actrDeck2)
                    if(beverbende1 == true){
                        self.beverbende()
                        return
                    }
                    if action1 != -1 {
                        self.updateACTRActions(action: action1, position: position1, positionTo: positionTo1,deck: self.game.actrDeck2, opponent_deck: opponent_deck1)
                    }
                    self.game.actrDeck2.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
                    self.game.cardsInit(ACTR: true)
                    self.game.actrDeck3.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
                    self.updateViewFromModel(updateDiscardPile: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.game.actrDeck2.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
                        self.game.actrDeck3.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
                        self.updateViewFromModel(updateDiscardPile: false)
                    
                        let (action2, position2, positionTo2, opponent_deck2, beverbende2) = self.game.ACTRModelActions(model: self.game.modelPlayer3, deck: self.game.actrDeck3)
                        if(beverbende2 == true){
                            self.beverbende()
                            return
                        }
                        if action2 != -1 {
                            self.updateACTRActions(action: action2, position: position2,positionTo: positionTo2, deck: self.game.actrDeck3, opponent_deck: opponent_deck2)
                         }
                
                        
                    }
                    self.game.cardsInit(ACTR: false)
                    self.game.actrDeck3.makeCardsHighlighted(fourCards: true, setTrueOrFalse: false)
                    self.playerTurn = true
                    self.updateViewFromModel(updateDiscardPile: false)
                }
            }
            
        }
    }
    
    private func loadModels(game: Game){
        print("models loaded")
        game.modelPlayer1.loadModel(fileName: "beverbende")
        game.modelPlayer1.loadedModel = "beverbende"
        
        game.modelPlayer2.loadModel(fileName: "beverbende")
        game.modelPlayer2.loadedModel = "beverbende"
        
        game.modelPlayer3.loadModel(fileName: "beverbende")
        game.modelPlayer3.loadedModel = "beverbende"
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        let image1 = UIImage(named: "table.jpg")
        
        self.view.backgroundColor = UIColor(patternImage: image1!)
        self.beverBendeButton.setTitle("Start!", for: .normal)
        
        game = Game()

        updateViewFromModel(updateDiscardPile: true)
        loadModels(game: game)
    }
}


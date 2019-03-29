//
//  ViewController.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let image = UIImage(named: "bever.jpg")
    let image1 = UIImage(named: "table.jpg")
    private lazy var game = Game()
    
    // 0 for nothing, 1 for drawPile, 2 for discardPile
    private var pileClicked = 0
    
    // If start button is pressed, the outer two player cards must be placed downwards,
    // and the turn of the player should start, later this button should be used to call
    // BeverBende
    var clickCount = 0
    
    @IBAction func centralButton(_ sender: UIButton) {
        clickCount+=1
        centralButtonClick(button: sender, clicks: clickCount)
    }
    
    func centralButtonClick(button: UIButton,clicks: Int){
        switch (clicks)
        {
        case 1:
            game.initGame()
            updateViewFromModel()
        case 2:
            game.hideCard()
            updateViewFromModel()
            game.cardsInit(ACTR: false)
            updateViewFromModel()
            button.setTitle("BeverBende!", for: .normal)
        default:
            //BeverBende
            break;
        }
    }
    
    @IBAction func drawPileClick(_ sender: UIButton) {
        pileClicked = 1
        
        game.playerDeck.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
        game.playerDeck.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
        updateViewFromModel()
        
        // action: make playerdeck highlighted and clickable, and discardpile as well
    }
    
    @IBAction func discardPileClick(_ sender: UIButton) {
        // If the previous pileClicked was the drawPile
        if pileClicked == 1 {
            game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
        }
        pileClicked = 2
        
        game.playerDeck.makeCardsClickable(fourCards: true, setTrueOrFalse: true)
        game.playerDeck.makeCardsHighlighted(fourCards: true, setTrueOrFalse: true)
        game.drawPile.makeCardsClickable(fourCards: false, setTrueOrFalse: true)
        updateViewFromModel()
    }
    
    @IBAction func playerClick(_ sender: MyButton) {
        for i in 0..<4 {
            if playerButtons[i] == sender {
                if pileClicked == 1 {
                    // put card on discardPile and put drawPile card on correct place in playerDeck
                    game.cardActions(pos: playerButtons[i].tag, pileClicked: 1, deck: game.playerDeck)
                } else if pileClicked == 2 {
                    // discardPile is clicked
                    game.cardActions(pos: playerButtons[i].tag, pileClicked: 2, deck: game.playerDeck)
                }
            }
        }
        pileClicked = 0
        // todo: turn of human is over, now the act-r models should run
        runACTR()
        game.cardsInit(ACTR: false)
        updateViewFromModel()
    }
    
    @IBOutlet var playerButtons: [MyButton]!
    @IBOutlet var actr1Buttons: [MyButton]!
    @IBOutlet var actr2Buttons: [MyButton]!
    @IBOutlet var actr3Buttons: [MyButton]!
    
    @IBOutlet weak var beverBendeButton: UIButton!
    @IBOutlet weak var discardPile: MyButton!
    @IBOutlet weak var drawPile: MyButton!
    
    @IBAction func score(_ sender: UIButton) {
        let alert = UIAlertController(title: "Score", message: "score", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    private func updateDeck(cardButton: [MyButton]!, deck: Deck, actr1 : Bool, actr2: Bool, actr3: Bool) {
        for index in cardButton.indices {
            let button = cardButton[index]
            let card = deck.cards[button.tag]
            if card.isFaceUp {
                button.setTitle(String(card.value), for:UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
                button.setBackgroundImage(nil, for: .normal)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
                if actr1 == true {
                    let imageRotate = image!.rotate(radians: .pi/2)
                    button.setBackgroundImage(imageRotate, for: .normal)
                }
                else if actr2 == true {
                    let imageRotate = image!.rotate(radians: .pi)
                    button.setBackgroundImage(imageRotate, for: .normal)
                }
                else if actr3 == true {
                    let imageRotate = image!.rotate(radians: .pi/2*3)
                    button.setBackgroundImage(imageRotate, for: .normal)
                } else {
                    button.setBackgroundImage(image!, for: .normal)
                }
            }
            if card.isHighlighted {
                if (actr1 || actr2 || actr3) {
                    button.borderColor = #colorLiteral(red: 0.09182383865, green: 0.6374981999, blue: 0.09660141915, alpha: 1)
                } else {
                button.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                }
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
            cardButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        // If deck is not empty, and is a drawPile, then set
        // color to white, and the title to the last value in the collection of cards
        } else if !isDrawPile {
            cardButton.setTitle(String(deck.cards[deck.cards.endIndex-1].value), for:UIControl.State.normal)
            cardButton.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        // If the deck is the drawPile
        } else {
            cardButton.setTitle("", for: UIControl.State.normal)
            cardButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            cardButton.setBackgroundImage(image!, for: .normal)
            if deck.cards[deck.cards.endIndex-1].isHighlighted {
                cardButton.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            }
            if deck.cards[deck.cards.endIndex-1].isFaceUp {
                cardButton.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
                cardButton.setBackgroundImage(nil, for: .normal)
                cardButton.setTitle(String(deck.cards[deck.cards.endIndex-1].value), for:UIControl.State.normal)
            }
            if deck.cards[deck.cards.endIndex-1].isClickable {
                cardButton.isEnabled = true
            } else {
                cardButton.isEnabled = false
            }
        }
    }
    
    // Update all different decks
    private func updateViewFromModel() {
        updateDeck(cardButton: drawPile, deck: game.drawPile, isDrawPile: true)
        updateDeck(cardButton: discardPile, deck: game.discardPile, isDrawPile: false)
        updateDeck(cardButton: playerButtons, deck: game.playerDeck, actr1: false, actr2: false,actr3: false)
        updateDeck(cardButton: actr1Buttons, deck: game.actrDeck1, actr1: true,actr2:false,actr3:false)
        updateDeck(cardButton: actr2Buttons, deck: game.actrDeck2,actr1:false,actr2:true,actr3:false)
        updateDeck(cardButton: actr3Buttons, deck: game.actrDeck3,actr1:false,actr2:false,actr3:true)
    }
   
    private func updateACTRActions(action: Int, position: Int, deck: Deck) {
        // if action is discard-draw
        if action == 0 {
            game.discardPile.removeAndAppendCard(fromDeck: game.drawPile)
        // else if action is took-draw
        } else if action == 1 {
            game.cardActions(pos: actr1Buttons[position].tag, pileClicked: 1, deck: deck)
        // else action is took-discard
        } else {
            game.cardActions(pos: actr1Buttons[position].tag, pileClicked: 1, deck: deck)
        }
    }
    
    private func runACTR() {
        var tmp = 0
        while !game.isFinished {
            // ACT-R Model turns
            game.cardsInit(ACTR: true)
            updateViewFromModel()
            print("working")
            tmp = tmp + 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                let (action, position) = self.game.ACTRModelActions(model: self.game.modelPlayer1, deck: self.game.actrDeck1)
                self.updateACTRActions(action: action, position: position, deck: self.game.actrDeck1)
                self.updateViewFromModel()
                
//                // ACT-R Model turns
//                self.game.cardsInit(ACTR: true)
//                self.updateViewFromModel()
//                let (action1, position1) = self.game.ACTRModelActions(model: self.game.modelPlayer2, deck: self.game.actrDeck2)
//                self.updateACTRActions(action: action1, position: position1, deck: self.game.actrDeck2)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//                    self.updateViewFromModel()
//
//                    // ACT-R Model turns
//                    self.game.cardsInit(ACTR: true)
//                    self.updateViewFromModel()
//                    let (action2, position2) = self.game.ACTRModelActions(model: self.game.modelPlayer3, deck: self.game.actrDeck3)
//                    self.updateACTRActions(action: action2, position: position2, deck: self.game.actrDeck3)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//                        self.updateViewFromModel()
//                    }
//                }
            }
            if tmp == 3 {
                game.isFinished = true
            }
            
//            game.cardsInit()
//            updateViewFromModel()
//            game.ACTRModelActions(model: game.modelPlayer2, deck: game.actrDeck2)
//            updateViewFromModel()
//
//            game.cardsInit()
//            updateViewFromModel()
//            game.ACTRModelActions(model: game.modelPlayer3, deck: game.actrDeck3)
//            updateViewFromModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: image1!)
        self.beverBendeButton.setTitle("Start!", for: .normal)
        
        game = Game()
        updateViewFromModel()
        game.modelPlayer1.loadModel(fileName: "beverbende")
        game.modelPlayer1.loadedModel = "beverbende"
        
//        game.modelPlayer2.loadModel(fileName: "beverbende")
//        game.modelPlayer2.loadedModel = "beverbende"
//
//        game.modelPlayer3.loadModel(fileName: "beverbende")
//        game.modelPlayer3.loadedModel = "beverbende"
        // Do any additional setup after loading the view.
    }
    
    
}


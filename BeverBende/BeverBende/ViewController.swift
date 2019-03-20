//
//  ViewController.swift
//  BeverBende
//
//  Created by J.W. Boekestijn on 2/18/19.
//  Copyright © 2019 Rug. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Game()
    
    
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
            runGame()
            button.setTitle("BeverBende!", for: .normal)
        default:
            //BeverBende
            break;
        }
    }
    
    @IBAction func drawPileClick(_ sender: UIButton) {
        game.drawPile.isClicked(position: -1)
    }
    
    @IBAction func discardPileClick(_ sender: UIButton) {
        game.discardPile.isClicked(position: -1)
    }
    
    @IBAction func playerClick(_ sender: UIButton) {
        for i in 0..<4{
            if playerButtons[i] == sender {
                game.playerDeck.isClicked(position: i)
            }
        }
    }
    
    @IBOutlet var playerButtons: [UIButton]!
    @IBOutlet var actr1Buttons: [UIButton]!
    @IBOutlet var actr2Buttons: [UIButton]!
    @IBOutlet var actr3Buttons: [UIButton]!
    
    @IBOutlet weak var discardPile: UIButton!
    @IBOutlet weak var drawPile: UIButton!
    
    @IBAction func score(_ sender: UIButton) {
        let alert = UIAlertController(title: "Score", message: "score", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    private func updateDeck(cardButton: [UIButton]!, deck: Deck) {
        for index in cardButton.indices {
            let button = cardButton[index]
            let card = deck.cards[button.tag]
            if card.isFaceUp {
                button.setTitle(String(card.value), for:UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
            if card.isHighlighted {
                // TODO: Card should become highlighted, for now just changes color
                button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
            if card.isClickable {
                button.isEnabled = true
            } else {
                button.isEnabled = false
            }
        }
    }
    
    private func updateDeck(cardButton: UIButton, deck: Deck, isDrawPile: Bool) {
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
            cardButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            if deck.cards[deck.cards.endIndex-1].isHighlighted {
                // TODO: Card should become highlighted, for now just changes color
                cardButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
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
        updateDeck(cardButton: playerButtons, deck: game.playerDeck)
        updateDeck(cardButton: actr1Buttons, deck: game.actrDeck1)
        updateDeck(cardButton: actr2Buttons, deck: game.actrDeck2)
        updateDeck(cardButton: actr3Buttons, deck: game.actrDeck3)

    }
   
    //TODO: add functions to do beverbende?
    
    private func runGame() {
        while !game.isFinished {
            // Player turn
            game.humanActions()
            updateViewFromModel()
            
            // ACT-R Model turns
            game.ACTRInit()
            updateViewFromModel()
            game.ACTRModelActions(model: game.modelPlayer1, deck: game.actrDeck1)
            updateViewFromModel()
            game.isFinished = true
            
//            game.ACTRInit()
//            updateViewFromModel()
//            game.ACTRModelActions(model: game.modelPlayer2, deck: game.actrDeck2)
//            updateViewFromModel()
//
//            game.ACTRInit()
//            updateViewFromModel()
//            game.ACTRModelActions(model: game.modelPlayer3, deck: game.actrDeck3)
//            updateViewFromModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game()
        updateViewFromModel()
        game.modelPlayer1.loadModel(fileName: "beverbende")
//        game.modelPlayer2.loadModel(fileName: "beverbende")
//        game.modelPlayer3.loadModel(fileName: "beverbende")
        game.modelPlayer1.loadedModel = "beverbende"
        
//        game.modelPlayer2.loadedModel = "beverbende"
//        game.modelPlayer3.loadedModel = "beverbende"
        // Do any additional setup after loading the view.
    }
}


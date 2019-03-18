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
    
//    @IBAction func touchCard(_ sender: Any) {
//        // card should be highlighted and actions can be performed
//    }
    
    // If start button is pressed, the outer two player cards must be placed downwards,
    // and the turn of the player should start, later this button should be used to call
    // BeverBende
    @IBAction func touchStartButton(_ sender: UIButton) {
        game.showOuterCards()
    }
    
    @IBOutlet var playerButtons: [UIButton]!
    @IBOutlet var actr1Buttons: [UIButton]!
    @IBOutlet var actr2Buttons: [UIButton]!
    @IBOutlet var actr3Buttons: [UIButton]!
    
    @IBOutlet weak var discardPile: UIButton!
    @IBOutlet weak var beverBende: UIButton!
    @IBOutlet weak var drawPile: UIButton!
    
    @IBAction func score(_ sender: UIButton) {
        let alert = UIAlertController(title: "Score", message: "score", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func updateDeck(cardButton: [UIButton]!, deck: Deck) {
        for index in cardButton.indices {
            let button = cardButton[index]
            let card = deck.cards[index]
            if card.isFaceUp {
                button.setTitle(String(card.value), for:UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private func updateDeck(cardButton: UIButton!, deck: Deck, isDrawPile: Bool) {
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
        }
    }
    
    // Update all different decks
    private func updateViewFromModel() {
        // TODO: Update the draw pile and the discard pile
        updateDeck(cardButton: drawPile, deck: game.drawPile, isDrawPile: true)
        updateDeck(cardButton: discardPile, deck: game.discardPile, isDrawPile: false)
        
        // TODO: Update player deck
        // TODO: Update ACT-R deck
        updateDeck(cardButton: playerButtons, deck: game.playerDeck)
        updateDeck(cardButton: actr1Buttons, deck: game.actrDeck1)
        updateDeck(cardButton: actr2Buttons, deck: game.actrDeck2)
        updateDeck(cardButton: actr3Buttons, deck: game.actrDeck3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Game()
        updateViewFromModel()
        game.modelPlayer1.loadModel(fileName: "beverbende")
        game.modelPlayer2.loadModel(fileName: "beverbende")
        game.modelPlayer3.loadModel(fileName: "beverbende")
        game.modelPlayer1.loadedModel = "beverbende"
        game.modelPlayer2.loadedModel = "beverbende"
        game.modelPlayer3.loadedModel = "beverbende"
        // Do any additional setup after loading the view.
    }
}


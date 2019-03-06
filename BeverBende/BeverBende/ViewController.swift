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
    
    @IBAction func touchCard(_ sender: Any) {
    }
    
    @IBOutlet var playerButtons: [UIButton]!
    @IBOutlet var actr1Buttons: [UIButton]!
    @IBOutlet var actr2Buttons: [UIButton]!
    @IBOutlet var actr3Buttons: [UIButton]!
    
    @IBOutlet weak var discard: UIButton!
    @IBOutlet weak var beverbende: UIButton!
    @IBOutlet weak var deck: UIButton!
    
    @IBAction func score(_ sender: UIButton) {
        let alert = UIAlertController(title: "Score", message: "score", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
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

    // TODO: create function that updates the discard and drawpile§
//    private func updateButton(cardButton: UIButton!, deck: Deck) {
//        let card = deck.cards
//    }
    
    // Update all different decks
    private func updateViewFromModel() {
        // TODO: Update player deck
        // TODO: Update ACT-R deck
        // TODO: Update the draw pile and the discard pile
        updateDeck(cardButton: playerButtons, deck: game.playerDeck)
        updateDeck(cardButton: actr1Buttons, deck: game.actrDeck1)
        updateDeck(cardButton: actr2Buttons, deck: game.actrDeck2)
        updateDeck(cardButton: actr3Buttons, deck: game.actrDeck3)
        
//        for index in playerButtons.indices {
//            let button = playerButtons[index]
//            let card = game.playerDeck.cards[index]
//            if card.isFaceUp {
//                button.setTitle(String(card.value), for:UIControl.State.normal)
//                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            } else {
//                button.setTitle("", for: UIControl.State.normal)
//                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Game()
        updateViewFromModel()
        // Do any additional setup after loading the view, typically from a nib.
    }
}


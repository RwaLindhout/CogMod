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
    
    @IBAction func draw(_ sender: UIButton) {
    }
    
    @IBAction func discard(_ sender: UIButton) {
    }
    
    @IBAction func beverbende(_ sender: UIButton) {
    }
    
    @IBAction func score(_ sender: UIButton) {
        let alert = UIAlertController(title: "Score", message: "score", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    // Update all different decks
    private func updateViewFromModel() {
        // TODO: Update player deck
        // TODO: Update ACT-R deck
        // TODO: Update the draw pile and the discard pile
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.deck.cards[index]
            if card.isFaceUp {
                button.setTitle(String(card.value), for:UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Game()
        updateViewFromModel()
        // Do any additional setup after loading the view, typically from a nib.
    }
}


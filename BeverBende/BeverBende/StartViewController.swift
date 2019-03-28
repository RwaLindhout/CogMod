//
//  StartViewController.swift
//  BeverBende
//
//  Created by R.W.A. Lindhout on 27/02/2019.
//  Copyright © 2019 Rug. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    let image1 = UIImage(named: "table.jpg")
    
    @IBAction func instructions(_ sender: MyButton) {
        let alert = UIAlertController(title: "Instructions", message: "In BeverBende, you get four cards, facing down. You only get to see the value of the outer two cards at the beginning. \nAfter seeing the cards, your goal is to get the lowest value for all your cards, by exchanging your cards with the Draw pile (right) or the Discard pile (left). When you think you have the lowest score, press the Beverbende! button. \nWhen it's your turn, the cards you can press get a blue edge. The opponent's actions are shown by highlighting the swapped cards in green.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func newGame(_ sender: MyButton) {
        performSegue(withIdentifier: "mySegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: image1!)
    }
}

//
//  StartViewController.swift
//  BeverBende
//
//  Created by R.W.A. Lindhout on 27/02/2019.
//  Copyright © 2019 Rug. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBAction func New_Game(_ sender: UIButton) {
        Game.init()
    }
    
    @IBAction func n_rounds(_ sender: UISlider) {
    }
    
    @IBAction func Instructions(_ sender: UIButton) {
        let alert = UIAlertController(title: "Instructions", message: "text", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }    
}

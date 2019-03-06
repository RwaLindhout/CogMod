//
//  StartViewController.swift
//  BeverBende
//
//  Created by R.W.A. Lindhout on 27/02/2019.
//  Copyright © 2019 Rug. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
   
    @IBAction func shortgame(_ sender: UIButton) {
    }
    
    @IBAction func mediumgame(_ sender: UIButton) {
    }
    
    @IBAction func longgame(_ sender: UIButton) {
    }
    
    @IBAction func Instructions(_ sender: UIButton) {
        let alert = UIAlertController(title: "Instructions", message: "text", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }    
}

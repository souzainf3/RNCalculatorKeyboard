//
//  ViewController.swift
//  RNCalculatorKeyboard
//
//  Created by Romilson Nunes on 11/06/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.inputView = CalculatorKeyboard.keyboard
    }


}


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
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.inputView = CalculatorKeyboard.keyboard
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField.becomeFirstResponder()
    }

    
    // MARK: - Actions
    
    @IBAction func themeValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // Light
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .light

        case 1: // Dark
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .dark

        case 2: // Custom 1
            let theme = ThemeType.ColorTheme(
                backgroundColor: #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.2156862745, alpha: 1),
                numbersTextColor: #colorLiteral(red: 0.7647058824, green: 0.7529411765, blue: 0.7921568627, alpha: 1),
                numbersBackgroundColor: #colorLiteral(red: 0.1960784314, green: 0.2235294118, blue: 0.2980392157, alpha: 1),
                operationsTextColor: #colorLiteral(red: 0.7647058824, green: 0.7529411765, blue: 0.7921568627, alpha: 1),
                operationsBackgroundColor: #colorLiteral(red: 0.2901960784, green: 0.3137254902, blue: 0.4, alpha: 1),
                equalTextColor: #colorLiteral(red: 0.7647058824, green: 0.7529411765, blue: 0.7921568627, alpha: 1),
                equalBackgroundColor: #colorLiteral(red: 0.1176470588, green: 0.8352941176, blue: 0.6039215686, alpha: 1)
            )
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .custom(theme: theme)

        default: // Custom 2
            let theme = ThemeType.ColorTheme(
                backgroundColor: #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.2156862745, alpha: 1),
                numbersTextColor: #colorLiteral(red: 0.7647058824, green: 0.7529411765, blue: 0.7921568627, alpha: 1),
                numbersBackgroundColor: #colorLiteral(red: 0.2352941176, green: 0.2588235294, blue: 0.3215686275, alpha: 1),
                operationsTextColor: #colorLiteral(red: 0.02745098039, green: 0.3450980392, blue: 0.7019607843, alpha: 1),
                operationsBackgroundColor: #colorLiteral(red: 0.1058823529, green: 0.1411764706, blue: 0.1764705882, alpha: 1),
                equalTextColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                equalBackgroundColor: #colorLiteral(red: 0.02745098039, green: 0.3450980392, blue: 0.7019607843, alpha: 1)
            )
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .custom(theme: theme)
        }
    }
}


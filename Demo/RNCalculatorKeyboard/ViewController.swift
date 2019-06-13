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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField.becomeFirstResponder()
    }

    @IBAction func themeValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // Light
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .light

        case 1: // Dark
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .dark

        case 2: // Custom 1
            let theme = ThemeType.ColorTheme(
                backgroundColor: color(40, 44, 55),
                numbersTextColor: color(195, 192, 202),
                numbersBackgroundColor: color(50, 57, 76),
                operationsTextColor: color(195, 192, 202),
                operationsBackgroundColor: color(74, 80, 102),
                equalBackgroundColor: color(30, 213, 154),
                equalTextColor: color(195, 192, 202)
            )
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .custom(theme: theme)

        default: // Custom 2
            let theme = ThemeType.ColorTheme(
                backgroundColor: color(40, 44, 55),
                numbersTextColor: color(195, 192, 202),
                numbersBackgroundColor: color(60, 66, 82),
                operationsTextColor: color(7, 88, 179),
                operationsBackgroundColor: color(27, 36, 45),
                equalBackgroundColor: color(7, 88, 179),
                equalTextColor: .white
            )
            (self.textField.inputView as? CalculatorKeyboard)?.themeType = .custom(theme: theme)
        }
    }
    
    private func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}


//
//  CalculatorKeyboard.swift
//  RNCalculatorKeyboard
//
//  Created by Romilson Nunes on 11/06/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

public protocol CalculatorKeyboardDelegate: class {
    func calculatorKeyboard(_ keyboard: CalculatorKeyboard, didChangeValue value: String)
}

public enum ThemeType {
    case light
    case dark
    case custom(theme: ColorTheme)
    
    public struct ColorTheme {
        let backgroundColor: UIColor
        let numbersTextColor: UIColor
        let numbersBackgroundColor: UIColor
        let operationsTextColor: UIColor
        let operationsBackgroundColor: UIColor
        let equalTextColor: UIColor
        let equalBackgroundColor: UIColor
    }
    
    var theme: ColorTheme {
        switch self {
        case .light:
            return ColorTheme(
                backgroundColor: .white,
                numbersTextColor: .black,
                numbersBackgroundColor: UIColor(white: 0.97, alpha: 1.0),
                operationsTextColor: .white,
                operationsBackgroundColor: UIColor(white: 0.75, alpha: 1.0),
                equalTextColor: .white,
                equalBackgroundColor: UIColor(red:0.96, green:0.5, blue:0, alpha:1)
            )
        case .dark:
            return ColorTheme(
                backgroundColor: UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1),
                numbersTextColor: .white,
                numbersBackgroundColor: UIColor(red:0.40, green:0.40, blue:0.40, alpha:1),
                operationsTextColor: .white,
                operationsBackgroundColor: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1),
                equalTextColor: .white,
                equalBackgroundColor: UIColor(red:0.96, green:0.5, blue:0, alpha:1)
            )
        case .custom(let theme):
            return theme
        }
    }
}

enum CalculatorKey: Int {
    case zero = 1
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case decimal
    case clear
    case delete
    case multiply
    case divide
    case subtract
    case add
    case equal
}

open class CalculatorKeyboard: UIView {
    
    open weak var delegate: CalculatorKeyboardDelegate?
    
    open var themeType: ThemeType = .light {
        didSet {
            adjustLayout()
        }
    }
    
    open var isDecimalEnabled = true {
        didSet {
            configureDecimal()
        }
    }
    
    fileprivate var processor = CalculatorProcessor()
    
    
    // MARK: - Class Propertie
    
    static var keyboard: CalculatorKeyboard {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "CalculatorKeyboard", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! CalculatorKeyboard
    }
    
    
    // MARK: - Initializer
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    // MARK: - Overrides
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let key = CalculatorKey(rawValue: sender.tag) else {
            return
        }
        
        UIDevice.current.playInputClick()

        let output: String
        
        switch key {
        case .zero,.one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            output = processor.insertDigit(sender.tag-1)
            
        case .decimal:
            output = processor.addDecimal()
            
        case .clear:
            output = processor.clearAll()
            
        case .delete:
            output = processor.deleteLastDigit()
            
        case .add, .subtract, .multiply, .divide:
            output = processor.storeOperator(sender.tag)
            
        case .equal:
            output = processor.computeFinalValue()
        }
        
        delegate?.calculatorKeyboard(self, didChangeValue: output)
        updateTextInput(with: output)
    }
    
    
    // MARK: - Private
    
    private func configureDecimal() {
        processor.automaticDecimal = !isDecimalEnabled
        if let decimalButton = viewWithTag(CalculatorKey.decimal.rawValue) as? UIButton {
            decimalButton.isEnabled = self.isDecimalEnabled
        }
    }
    
    private func adjustLayout() {
        configureDecimal()
        
        let theme = themeType.theme
        
        // Numbers
        for i in CalculatorKey.zero.rawValue...CalculatorKey.decimal.rawValue {
            if let button = self.viewWithTag(i) as? UIButton {
                configureButton(button, titleColor: theme.numbersTextColor, backgroundColor: theme.numbersBackgroundColor)
            }
        }
        
        // Operators
        for i in CalculatorKey.clear.rawValue...CalculatorKey.add.rawValue {
            if let button = self.viewWithTag(i) as? UIButton {
                configureButton(button, titleColor: theme.operationsTextColor, backgroundColor: theme.operationsBackgroundColor)
            }
        }
        
        // Equal
        if let button = self.viewWithTag(CalculatorKey.equal.rawValue) as? UIButton {
            configureButton(button, titleColor: theme.equalTextColor, backgroundColor: theme.equalBackgroundColor)
        }
        
        self.backgroundColor = theme.backgroundColor
    }
    
    
    private func configureButton(_ button: UIButton, titleColor: UIColor, backgroundColor: UIColor) {
        button.tintColor = titleColor
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundColor(backgroundColor, for: .normal)
    }
    
    private func updateTextInput(with text: String) {
        guard let responder = UIResponder.current else {
            return
        }
        
        guard let textInput = responder as? UITextInput else {
            return
        }
        
        if let range = textInput.textRange(from: textInput.beginningOfDocument, to: textInput.endOfDocument) {
            textInput.replace(range, withText: text)
        } else {
            textInput.insertText(text)
        }
    }
}

extension CalculatorKeyboard: UIInputViewAudioFeedback {
    /// Required for playing system click sound
    public var enableInputClicksWhenVisible: Bool { return true }
}


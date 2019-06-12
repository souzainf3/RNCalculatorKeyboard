//
//  CalculatorKeyboard.swift
//  RNCalculatorKeyboard
//
//  Created by Romilson Nunes on 11/06/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

public protocol CalculatorDelegate: class {
    func calculatorKeyboard(_ calculator: CalculatorKeyboard, didChangeValue value: String)
}

public enum ThemeType {
    case light
    case dark
    case custom(theme: Theme)
    
    public struct Theme {
        var numbersTextColor: UIColor
        var numbersBackgroundColor: UIColor
        var operationsTextColor: UIColor
        var operationsBackgroundColor: UIColor
        var equalBackgroundColor: UIColor
        var equalTextColor: UIColor
    }
    
    var theme: Theme {
        switch self {
        case .light:
            return Theme(numbersTextColor: .black,
                         numbersBackgroundColor: UIColor(white: 0.97, alpha: 1.0),
                         operationsTextColor: .white,
                         operationsBackgroundColor: UIColor(white: 0.75, alpha: 1.0),
                         equalBackgroundColor: UIColor(red:0.96, green:0.5, blue:0, alpha:1),
                         equalTextColor: .white)
        case .dark:
            return Theme(numbersTextColor: .black,
                         numbersBackgroundColor: UIColor(white: 0.97, alpha: 1.0),
                         operationsTextColor: .white,
                         operationsBackgroundColor: UIColor(white: 0.75, alpha: 1.0),
                         equalBackgroundColor: UIColor(red:0.96, green:0.5, blue:0, alpha:1),
                         equalTextColor: .white)
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
    
    open weak var delegate: CalculatorDelegate?
    
    open var themeType: ThemeType = .light {
        didSet {
            adjustLayout()
        }
    }
    
    open var showDecimal = true {
        didSet {
            processor.automaticDecimal = !showDecimal
            adjustLayout()
        }
    }
    
    fileprivate var processor = CalculatorProcessor()
    
    @IBOutlet weak var zeroDistanceConstraint: NSLayoutConstraint!
    
    
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
            output = processor.storeOperand(sender.tag-1)
            
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
    
    private func adjustLayout() {
        let theme = themeType.theme
        
        for i in 1...CalculatorKey.decimal.rawValue {
            if let button = self.viewWithTag(i) as? UIButton {
                button.tintColor = theme.numbersBackgroundColor
                button.setTitleColor(theme.numbersTextColor, for: .normal)
            }
        }
        
        for i in CalculatorKey.clear.rawValue...CalculatorKey.add.rawValue {
            if let button = self.viewWithTag(i) as? UIButton {
                button.tintColor = theme.operationsBackgroundColor
                button.setTitleColor(theme.operationsTextColor, for: .normal)
                button.tintColor = theme.operationsTextColor
            }
        }
        
        if let button = self.viewWithTag(CalculatorKey.equal.rawValue) as? UIButton {
            button.tintColor = theme.equalBackgroundColor
            button.setTitleColor(theme.equalTextColor, for: .normal)
        }
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

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    public static var current: UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}

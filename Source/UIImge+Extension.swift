//
//  UIImge+Extension.swift
//  RNCalculatorKeyboard
//
//  Created by Romilson Nunes on 13/06/19.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit


extension UIButton {
    // https://spin.atomicobject.com/2018/04/25/uibutton-background-color/
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}

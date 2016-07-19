
//
//  customButton.swift
//  meetupSample
//
//  Created by Tendai Prince Dzonga on 5/26/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

@IBDesignable class customButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!) ?? .clearColor()
        }
        set {
            layer.borderColor = newValue.CGColor
            layer.borderWidth = 5
        }
        
    }
    
    @IBInspectable var radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

}

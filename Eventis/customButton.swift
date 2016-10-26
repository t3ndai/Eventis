//
//  CustomButton.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 8/2/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var borderColor: UIColor = UIColor.blueColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var  borderWidth: CGFloat = 2.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }

}

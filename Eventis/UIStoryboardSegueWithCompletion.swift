//
//  UIStoryboardSegueWithCompletion.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 7/15/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import UIKit

class UIStoryboardSegueWithCompletion: UIStoryboardSegue {
    
    var completion: (() -> Void)?
    
    override func perform() {
        super.perform()
        if let completion = completion {
            completion()
        }
    }

}

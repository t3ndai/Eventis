//
//  User.swift
//  Eventis
//
//  Created by Tendai Prince Dzonga on 6/18/16.
//  Copyright © 2016 Tendai Prince Dzonga. All rights reserved.
//

import Foundation

struct User {
    
    struct Host {
        var eventID: String
        var photoURL: NSURL?
        var happening: Bool!
    }
    
    struct Comment {
        var message: String
        var photo: NSURL?
        var name: String?
    }
    
}
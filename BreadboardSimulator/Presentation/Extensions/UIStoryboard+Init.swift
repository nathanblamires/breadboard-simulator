//
//  UIStoryboard+Init.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 15/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    convenience init(named name: Name) {
        self.init(name: name.rawValue, bundle: Bundle.main)
    }
    
    enum Name: String {
        case home = "Home"
    }
}

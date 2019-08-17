//
//  UIColor+CustomColors.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 15/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(named name: Name) {
        self.init(named: name.rawValue)!
    }
    
    enum Name: String {
        case doNotUse = ""
    }
}

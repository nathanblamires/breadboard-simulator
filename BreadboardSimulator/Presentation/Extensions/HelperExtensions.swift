//
//  HelperExtensions.swift
//  8BitSimulator
//
//  Created by Nathan Blamires on 9/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import UIKit

extension UInt8 {
    
    func asBinaryText() -> String {
        return String(self, radix: 2).pad(toSize: 8)
    }
    
    func asDecimalText() -> String {
        return "\(self)"
    }
}

extension String {
    
    func pad(toSize: Int) -> String {
        var padded = self
        for _ in 0..<(toSize - count) {
            padded = "0" + padded
        }
        return padded
    }
}

extension UILabel {
    
    convenience init(text: String) {
        self.init()
        self.text = text
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
    }
}

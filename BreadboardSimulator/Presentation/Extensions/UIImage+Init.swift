//
//  UIImage+Init.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 15/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import UIKit

extension UIImage {

    convenience init(assetName: Name) {
        self.init(named: assetName.rawValue)!
    }
    
    enum Name: String {
        case appIcon = "AppIcon"
    }
}

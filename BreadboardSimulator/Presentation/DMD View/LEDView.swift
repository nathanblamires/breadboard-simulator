//
//  LEDView.swift
//  8BitSimulator
//
//  Created by Nathan Blamires on 2/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import UIKit

class LEDView: UIView {
    
    private let offColour: UIColor = .black
    private let onColour: UIColor = .red
    
    var isOn: Bool {
        return backgroundColor == onColour
    }
    
    func toggle(on: Bool) {
        backgroundColor = on ? onColour : offColour
    }
    
    static func create() -> LEDView {
        let view = LEDView()
        view.toggle(on: false)
        return view
    }
}

//
//  Step.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 1/7/18.
//  Copyright © 2018 Nathan Blamires. All rights reserved.
//

import Foundation

enum Step: UInt8 {
    
    static let numberOfSteps = 6
    
    case step1 = 0
    case step2 = 1
    case step3 = 2
    case step4 = 3
    case step5 = 4
    case step6 = 5
    
    var previous: Step {
        return Step(rawValue: rawValue - 1) ?? .step6
    }
    
    var next: Step {
        return Step(rawValue: rawValue + 1) ?? .step1
    }
}

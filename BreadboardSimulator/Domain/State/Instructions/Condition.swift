//
//  Condition.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 9/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

enum Condition: UInt8, Equatable, Codable {
    case noCondition = 0
    case aluOverflow = 1
}

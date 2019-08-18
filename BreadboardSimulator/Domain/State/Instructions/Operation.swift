//
//  Operation.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 1/7/18.
//  Copyright © 2018 Nathan Blamires. All rights reserved.
//

import Foundation

enum Operation: UInt8, CaseIterable, Equatable, Codable {
    case noOp = 0
    case store = 1
    case load = 2
    case loadI = 3
    case add = 4
    case addI = 5
    case sub = 6
    case subI = 7
    case jump = 8
    case jumpI = 9
    case out = 10
    case halt = 15
}

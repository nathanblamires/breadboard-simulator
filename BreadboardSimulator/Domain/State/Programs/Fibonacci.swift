//
//  Fibonacci.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 12/1/20.
//  Copyright © 2020 nathanblamires. All rights reserved.
//

import Foundation

struct Fibonacci: Program, Equatable {
    
    var instructions: [Instruction] = {
        return [
            Instruction(operation: .loadI, register: .r2, condition: .noCondition, payload: 0),
            Instruction(operation: .loadI, register: .r3, condition: .noCondition, payload: 1),
            Instruction(operation: .store, register: .r2, condition: .noCondition, payload: 0),
            Instruction(operation: .store, register: .r3, condition: .noCondition, payload: 1),
            Instruction(operation: .load, register: .r1, condition: .noCondition, payload: 0),
            Instruction(operation: .load, register: .r2, condition: .noCondition, payload: 1),
            Instruction(operation: .add, register: .r3, condition: .noCondition, payload: 1),
            Instruction(operation: .jumpI, register: .r4, condition: .aluOverflow, payload: 0),
            Instruction(operation: .out, register: .r3, condition: .noCondition, payload: 0),
            Instruction(operation: .jumpI, register: .r4, condition: .noCondition, payload: 2)
        ]
    }()
}

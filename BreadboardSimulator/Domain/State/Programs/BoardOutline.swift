//
//  BoardOutline.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 18/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct BoardOutline: Program, Equatable {
    
    var instructions: [Instruction] = {
        var instructions: [Instruction] = []
        for (address, value) in BoardOutline.values {
            instructions.append(contentsOf: [
                Instruction(details: .init(operation: .loadI, register: .r1, condition: .noCondition), payload: value),
                Instruction(details: .init(operation: .store, register: .r1, condition: .noCondition), payload: address + 128)
            ])
        }
        return instructions
    }()
    
    static var values: [UInt8: UInt8] {
        
        return [
            // top
            2: 0b0000_0111,
            3: 0b0000_0100,
            4: 0b0000_0100,
            5: 0b0000_0100,
            6: 0b0000_0100,
            7: 0b0000_0100,
            8: 0b0000_0100,
            9: 0b0000_0100,
            10: 0b0000_0100,
            11: 0b0000_0100,
            12: 0b0000_0100,
            13: 0b0000_0111,
            // middle
            18: 0b1111_1111,
            29: 0b1111_1111,
            34: 0b1111_1111,
            45: 0b1111_1111,
            // bottom
            50: 0b1110_0000,
            51: 0b0010_0000,
            52: 0b0010_0000,
            53: 0b0010_0000,
            54: 0b0010_0000,
            55: 0b0010_0000,
            56: 0b0010_0000,
            57: 0b0010_0000,
            58: 0b0010_0000,
            59: 0b0010_0000,
            60: 0b0010_0000,
            61: 0b1110_0000
        ]
    }
}

//let instructions: [Instruction] = [
//    Instruction.loadI(register: .r3, condition: .noCondition, value: 1),
//    Instruction.loadI(register: .r1, condition: .noCondition, value: 1),
//    Instruction.store(register: .r3, condition: .noCondition, address: 0),
//    Instruction.store(register: .r1, condition: .noCondition, address: 1),
//    Instruction.load(register: .r1, condition: .noCondition, address: 0),
//    Instruction.add(condition: .noCondition, address: 1),
//    Instruction.jumpI(condition: .aluOverflow, value: 0),
//    Instruction.out(register: .r3, condition: .noCondition),
//    Instruction.jumpI(condition: .noCondition, value: 2)
//]

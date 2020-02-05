//
//  Fibonacci.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 12/1/20.
//  Copyright © 2020 nathanblamires. All rights reserved.
//

import Foundation

struct Fibonacci: Program, Equatable {
    
    var instructions: [Instruction] = [
        .load(0, intoRegister: .r2),
        .load(1, intoRegister: .r3),
        .store(valueInRegister: .r2, atMemoryAddress: 0),
        .store(valueInRegister: .r3, atMemoryAddress: 1),
        .load(valueAtMemoryAddress: 0, intoRegister: .r1),
        .sumValueInReg1(withValueAtMemoryAddress: 1),
        .jump(toInstructionAdress: 0, given: .aluOverflow),
        .output(valueInRegister: .r3),
        .jump(toInstructionAdress: 2)
    ]
    
    var verboseInstructions: [Instruction] = [
        Instruction(operation: .loadI, register: .r2, condition: .noCondition, payload: 0),
        Instruction(operation: .loadI, register: .r3, condition: .noCondition, payload: 1),
        Instruction(operation: .store, register: .r2, condition: .noCondition, payload: 0),
        Instruction(operation: .store, register: .r3, condition: .noCondition, payload: 1),
        Instruction(operation: .load, register: .r1, condition: .noCondition, payload: 0),
        Instruction(operation: .add, register: .r3, condition: .noCondition, payload: 1),
        Instruction(operation: .jumpI, register: .r4, condition: .aluOverflow, payload: 0),
        Instruction(operation: .out, register: .r3, condition: .noCondition, payload: 0),
        Instruction(operation: .jumpI, register: .r4, condition: .noCondition, payload: 2)
    ]
}

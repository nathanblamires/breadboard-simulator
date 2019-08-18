//
//  Instruction.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 5/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

enum Instruction {
    case noOp
    case store(register: Register, condition: Condition, address: UInt8?)
    case load(register: Register, condition: Condition, address: UInt8?)
    case loadI(register: Register, condition: Condition, value: UInt8?)
    case add(condition: Condition, address: UInt8?)
    case addI(condition: Condition, value: UInt8?)
    case sub(condition: Condition, address: UInt8?)
    case subI(condition: Condition, value: UInt8?)
    case jump(condition: Condition, address: UInt8?)
    case jumpI(condition: Condition, value: UInt8?)
    case out(register: Register, condition: Condition)
    case halt
}

// MARK:- Data Accessors

extension Instruction {
    
    var operation: Operation {
        switch self {
        case .noOp: return .noOp
        case .store(register: _, condition: _, address: _): return .store
        case .load(register: _, condition: _, address: _): return .load
        case .loadI(register: _, condition: _, value: _): return .loadI
        case .add(condition: _, address: _): return .add
        case .addI(condition: _, value: _): return .addI
        case .sub(condition: _, address: _): return .sub
        case .subI(condition: _, value: _): return .subI
        case .jump(condition: _, address: _): return .jump
        case .jumpI(condition: _, value: _): return .jumpI
        case .out(register: _, condition: _): return .out
        case .halt: return .halt
        }
    }
    
    var register: Register? {
        switch self {
        case .noOp: return nil
        case .store(let register, condition: _, address: _): return register
        case .load(let register, condition: _, address: _): return register
        case .loadI(let register, condition: _, value: _): return register
        case .add(condition: _, address: _): return nil
        case .addI(condition: _, value: _): return nil
        case .sub(condition: _, address: _): return nil
        case .subI(condition: _, value: _): return nil
        case .jump(condition: _, address: _): return nil
        case .jumpI(condition: _, value: _): return nil
        case .out(let register, condition: _): return register
        case .halt: return nil
        }
    }
    
    var condition: Condition? {
        switch self {
        case .noOp: return nil
        case .store(register: _, let condition, address: _): return condition
        case .load(register: _, let condition, address: _): return condition
        case .loadI(register: _, let condition, value: _): return condition
        case .add(let condition, address: _): return condition
        case .addI(let condition, value: _): return condition
        case .sub(let condition, address: _): return condition
        case .subI(let condition, value: _): return condition
        case .jump(let condition, address: _): return condition
        case .jumpI(let condition, value: _): return condition
        case .out(register: _, let condition): return condition
        case .halt: return nil
        }
    }
    
    var payload: UInt8? {
        switch self {
        case .noOp: return nil
        case .store(register: _, condition: _, let address): return address
        case .load(register: _, condition: _, let address): return address
        case .loadI(register: _, condition: _, let value): return value
        case .add(condition: _, let address): return address
        case .addI(condition: _, let value): return value
        case .sub(condition: _, let address): return address
        case .subI(condition: _, let value): return value
        case .jump(condition: _, let address): return address
        case .jumpI(condition: _, let value): return value
        case .out(register: _, condition: _): return nil
        case .halt: return nil
        }
    }
    
    var machineCode: UInt8 {
        let operationValue = (operation.opcode << 4) & 0b1111_0000
        let registerValue = ((register?.rawValue ?? 0) << 2) & 0b0000_1100
        let conditionValue = ((condition?.rawValue ?? 0) << 1) & 0b0000_0010
        return operationValue | registerValue | conditionValue
    }
}

// MARK:- Initialiser

extension Instruction {
    
    init(machineCode: UInt8, payload: UInt8? = nil) throws {
        
        let opcode = (machineCode & 0xf0) >> 4
        let registerRawValue = (machineCode & 0b0000_1100) >> 2
        let conditionRawValue = (machineCode & 0b0000_0010) >> 1
        
        guard
            let operation = Operation(rawValue: opcode),
            let register = Register(rawValue: registerRawValue),
            let condition = Condition(rawValue: conditionRawValue)
        else { throw InstructionError.invalidMachineCode }
        
        switch operation {
        case .noOp: self = .noOp
        case .store: self = .store(register: register, condition: condition, address: payload)
        case .load: self = .load(register: register, condition: condition, address: payload)
        case .loadI: self = .loadI(register: register, condition: condition, value: payload)
        case .add: self = .add(condition: condition, address: payload)
        case .addI: self = .addI(condition: condition, value: payload)
        case .sub: self = .sub(condition: condition, address: payload)
        case .subI: self = .subI(condition: condition, value: payload)
        case .jump: self = .jump(condition: condition, address: payload)
        case .jumpI: self = .jumpI(condition: condition, value: payload)
        case .out: self = .out(register: register, condition: condition)
        case .halt: self = .halt
        }
    }
}

enum InstructionError: Error {
    case invalidMachineCode
}

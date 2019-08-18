//
//  Instruction.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 5/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct Instruction: Equatable, Codable {
    let details: Details
    let payload: UInt8
    struct Details: Equatable, Codable {
        let operation: Operation
        let register: Register
        let condition: Condition
    }
}

extension Instruction {
    
    init(machineCode: UInt8, payload: UInt8) throws {
        let detail = try Instruction.Details(machineCode: machineCode)
        self = Instruction(details: detail, payload: payload)
    }
}

extension Instruction.Details {
    
    init(machineCode: UInt8) throws {
        let opcode = (machineCode & 0xf0) >> 4
        let registerRawValue = (machineCode & 0b0000_1100) >> 2
        let conditionRawValue = (machineCode & 0b0000_0010) >> 1
        guard
            let operation = Operation(rawValue: opcode),
            let register = Register(rawValue: registerRawValue),
            let condition = Condition(rawValue: conditionRawValue)
        else { throw InstructionError.invalidMachineCode }
        self = Instruction.Details(operation: operation, register: register, condition: condition)
    }
}

extension Instruction.Details {
    
    var machineCode: UInt8 {
        let operationValue = (operation.rawValue << 4) & 0b1111_0000
        let registerValue = ((register.rawValue) << 2) & 0b0000_1100
        let conditionValue = ((condition.rawValue) << 1) & 0b0000_0010
        return operationValue | registerValue | conditionValue
    }
}

enum InstructionError: Error {
    case invalidMachineCode
}

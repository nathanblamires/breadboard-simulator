//
//  Instruction.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 5/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct Instruction: Equatable, Codable {
    
    let operation: Operation
    let register: Register?
    let condition: Condition
    let payload: UInt8?
    
    init(operation: Operation, register: Register? = nil, condition: Condition = .noCondition, payload: UInt8? = nil) {
        self.operation = operation
        self.register = register
        self.condition = condition
        self.payload = payload
    }
    
    init(upperByte: UInt8, lowerByte: UInt8? = nil) throws {
        let opcode = (upperByte & 0xf0) >> 4
        let registerRawValue = (upperByte & 0b0000_1100) >> 2
        let conditionRawValue = (upperByte & 0b0000_0010) >> 1
        guard
            let operation = Operation(rawValue: opcode),
            let register = Register(rawValue: registerRawValue),
            let condition = Condition(rawValue: conditionRawValue)
        else { throw Error.invalidMachineCode }
        self.operation = operation
        self.register = register
        self.condition = condition
        self.payload = lowerByte
    }
    
    var upperByte: UInt8 {
        let operationValue = (operation.rawValue << 4) & 0b1111_0000
        let registerValue = ((register?.rawValue ?? 0) << 2) & 0b0000_1100
        let conditionValue = ((condition.rawValue) << 1) & 0b0000_0010
        return operationValue | registerValue | conditionValue
    }
    
    var lowerByte: UInt8 {
        payload ?? 0
    }
    
    enum Error: Swift.Error {
        case invalidMachineCode
    }
}

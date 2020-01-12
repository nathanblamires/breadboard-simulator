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

// MARK:- Convenience Methods

extension Instruction {
    
    static var noOp = Instruction(operation: .noOp)
    
    /// Stores the value in the specified register in RAM at the specified address, given any specified condition is true
    static func store(valueInRegister register: Register, inMemoryAddress address: UInt8, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .store, register: register, condition: condition, payload: address)
    }
    
    /// Loads the value contained at the specified RAM address into the specified register, given any specified condition is true
    static func load(valueAtMemoryAddress address: UInt8, intoRegister register: Register, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .load, register: register, condition: condition, payload: address)
    }
    
    /// Loads the passed value into the specified register, given any specified condition is true
    static func load(_ value: UInt8, intoRegister register: Register, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .loadI, register: register, condition: condition, payload: value)
    }
    
    /// Loads the value at the specified RAM address into `reg2`, then adds its value to the value in `reg1`, and puts the result in `reg3`, given any specified condition is true
    static func sumValueInReg1(withValueAtMemoryAddress address: UInt8, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .add, register: nil, condition: condition, payload: address)
    }
    
    /// Loads the specified value into `reg2`, then adds its value to the value in `reg1`, and puts the result in `reg3`, given any specified condition is true
    static func sumValueInReg1(withValue value: UInt8, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .addI, register: nil, condition: condition, payload: value)
    }
    
    /// Loads the value at the specified RAM address into `reg2`, then subtracts it from the value in `reg1`, and puts the result in `reg3`, given any specified condition is true
    static func subtractFromValueInReg1(valueInMemoryAddress address: UInt8, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .sub, register: nil, condition: condition, payload: address)
    }
    
    /// Loads the specified value into `reg2`, then subtracts it from the value in `reg1`, and puts the result in `reg3`, given any specified condition is true
    static func subtractFromValueInReg1(_ value: UInt8, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .subI, register: nil, condition: condition, payload: value)
    }
    
    /// Jumps to the instruction address stored in the specified memory address, given any specified condition is true
    static func jump(toInstructionAdressStoredAtMemoryAddress addressOfAddress: UInt8, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .jump, register: nil, condition: condition, payload: addressOfAddress)
    }
    
    /// Jumps to the specified instruction address, given any specified condition is true
    static func jump(toInstructionAdress address: UInt8, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .jumpI, register: nil, condition: condition, payload: address)
    }
    
    /// Outputs the value stored in the specified register to the output display, given any specified condition is true
    static func output(valueInRegister register: Register, given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .out, register: register, condition: condition, payload: nil)
    }
    
    /// Stops the running program, given any specified condition is true
    static func halt(given condition: Condition = .noCondition) -> Instruction {
        Instruction(operation: .halt, register: nil, condition: condition, payload: nil)
    }
}

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
    
    @ProgramBuilder
    func functionBuilderProgram() -> ProgramCode {
        
        Instruction.load(2, intoRegister: .r1)
        Instruction.store(valueInRegister: .r1, atMemoryAddress: 0)
        
        ForLoop(5) {
            Instruction.load(valueAtMemoryAddress: 0, intoRegister: .r1)
            Instruction.sumValueInReg1(withValue: 2)
            Instruction.output(valueInRegister: .r3)
            Instruction.store(valueInRegister: .r3, atMemoryAddress: 0)
        }
    }
    
    func extractInstructions(from program: ProgramCode) -> [Instruction] {
        if let instruction = program as? Instruction {
            return [instruction]
        }
        if let block = program as? ProgramBlock {
            return block.items.flatMap { extractInstructions(from: $0) }
        }
        return []
    }
    
    func testProgram() -> [Instruction] {
        let program = functionBuilderProgram()
        return extractInstructions(from: program)
    }
    
    func ForLoop(_ count: UInt8, @ProgramBuilder code: ()->(ProgramCode)) -> ProgramCode {
        
        guard count > 0 else { return ProgramBlock(items: []) }
        
        var instructions: [ProgramCode] = []
        
        // store values in r1, r2 r3
        instructions.append(Instruction.store(valueInRegister: .r1, atMemoryAddress: 0xf1))
        instructions.append(Instruction.store(valueInRegister: .r2, atMemoryAddress: 0xf2))
        instructions.append(Instruction.store(valueInRegister: .r3, atMemoryAddress: 0xf3))
        
        // set and store starting count
        instructions.append(Instruction.load(UInt8.max - count + 1, intoRegister: .r1))
        instructions.append(Instruction.store(valueInRegister: .r1, atMemoryAddress: 0xf5))
        
        // retrieve count
        instructions.append(Instruction.load(valueAtMemoryAddress: 0xf5, intoRegister: .r1))
        
        instructions.append(code())
        
        // sum count and jump if overflow
        instructions.append(Instruction.sumValueInReg1(withValue: 1))
        instructions.append(Instruction.halt(given: .aluOverflow))
        instructions.append(Instruction.store(valueInRegister: .r3, atMemoryAddress: 0xf5))
        
        instructions.append(Instruction.jump(toInstructionAdress: 5))
        
        return ProgramBlock(items: instructions)
    }
    
    func If(_ register: Register, _ check: IfCheck, _ value: UInt8, @ProgramBuilder code: ()->(ProgramCode)) -> ProgramCode {
        var instructions: [ProgramCode] = []
//        instructions.append(Instruction.load(UInt8.max - count + 1, intoRegister: .r1))
//        instructions.append(code())
//        instructions.append(Instruction.sumValueInReg1(withValue: 1))
//        instructions.append(Instruction.jump(toInstructionAdress: 0, given: .aluOverflow))
        return ProgramBlock(items: instructions)
    }
    
    enum IfCheck {
        case equals
    }
}

protocol ProgramCode {}
extension Instruction: ProgramCode {}
struct ProgramBlock: ProgramCode {
    let items: [ProgramCode]
}

@_functionBuilder
class ProgramBuilder {

    static func buildBlock(_ children: ProgramCode...) -> ProgramCode {
        ProgramBlock(items: children)
    }
}

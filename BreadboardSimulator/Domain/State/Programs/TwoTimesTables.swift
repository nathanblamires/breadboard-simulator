//
//  Fibonacci.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 12/1/20.
//  Copyright © 2020 nathanblamires. All rights reserved.
//

import Foundation

struct TwoTimesTables: Program, Equatable {
    
    var instructions: [Instruction] {
        return [
            // LOOPING LOGIC: Set and store starting count (15)
            Instruction.load(UInt8.max - 15 + 1, intoRegister: .r1),
            Instruction.store(valueInRegister: .r1, atMemoryAddress: 25),

            // load, store and output 0 to start with
            Instruction.load(0, intoRegister: .r1),
            Instruction.store(valueInRegister: .r1, atMemoryAddress: 0),
            Instruction.output(valueInRegister: .r1),

            // START OF LOOP

            // Add 2, output the value and store new sum in memory
            Instruction.load(valueAtMemoryAddress: 0, intoRegister: .r1),
            Instruction.sumValueInReg1(withValue: 2),
            Instruction.output(valueInRegister: .r3),
            Instruction.store(valueInRegister: .r3, atMemoryAddress: 0),

            // END OF LOOP

            // LOOPING LOGIC: Add to the counter
            Instruction.load(valueAtMemoryAddress: 25, intoRegister: .r1),
            Instruction.sumValueInReg1(withValue: 1),
            Instruction.store(valueInRegister: .r3, atMemoryAddress: 25),

            // Stop program if done
            Instruction.halt(given: .aluOverflow),

            // Go back to start of loop
            Instruction.jump(toInstructionAdress: 5)
        ]
    }
    
//    var instructions: [Instruction] {
//        countTo30().instructions
//    }
//
//    @ProgramBuilder
//    func countTo30() -> ProgramCode {
//
//        Instruction.load(0, intoRegister: .r1)
//        Instruction.store(valueInRegister: .r1, atMemoryAddress: 0)
//        Instruction.output(valueInRegister: .r1)
//
//        ForLoop(15) {
//            Instruction.load(valueAtMemoryAddress: 0, intoRegister: .r1)
//            Instruction.sumValueInReg1(withValue: 2)
//            Instruction.output(valueInRegister: .r3)
//            Instruction.store(valueInRegister: .r3, atMemoryAddress: 0)
//        }
//    }
}

extension Program {
    
    func ForLoop(_ count: UInt8, @ProgramBuilder code: ()->(ProgramCode)) -> ProgramCode {
        
        guard count > 0 else { return ProgramBlock(items: []) }
        
        var instructions: [ProgramCode] = []
        
        // store values in r1, r2 r3
        instructions.append(Instruction.store(valueInRegister: .r1, atMemoryAddress: 21))
        instructions.append(Instruction.store(valueInRegister: .r2, atMemoryAddress: 22))
        instructions.append(Instruction.store(valueInRegister: .r3, atMemoryAddress: 23))
        
        // set and store starting count
        instructions.append(Instruction.load(UInt8.max - count + 1, intoRegister: .r1))
        instructions.append(Instruction.store(valueInRegister: .r1, atMemoryAddress: 25))
                
        instructions.append(code())
        
        // sum count and jump if overflow
        instructions.append(Instruction.load(valueAtMemoryAddress: 25, intoRegister: .r1))
        instructions.append(Instruction.sumValueInReg1(withValue: 1))
        instructions.append(Instruction.halt(given: .aluOverflow))
        instructions.append(Instruction.store(valueInRegister: .r3, atMemoryAddress: 25))
        
        instructions.append(Instruction.jump(toInstructionAdress: 8))
        
        return ProgramBlock(items: instructions)
    }
    
    //    func If(_ register: Register, _ check: IfCheck, _ value: UInt8, @ProgramBuilder code: ()->(ProgramCode)) -> ProgramCode {
    //        var instructions: [ProgramCode] = []
    //        instructions.append(Instruction.load(UInt8.max - count + 1, intoRegister: .r1))
    //        instructions.append(code())
    //        instructions.append(Instruction.sumValueInReg1(withValue: 1))
    //        instructions.append(Instruction.jump(toInstructionAdress: 0, given: .aluOverflow))
    //        return ProgramBlock(items: instructions)
    //    }
    //
    //    enum IfCheck {
    //        case equals
    //    }
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

extension ProgramCode {

    var instructions: [Instruction] {
        if let instruction = self as? Instruction {
            return [instruction]
        }
        if let block = self as? ProgramBlock {
            return block.items.flatMap { $0.instructions }
        }
        return []
    }
}

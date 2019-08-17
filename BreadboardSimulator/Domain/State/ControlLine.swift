//
//  ControlLine.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 2/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

enum ControlLine: Equatable, Codable {
    
    init(from decoder: Decoder) throws {
        throw Error.um
    }
    
    func encode(to encoder: Encoder) throws {
        throw Error.um
    }
    
    enum Error: Swift.Error {
        case um
    }
    
    // Registers
    case reg1In(isOn: Bool)
    case reg1Out(isOn: Bool)
    case reg2In(isOn: Bool)
    case reg2Out(isOn: Bool)
    case reg3In(isOn: Bool)
    case reg3Out(isOn: Bool)
    case reg4In(isOn: Bool)
    case reg4Out(isOn: Bool)
    
    // ROM
    case romAddrIn(isOn: Bool)
    case romValueOut(isOn: Bool)
    case romAddrBit9(isOn: Bool)
    
    // RAM
    case ramAddrIn(isOn: Bool)
    case ramValueIn(isOn: Bool)
    case ramValueOut(isOn: Bool)
    
    // Program Counter
    case pcIn(isOn: Bool)
    case pcOut(isOn: Bool)
    case pcInc(isOn: Bool)
    
    // ALU
    case aluNeg(isOn: Bool)
    case aluOut(isOn: Bool)
    case aluSetFlags(isOn: Bool)
    
    // Other
    case irIn(isOn: Bool)
    case doIn(isOn: Bool)
    case halt(isOn: Bool)
}

// MARK:- Line Type

extension ControlLine {
    
    var isInputLine: Bool {
        switch self {
        case .reg1In, .reg2In, .reg3In, .reg4In, .romAddrIn, .ramAddrIn, .pcIn, .irIn, .doIn, .pcInc, .ramValueIn, .aluSetFlags: return true
        default: return false
        }
    }
    
    var isOutputLine: Bool {
        switch self {
        case .reg1Out, .reg2Out, .reg3Out, .reg4Out, .romValueOut, .ramValueOut, .pcOut, .aluOut: return true
        default: return false
        }
    }
}

// MARK:- On Status

extension ControlLine {
    
    var isOn: Bool {
        switch self {
        case .reg1In(let isOn): return isOn
        case .reg1Out(let isOn): return isOn
        case .reg2In(let isOn): return isOn
        case .reg2Out(let isOn): return isOn
        case .reg3In(let isOn): return isOn
        case .reg3Out(let isOn): return isOn
        case .reg4In(let isOn): return isOn
        case .reg4Out(let isOn): return isOn
        case .romAddrIn(let isOn): return isOn
        case .romValueOut(let isOn): return isOn
        case .romAddrBit9(let isOn): return isOn
        case .ramAddrIn(let isOn): return isOn
        case .ramValueIn(let isOn): return isOn
        case .ramValueOut(let isOn): return isOn
        case .pcIn(let isOn): return isOn
        case .pcOut(let isOn): return isOn
        case .pcInc(let isOn): return isOn
        case .aluNeg(let isOn): return isOn
        case .aluOut(let isOn): return isOn
        case .aluSetFlags(let isOn): return isOn
        case .irIn(let isOn): return isOn
        case .doIn(let isOn): return isOn
        case .halt(let isOn): return isOn
        }
    }
    
    func toggled(on: Bool)-> ControlLine {
        switch self {
        case .reg1In: return .reg1In(isOn: on)
        case .reg1Out: return .reg1Out(isOn: on)
        case .reg2In: return .reg2In(isOn: on)
        case .reg2Out: return .reg2Out(isOn: on)
        case .reg3In: return .reg3In(isOn: on)
        case .reg3Out: return .reg3Out(isOn: on)
        case .reg4In: return .reg4In(isOn: on)
        case .reg4Out: return .reg4Out(isOn: on)
        case .romAddrIn: return .romAddrIn(isOn: on)
        case .romValueOut: return .romValueOut(isOn: on)
        case .romAddrBit9: return .romAddrBit9(isOn: on)
        case .ramAddrIn: return .ramAddrIn(isOn: on)
        case .ramValueIn: return .ramValueIn(isOn: on)
        case .ramValueOut: return .ramValueOut(isOn: on)
        case .pcIn: return .pcIn(isOn: on)
        case .pcOut: return .pcOut(isOn: on)
        case .pcInc: return .pcInc(isOn: on)
        case .aluNeg: return .aluNeg(isOn: on)
        case .aluOut: return .aluOut(isOn: on)
        case .aluSetFlags: return .aluSetFlags(isOn: on)
        case .irIn: return .irIn(isOn: on)
        case .doIn: return .doIn(isOn: on)
        case .halt: return .halt(isOn: on)
        }
    }
}

// MARK:- Mask & Pin

extension ControlLine {
    
    static let numberOfPins: Int = 24
    
    var mask: Int {
        return 1 << (ControlLine.numberOfPins - pin)
    }
    
    var pin: Int {
        switch self {
        case .reg1In: return 18
        case .reg1Out: return 19
        case .reg2In: return 14
        case .reg2Out: return 15
        case .reg3In: return 12
        case .reg3Out: return 13
        case .reg4In: return 10
        case .reg4Out: return 11
        case .romAddrIn: return 4
        case .romValueOut: return 5
        case .romAddrBit9: return 6
        case .ramAddrIn: return 1
        case .ramValueIn: return 2
        case .ramValueOut: return 3
        case .pcIn: return 22
        case .pcOut: return 20
        case .pcInc: return 21
        case .aluNeg: return 16
        case .aluOut: return 17
        case .aluSetFlags: return 23
        case .irIn: return 8
        case .doIn: return 9
        case .halt: return 7
        }
    }
}

// MARK:- Title

extension ControlLine {
    
    var title: String {
        switch self {
        case .reg1In: return "Register 1 In"
        case .reg1Out: return "Register 1 Out"
        case .reg2In: return "Register 2 In"
        case .reg2Out: return "Register 2 Out"
        case .reg3In: return "Register 3 In"
        case .reg3Out: return "Register 3 Out"
        case .reg4In: return "Register 4 In"
        case .reg4Out: return "Register 4 Out"
        case .romAddrIn: return "ROM Address In"
        case .romValueOut: return "ROM Value Out"
        case .romAddrBit9: return "ROM Address 9th Bit"
        case .ramAddrIn: return "RAM Address In"
        case .ramValueIn: return "RAM Value In"
        case .ramValueOut: return "RAM Value Out"
        case .pcIn: return "Program Counter In"
        case .pcOut: return "Program Counter Out"
        case .pcInc: return "Program Counter Increment"
        case .aluNeg: return "ALU Subtraction On"
        case .aluOut: return "ALU Out"
        case .aluSetFlags: return "ALU Set Flags"
        case .irIn: return "Instruction Register In"
        case .doIn: return "Decimal Output In"
        case .halt: return "Halt"
        }
    }
}

// MARK:- Descriptions

extension ControlLine {
    
    var description: String {
        switch self {
        case .reg1In: return "Loads the value on the bus into Register1"
        case .reg1Out: return "Outputs the value stored in Register1 onto the bus"
        case .reg2In: return "Loads the value on the bus into Register2"
        case .reg2Out: return "Outputs the value stored in Register2 onto the bus"
        case .reg3In: return "Loads the value on the bus into Register3"
        case .reg3Out: return "Outputs the value stored in Register3 onto the bus"
        case .reg4In: return "Loads the value on the bus into Register4"
        case .reg4Out: return "Outputs the value stored in Register4 onto the bus"
        case .romAddrIn: return "Reads the value on the bus into the ROM address register"
        case .romValueOut: return "Outputs to the bus the value stored in ROM at the current address stored in the RAM address register"
        case .romAddrBit9: return "Turns on the 9th bit of the ROM, effectively switching to an all new 8-bit addressable ROM. This is used to store the payload of instructions, allowing for a 16bit instruction length."
        case .ramAddrIn: return "Reads the value on the bus into the RAM address register."
        case .ramValueIn: return "Reads the value on the bus into RAM at the current address stored in the RAM address register."
        case .ramValueOut: return "Outputs to the bus the value stored in RAM at the current address stored in the RAM address register."
        case .pcIn: return "Loads the value on the bus into the program counter"
        case .pcOut: return "Outputs the value stored in the program counter onto the bus"
        case .pcInc: return "Increments the program counter"
        case .aluNeg: return "Switches on subtraction mode for the ALU, resulting in it’s output value being the result of Register-A’s value - Register-B’s value"
        case .aluOut: return "Outputs the value resulting from the ALU logic on Register-A and Register-B onto the bus"
        case .aluSetFlags: return "Updates the values stored in the flags register. These values are based on the current value of the ALU, meaning this control line must be taken high after an arithmetic operation has been performed."
        case .irIn: return "Loads the value on the bus into the instruction register"
        case .doIn: return "Loads the value on the bus into the decimal output register, resulting in it’s value appearing the decimal display"
        case .halt: return "Stops the clock, resulting in the pausing of execution"
        }
    }
}

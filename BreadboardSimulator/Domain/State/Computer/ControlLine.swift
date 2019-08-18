//
//  ControlLine.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 2/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct ControlLine: Equatable, Codable {
    let type: ControlLineType
    var isOn: Bool
}

enum ControlLineType: String, Equatable, Codable {
    
    // Registers
    case reg1In
    case reg1Out
    case reg2In
    case reg2Out
    case reg3In
    case reg3Out
    case reg4In
    case reg4Out
    
    // ROM
    case romAddrIn
    case romValueOut
    case romAddrBit9
    
    // RAM
    case ramAddrIn
    case ramValueIn
    case ramValueOut
    
    // Program Counter
    case pcIn
    case pcOut
    case pcInc
    
    // ALU
    case aluNeg
    case aluOut
    case aluSetFlags
    
    // Other
    case irIn
    case doIn
    case halt
}

// MARK:- Line Type

extension ControlLineType {
    
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

// MARK:- Mask & Pin

extension ControlLineType {
    
    static let numberOfPins: Int = 24
    
    var mask: Int {
        return 1 << (ControlLineType.numberOfPins - pin)
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

extension ControlLineType {
    
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

extension ControlLineType {
    
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

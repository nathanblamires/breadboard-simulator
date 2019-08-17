//
//  Computer.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 4/1/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct ComputerState: Equatable, Codable {
    
    var finished: Bool = false
    var clockVoltage: ClockVoltage = .low
    
    var register1: UInt8 = 0
    var register2: UInt8 = 0
    var register3: UInt8 = 0
    var register4: UInt8 = 0
    
    var programCounter: UInt8 = 0
    var instructionRegister: UInt8 = 0
    var stepCounter: UInt8 = 0
    var decimalDisplay: UInt8 = 0
    
    var ramAddress: UInt8 = 0
    var ramValues: [UInt8] = Array(repeating: 0, count: 256)
    var romAddress: UInt8 = 0
    var romValues: [UInt8] = Array(repeating: 0, count: 512)
    
    var isOverflow: Bool = false
    var isZero: Bool = false
    
    var aluOutput: UInt8 {
        let value = isALUNegFlagOn ? Int(register1) - Int(register2) : Int(register1) + Int(register2)
        return UInt8(value & 0b1111_1111)
    }
    
    var currentRAMValue: UInt8 {
        return ramValues[Int(ramAddress)]
    }
    var currentROMValue: UInt8 {
        return isROMAddrBit9On ? romValues[Int(romAddress) + 256] : romValues[Int(romAddress)]
    }

    var controlLines: [ControlLine] = [
        
        // Registers
        .reg1In(isOn: false),
        .reg1Out(isOn: false),
        .reg2In(isOn: false),
        .reg2Out(isOn: false),
        .reg3In(isOn: false),
        .reg3Out(isOn: false),
        .reg4In(isOn: false),
        .reg4Out(isOn: false),
        
        // ROM
        .romAddrIn(isOn: false),
        .romValueOut(isOn: false),
        .romAddrBit9(isOn: false),
        
        // RAM
        .ramAddrIn(isOn: false),
        .ramValueIn(isOn: false),
        .ramValueOut(isOn: false),
        
        // Program Counter
        .pcIn(isOn: false),
        .pcOut(isOn: false),
        .pcInc(isOn: false),
        
        // ALU
        .aluNeg(isOn: false),
        .aluOut(isOn: false),
        .aluSetFlags(isOn: false),
        
        // Other
        .irIn(isOn: false),
        .doIn(isOn: false),
        .halt(isOn: false)
    ]
    
    // DMD
    var memoryMappedIOActive: Bool = false
    var ioAddress: UInt8 = 0
    var ioValues: [UInt8] = Array(repeating: 0, count: 128)
    var ioCurrentValue: UInt8 {
        return ioValues[Int(ioAddress)]
    }
}

// MARK: Helper Computed Properties

extension ComputerState {
    
    internal var isALUNegFlagOn: Bool {
        for controlLine in controlLines {
            if case .aluNeg(let isOn) = controlLine { return isOn }
        }
        fatalError("Could not find the aluNeg control line")
    }
    
    internal var isROMAddrBit9On: Bool {
        for controlLine in controlLines {
            if case .romAddrBit9(let isOn) = controlLine { return isOn }
        }
        fatalError("Could not find the romAddrBit9 control line")
    }
    
    internal var isHaltOn: Bool {
        for controlLine in controlLines {
            if case .halt(let isOn) = controlLine { return isOn }
        }
        fatalError("Could not find the romAddrBit9 control line")
    }
}

enum ClockVoltage: String, Equatable, Codable {
    case high
    case low
}

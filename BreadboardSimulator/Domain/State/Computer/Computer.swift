//
//  Computer.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 4/1/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct Computer: Equatable, Codable {
    
    var finished: Bool = false
    var clockVoltage: ClockVoltage = .low
    
    var register1: UInt8 = 0
    var register2: UInt8 = 0
    var register3: UInt8 = 0
    var register4: UInt8 = 0
    
    var programCounter: UInt8 = 0
    var instructionRegister: UInt8 = 0
    var decimalDisplay: UInt8 = 0
    var stepCounter: UInt8 = 0
    
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

    var controlLines: [ControlLine: Bool] = [
        
        // Registers
        .reg1In: false,
        .reg1Out: false,
        .reg2In: false,
        .reg2Out: false,
        .reg3In: false,
        .reg3Out: false,
        .reg4In: false,
        .reg4Out: false,
        
        // ROM
        .romAddrIn: false,
        .romValueOut: false,
        .romAddrBit9: false,
        
        // RAM
        .ramAddrIn: false,
        .ramValueIn: false,
        .ramValueOut: false,
        
        // Program Counter
        .pcIn: false,
        .pcOut: false,
        .pcInc: false,
        
        // ALU
        .aluNeg: false,
        .aluOut: false,
        .aluSetFlags: false,
        
        // Other
        .irIn: false,
        .doIn: false,
        .halt: false
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

extension Computer {
    
    internal var isALUNegFlagOn: Bool {
        controlLines.first(where: { $0.key == .aluNeg })!.value
    }
    
    internal var isROMAddrBit9On: Bool {
        controlLines.first(where: { $0.key == .romAddrBit9 })!.value
    }
    
    internal var isHaltOn: Bool {
        controlLines.first(where: { $0.key == .halt })!.value
    }
}

enum ClockVoltage: String, Equatable, Codable {
    case high
    case low
}

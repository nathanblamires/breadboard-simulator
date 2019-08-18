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
        ControlLine(type: .reg1In, isOn: false),
        ControlLine(type: .reg1Out, isOn: false),
        ControlLine(type: .reg2In, isOn: false),
        ControlLine(type: .reg2In, isOn: false),
        ControlLine(type: .reg3In, isOn: false),
        ControlLine(type: .reg3Out, isOn: false),
        ControlLine(type: .reg4In, isOn: false),
        ControlLine(type: .reg4Out, isOn: false),
        
        // ROM
        ControlLine(type: .romAddrIn, isOn: false),
        ControlLine(type: .romValueOut, isOn: false),
        ControlLine(type: .romAddrBit9, isOn: false),
        
        // RAM
        ControlLine(type: .ramAddrIn, isOn: false),
        ControlLine(type: .ramValueIn, isOn: false),
        ControlLine(type: .ramValueOut, isOn: false),
        
        // Program Counter
        ControlLine(type: .pcIn, isOn: false),
        ControlLine(type: .pcOut, isOn: false),
        ControlLine(type: .pcInc, isOn: false),
        
        // ALU
        ControlLine(type: .aluNeg, isOn: false),
        ControlLine(type: .aluOut, isOn: false),
        ControlLine(type: .aluSetFlags, isOn: false),
        
        // Other
        ControlLine(type: .irIn, isOn: false),
        ControlLine(type: .doIn, isOn: false),
        ControlLine(type: .halt, isOn: false)
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
        controlLines.first(where: { $0.type == .aluNeg })!.isOn
    }
    
    internal var isROMAddrBit9On: Bool {
        controlLines.first(where: { $0.type == .romAddrBit9 })!.isOn
    }
    
    internal var isHaltOn: Bool {
        controlLines.first(where: { $0.type == .halt })!.isOn
    }
}

enum ClockVoltage: String, Equatable, Codable {
    case high
    case low
}

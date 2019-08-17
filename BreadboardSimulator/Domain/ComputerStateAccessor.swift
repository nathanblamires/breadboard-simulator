//
//  AppStateAccessor.swift
//  8BitSimulator
//
//  Created by Nathan Blamires on 9/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct ComputerStateAccessor {
    
    static let shared = ComputerStateAccessor()
    
    var state: ComputerState {
        return Store.instance.appState.computerState
    }
    
    func updateComputerState(_ newComputerState: ComputerState) {
        Store.instance.appState.computerState = newComputerState
    }
}

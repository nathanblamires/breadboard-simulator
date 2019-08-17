//
//  UseCases+Init.swift
//  BreadboardSimulatorTests
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

@testable import BreadboardSimulator

extension UseCases {
    
    static func createForTests(userDefaults: UserDefaults) -> UseCases {
        return UseCases(
            saveAppStateUseCase: SaveAppStateUseCase(userDefaults: userDefaults)
        )
    }
}

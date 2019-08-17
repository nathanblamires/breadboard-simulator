//
//  AppState.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct AppState: Equatable, Codable {
    let version: Version = { try! Version(BundledConfig.versionString) }()
    let buildString: String = { BundledConfig.buildString }()
    var testValue: Int = 0
}

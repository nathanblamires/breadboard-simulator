//
//  Environment.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

enum Environment: String, Codable {
    case development
    case test
    case production
}

extension Environment {
    
    var plistFilename: String {
        switch self {
        case .development: return "Dev"
        case .test: return "Test"
        case .production: return "Prod"
        }
    }
}

extension Environment: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .development: return "Development"
        case .test: return "Test"
        case .production: return "Production"
        }
    }
}

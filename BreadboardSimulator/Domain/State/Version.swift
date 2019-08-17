//
//  Version.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

struct Version: Codable {
        
    // Details of how semantic versioning works at: https://semver.org/
    
    let major: Int
    let minor: Int
    let patch: Int
    
    let prerelease: String?
    let metadata: String?
    
    var isPrerelease: Bool { !prereleaseIdentifiers.isEmpty }
    
    init(major: Int, minor: Int = 0, patch: Int = 0, prerelease: String? = nil, metadata: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = prerelease
        self.metadata = metadata
    }
}

// MARK:- CustomStringConvertible

extension Version: CustomStringConvertible {
    
    var description: String {
        var text = "\(major).\(minor).\(patch)"
        if let prerelease = prerelease {
            text += "-\(prerelease)"
        }
        if let metadata = metadata {
            text += "+\(metadata)"
        }
        return text
    }
}

// MARK: - Comparable

func === (lhs: Version, rhs: Version) -> Bool {
    (lhs == rhs) && (lhs.metadata == rhs.metadata)
}

func !==(lhs: Version, rhs: Version) -> Bool {
    return !(lhs === rhs)
}

extension Version: Comparable {
    
    static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major &&
            lhs.minor == rhs.minor &&
            lhs.patch == rhs.patch &&
            lhs.prerelease == rhs.prerelease
    }
    
    static func < (lhs: Version, rhs: Version) -> Bool {
          
        // handle major/minor/patch difference
        let lhsComponents = [lhs.major, lhs.minor, lhs.patch]
        let rhsComponents = [rhs.major, rhs.minor, rhs.patch]
        if let differingComponent = zip(lhsComponents, rhsComponents).first(where: { $0 != $1 }) {
            return differingComponent.0 < differingComponent.1
        }

        // handle prerelease difference
        switch (lhs.isPrerelease, rhs.isPrerelease) {
        case (true, true):
            return isPrerelease(lhs.prerelease!, lessThan: rhs.prerelease!)
        case (true, false):
            return true
        default:
            return false
        }
    }
    
    static func isPrerelease(_ lhs: String, lessThan rhs: String) -> Bool {
        
        let lhsIds = lhs.split(separator: ".").map { String($0) }
        let rhsIds = rhs.split(separator: ".").map { String($0) }
        guard let differingPair = zip(lhsIds, rhsIds).first(where: { $0 != $1 }) else {
            return lhs.count < rhs.count
        }
        
        let leftNumber = Int(differingPair.0) ?? Int.max
        let rightNumber = Int(differingPair.1) ?? Int.max
        
        if leftNumber != rightNumber {
            return leftNumber < rightNumber
        }
        return differingPair.0 < differingPair.1
    }
    
    private var prereleaseIdentifiers: [String] {
        prerelease?.split(separator: ".").map { String($0) } ?? []
    }
}

// MARK:- ExpressibleByStringLiteral

extension Version: ExpressibleByStringLiteral {
    
    typealias StringLiteralType = String
    
    init(_ value: String, strict: Bool = false) throws {
        
        let scanner = Scanner(string: value)
        
        major = try scanner.nextNumber()
        
        do {
            try scanner.advance(over: ".")
            minor = try scanner.nextNumber()
        } catch Scanner.Error.valueNotAtScanLocation {
            if strict { throw Error.malformedVersionString }
            minor = 0
        }
        
        do {
            try scanner.advance(over: ".")
            patch = try scanner.nextNumber()
        } catch Scanner.Error.valueNotAtScanLocation {
            if strict { throw Error.malformedVersionString }
            patch = 0
        }
        
        let isPrerelease = (try? scanner.advance(over: "-")) != nil
        prerelease = isPrerelease ? try scanner.nextIdentifiers().joined(separator: ".") : nil
        let hasMetadata = (try? scanner.advance(over: "+")) != nil
        metadata = hasMetadata ? try scanner.nextIdentifiers(allowLeadingZeros: true).joined(separator: ".") : nil
        guard scanner.isAtEnd else { throw Error.malformedVersionString }
    }
    
    public init(stringLiteral value: String) {
        do {
            try self.init(value)
        } catch {
            Logger.error(topic: .other, message: "Malformed version string \(value). Setting to \"0.0.0\".")
            self.init(major: 0)
        }
    }
    
    enum Error: Swift.Error {
        case malformedVersionString
    }
}

// MARK:- Scanner Helper Functions

extension Scanner {
    
    fileprivate func nextNumber() throws -> Int {
        var component: NSString?
        scanCharacters(from: CharacterSet.decimalDigits, into: &component)
        guard let string = component as String?, let number = Int(string) else {
            throw Error.invalidNumber
        }
        if number != 0 && string.first == "0" {
            throw Error.leadingZerosProhibited
        }
        return number
    }
    
    fileprivate func nextIdentifier(allowLeadingZero: Bool = false) throws -> String {
        var string: NSString?
        scanCharacters(from: CharacterSet.indentifier, into: &string)
        guard let identifier = string as String?, !identifier.isEmpty else {
            throw Error.invalidIdentifier
        }
        if !allowLeadingZero, let asInt = Int(identifier), asInt != 0, identifier.first == "0" {
            throw Error.leadingZerosProhibited
        }
        return identifier
    }
    
    fileprivate func nextIdentifiers(allowLeadingZeros: Bool = false) throws -> [String] {
        var identifiers: [String] = []
        repeat {
            identifiers.append(try nextIdentifier(allowLeadingZero: allowLeadingZeros))
            guard scanString(".", into: nil) else { break }
        } while (true)
        return identifiers
    }
    
    fileprivate func advance(over value: String) throws {
        guard scanString(value, into: nil) else {
            throw Error.valueNotAtScanLocation
        }
    }
    
    enum Error: Swift.Error {
        case leadingZerosProhibited
        case invalidNumber
        case invalidIdentifier
        case valueNotAtScanLocation
    }
}

// MARK:- Additional CharacterSet Definition

extension CharacterSet {
    
    fileprivate static let indentifier: CharacterSet = {
        let characters = "-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return NSMutableCharacterSet(charactersIn: characters) as CharacterSet
    }()
}


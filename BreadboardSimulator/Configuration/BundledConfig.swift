//
//  BundledConfig.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

// MARK: - Public

extension BundledConfig {
    static var versionString: String { castedValue(for: .versionString, as: String.self)! }
    static var buildString: String { castedValue(for: .buildString, as: String.self)! }
}

// MARK: - Private

private enum BundledConfigKey: String, CaseIterable {
    case versionString = "CFBundleShortVersionString"
    case buildString = "CFBundleVersion"
}

class BundledConfig {

    static private func castedArray<T>(for key: BundledConfigKey) -> [T]? {
        guard let array = castedValue(for: key, as: [Any].self) else {
            return nil
        }
        let castedArray = array.compactMap { $0 as? T }
        return (array.count == castedArray.count) ? castedArray : nil
    }

    static private func castedDictionary<T>(for key: BundledConfigKey) -> [String: T]? {
        guard let dictionary = castedValue(for: key, as: [String: Any].self) else {
            return nil
        }
        let castedDictionary = dictionary.compactMapValues { $0 as? T }
        return (dictionary.count == castedDictionary.count) ? castedDictionary : nil
    }

    static private func castedValue<T>(for key: BundledConfigKey, as _: T.Type) -> T? {
        do {
            guard let anyValue = envSpecificInfo[key.rawValue] ?? appInfo[key.rawValue] else {
                throw Error.invalidKey
            }
            guard let castedValue = anyValue as? T else {
                throw Error.castingError
            }
            return castedValue
        } catch {
            Logger.error(topic: .other, message: "Error retrieving configuration: \(error)")
            return nil
        }
    }

    enum Error: Swift.Error {
        case castingError
        case invalidKey
    }
}

// MARK: - Info Plist Data

extension BundledConfig {

    static private var appInfo: [String: Any] {
        return Bundle.main.infoDictionary!
    }

    static private var envSpecificInfo: [String: Any] {
        guard
            let path = Bundle.main.path(forResource: environment.plistFilename, ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            Logger.error(topic: .other, message: "Failed to retrieve environment specific plist")
            return [:]
        }
        return dictionary
    }
}
